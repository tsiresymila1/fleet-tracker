import 'package:easy_localization/easy_localization.dart';
import 'package:fleet_tracker/core/api/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import 'map_widget.dart';
import 'navigation_search_bar.dart';
import 'navigation_info_panel.dart';
import 'navigation_status_panel.dart';
import 'navigation_controls.dart';
import 'navigation_compass.dart';
import 'navigation_side_buttons.dart';
import 'navigation_step_panel.dart';

class NavigationView extends StatelessWidget {
  final LatLng? currentLatLng;
  final LatLng? destination;
  final List<LatLng>? route;
  final AnimatedMapController mapController;
  final bool isNavigationLocked;
  final bool isLoadingRoute;
  final NavigationService navService;
  final TextEditingController searchController;
  final String speedKmh;
  final double heading;
  
  final Function(Map<String, dynamic>) onPlaceSelected;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onToggleLock;
  final VoidCallback onLocateMe;
  final Function(bool) onLoadingChanged;
  final VoidCallback onStopNavigation;

  const NavigationView({
    super.key,
    required this.currentLatLng,
    required this.destination,
    required this.route,
    required this.mapController,
    required this.isNavigationLocked,
    required this.isLoadingRoute,
    required this.navService,
    required this.searchController,
    required this.speedKmh,
    required this.heading,
    required this.onPlaceSelected,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onToggleLock,
    required this.onLocateMe,
    required this.onLoadingChanged,
    required this.onStopNavigation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FleetMap(
          center: currentLatLng,
          destination: destination,
          route: route,
          mapController: mapController.mapController,
          isNavigationLocked: isNavigationLocked,
        ),

        // Background Gradient for Header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 180,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Info Overlay
        Positioned(
          top: MediaQuery.of(context).padding.top + 100,
          left: 16,
          child: NavigationInfoPanel(
            speedKmh: speedKmh,
            heading: heading,
            speedLabel: 'device_speed'.tr(),
            headingLabel: 'device_heading'.tr(),
          ),
        ),

        // Search Bar
        Positioned(
          top: MediaQuery.of(context).padding.top + 15,
          left: 16,
          right: 80,
          child: NavigationSearchBar(
            navService: navService,
            isLoading: isLoadingRoute,
            onSearchStarted: () => onLoadingChanged(true),
            onSearchEnded: () => onLoadingChanged(false),
            onPlaceSelected: onPlaceSelected,
          ),
        ),

        // Bottom Status Panel
        NavigationStatusPanel(route: route),

        // Compass
        Positioned(
          top: MediaQuery.of(context).padding.top + 85,
          right: 16,
          child: NavigationCompass(
            mapController: mapController.mapController,
            onResetRotation: () => mapController.mapController.rotate(0),
          ),
        ),

        // Top Right Buttons
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          right: 16,
          child: NavigationSideButtons(
            onSettingsPressed: () => context.push('/settings'),
            onHistoryPressed: () => context.push('/history'),
          ),
        ),

        // Controls
        Positioned(
          bottom: 120,
          right: 16,
          child: NavigationControls(
            isNavigationLocked: isNavigationLocked,
            onZoomIn: onZoomIn,
            onZoomOut: onZoomOut,
            onToggleLock: onToggleLock,
            onLocateMe: onLocateMe,
          ),
        ),

        // Navigation Steps Panel
        Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child: NavigationStepPanel(
            route: route,
            destinationText: searchController.text,
            onStopNavigation: onStopNavigation,
          ),
        ),
      ],
    );
  }
}
