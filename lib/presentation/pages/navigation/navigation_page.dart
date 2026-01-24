import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/api/navigation_service.dart';
import '../../bloc/tracking_bloc.dart';
import 'widgets/navigation_view.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  final NavigationService _navService = NavigationService();
  final TextEditingController _searchController = TextEditingController();
  late final _mapController = AnimatedMapController(vsync: this);

  LatLng? _destination;
  List<LatLng>? _route;
  bool _isLoadingRoute = false;
  LatLng? _initialPosition;
  bool _isNavigationLocked = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _loadSavedRoute();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _requestPermission();
    await _getCurrentLocation();
    await _checkConnectivityAndSync();
  }

  Future<void> _checkConnectivityAndSync() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('device_id') != null && prefs.getString('secret_key') != null) {
        debugPrint('Online and registered. Syncing...');
      }
    } catch (e) {
      debugPrint('Sync check failed: $e');
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() => _initialPosition = LatLng(position.latitude, position.longitude));
        if (_initialPosition != null) _mapController.mapController.move(_initialPosition!, 15);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _loadSavedRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final destLat = prefs.getDouble('dest_lat');
    final destLng = prefs.getDouble('dest_lng');
    final routeJson = prefs.getString('saved_route');
    if (destLat != null && destLng != null && routeJson != null) {
      setState(() {
        _destination = LatLng(destLat, destLng);
        final List<dynamic> points = jsonDecode(routeJson);
        _route = points.map((p) => LatLng(p[0], p[1])).toList();
      });
    }
  }

  Future<void> _saveRoute(LatLng dest, List<LatLng> route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('dest_lat', dest.latitude);
    await prefs.setDouble('dest_lng', dest.longitude);
    final routePoints = route.map((p) => [p.latitude, p.longitude]).toList();
    await prefs.setString('saved_route', jsonEncode(routePoints));
  }

  void _toggleNavigationLock(LatLng? currentPos) {
    if (currentPos == null) return;
    setState(() => _isNavigationLocked = !_isNavigationLocked);
    _mapController.mapController.move(currentPos, 18);
  }

  Future<bool> _onWillPop() async {
    if (_route == null || _route!.isEmpty) return true;
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('nav_exit_title'.tr()),
        content: Text('nav_exit_message'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('exit'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  Future<void> _handlePlaceSelected(Map<String, dynamic> place, LatLng currentPos) async {
    final dest = LatLng(double.parse(place['lat']), double.parse(place['lon']));
    setState(() {
      _destination = dest;
      _isLoadingRoute = true;
      _searchController.text = place['display_name'];
    });
    _mapController.mapController.move(dest, 15);
    final route = await _navService.getRoute(currentPos, dest);
    if (mounted) {
      setState(() {
        _route = route;
        _isLoadingRoute = false;
        _isNavigationLocked = true;
      });
      if (route.isNotEmpty) {
        _saveRoute(dest, route);
        final bounds = LatLngBounds.fromPoints(route);
        _mapController.mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)));
      }
    }
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _onWillPop() && context.mounted) Navigator.of(context).pop(result);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<TrackingBloc, TrackingState>(
            listener: (context, state) {
              if (_isNavigationLocked) {
                state.mapOrNull(active: (s) {
                  final pos = s.currentPosition;
                  _mapController.animateTo(
                    dest: LatLng(pos.latitude, pos.longitude),
                    zoom: 18.0,
                    rotation: -(pos.heading ?? 0),
                    duration: const Duration(milliseconds: 1000),
                  );
                });
              }
            },
            builder: (context, state) {
              final position = state.maybeMap(active: (s) => s.currentPosition, orElse: () => null);
              final currentLatLng = position != null ? LatLng(position.latitude, position.longitude) : _initialPosition;
              final speedKmh = ((position?.speed ?? 0.0) * 3.6).toStringAsFixed(1);
              final heading = position?.heading ?? 0.0;

              return NavigationView(
                currentLatLng: currentLatLng,
                destination: _destination,
                route: _route,
                mapController: _mapController,
                isNavigationLocked: _isNavigationLocked,
                isLoadingRoute: _isLoadingRoute,
                navService: _navService,
                searchController: _searchController,
                speedKmh: speedKmh,
                heading: heading,
                onPlaceSelected: (place) => currentLatLng != null ? _handlePlaceSelected(place, currentLatLng) : null,
                onZoomIn: () => _mapController.animateTo(dest: _mapController.mapController.camera.center, zoom: _mapController.mapController.camera.zoom + 1),
                onZoomOut: () => _mapController.animateTo(dest: _mapController.mapController.camera.center, zoom: _mapController.mapController.camera.zoom - 1),
                onToggleLock: () => _toggleNavigationLock(currentLatLng),
                onLocateMe: () => currentLatLng != null ? _mapController.animateTo(dest: currentLatLng, zoom: 18) : _getCurrentLocation(),
                onLoadingChanged: (loading) => setState(() => _isLoadingRoute = loading),
                onStopNavigation: () async {
                  if (await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text('nav_stop_title'.tr()), content: Text('nav_stop_message'.tr()), actions: [TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('cancel'.tr())), TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('stop'.tr(), style: const TextStyle(color: Colors.red)))])) == true) {
                    setState(() { _route = null; _destination = null; _isNavigationLocked = false; _searchController.clear(); });
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('dest_lat'); await prefs.remove('dest_lng'); await prefs.remove('saved_route');
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
