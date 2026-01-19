import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FleetMap extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subdomains = isDark ? const ['a', 'b', 'c'] : const ['a', 'b', 'c'];

    Widget map = FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center ?? const LatLng(48.8566, 2.3522), // Default Paris
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
        if (route != null && route!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route!,
                color: Colors.blue,
                strokeWidth: 8.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (center != null)
              Marker(
                point: center!,
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
            if (destination != null)
              Marker(
                point: destination!,
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
        end: isNavigationLocked ? - 0.7 : 0,
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
              ..scale(1.0 + (value.abs() * 1.5), 1.0 + (value.abs() * 1.5), 1.0 + (value.abs() * 1.5)), // Scale up significantly to fill screen voids
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
