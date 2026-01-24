import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FleetMap extends StatefulWidget {
  final LatLng? center;
  final LatLng? destination;
  final List<LatLng>? route;
  final MapController? mapController;
  final bool isNavigationLocked;

  const FleetMap({
    super.key,
    this.center,
    this.destination,
    this.route,
    this.mapController,
    this.isNavigationLocked = false,
  });

  @override
  State<FleetMap> createState() => _FleetMapState();
}

class _FleetMapState extends State<FleetMap> {
  @override
  void didUpdateWidget(FleetMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Move map if:
    // 1. Navigation is locked (follow mode)
    // 2. This is the first time we get a valid center (initial localtion fix)
    bool shouldMove = widget.center != null && widget.center != oldWidget.center;
    bool isFirstFix = oldWidget.center == null && widget.center != null;
    
    if (shouldMove && (widget.isNavigationLocked || isFirstFix)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.mapController?.move(
            widget.center!, 
            widget.mapController!.camera.zoom,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subdomains = isDark ? const ['a', 'b', 'c'] : const ['a', 'b', 'c'];
    Widget map = FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: widget.center ?? const LatLng(48.8566, 2.3522), // Default Paris
        initialZoom: 15,
        // Allow rotation now that we have a compass
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tileBuilder: (context, tileWidget, tile) {
            if (!isDark) {
              return tileWidget; // Return normal map if not dark mode
            }
            return ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                // Deep Dark Blue/Grey Inversion Matrix
                -0.5, 0.0, 0.0, 0.0, 150, // Darkens the inverted red
                0.0, -0.5, 0.0, 0.0, 150, // Darkens the inverted green
                0.0, 0.0, -0.5, 0.0, 150, // Darkens the inverted blue
                0.0, 0.0, 0.0, 1.0, 0,
              ]),
              child: tileWidget,
            );
          },
          subdomains: subdomains,
          userAgentPackageName: 'ts.mila.fleet_tracker',
          tileProvider: NetworkTileProvider(),
        ),
        if (widget.route != null && widget.route!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.route!,
                color: Colors.blue,
                strokeWidth: 8.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (widget.center != null)
              Marker(
                point: widget.center!,
                width: 40,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
            if (widget.destination != null)
              Marker(
                point: widget.destination!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
          ],
        ),
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 0,
        end: widget.isNavigationLocked ? - 0.7 : 0,
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        return Container(
          color: isDark ? const Color(0xFF18181B) : Colors.grey[100],
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(value)
              ..scale(1.0 + (value.abs() * 1.5), 1.0 + (value.abs() * 1.5), 1.0 + (value.abs() * 1.5)), 
            child: child,
          ),
        );
      },
      child: map,
    );
  }
}

class NetworkTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coordinates, options));
  }
}
