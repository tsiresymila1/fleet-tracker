import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/api_responses.dart';

class HistoryMapView extends StatelessWidget {
  final List<PositionData> positions;
  final AnimatedMapController mapController;
  final bool isDark;
  final List<String> subdomains;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const HistoryMapView({
    super.key,
    required this.positions,
    required this.mapController,
    required this.isDark,
    required this.subdomains,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const Center(child: Text('No positions found'));
    }

    final points =
        positions.map((p) => LatLng(p.latitude, p.longitude)).toList();

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController.mapController,
          options: MapOptions(
            initialCenter: points.isNotEmpty ? points.first : const LatLng(0, 0),
            initialZoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileBuilder: (context, tileWidget, tile) {
                if (!isDark) {
                  return tileWidget;
                }
                return ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -0.5, 0.0, 0.0, 0.0, 150,
                    0.0, -0.5, 0.0, 0.0, 150,
                    0.0, 0.0, -0.5, 0.0, 150,
                    0.0, 0.0, 0.0, 1.0, 0,
                  ]),
                  child: tileWidget,
                );
              },
              subdomains: subdomains,
              userAgentPackageName: 'ts.mila.fleet_tracker',
              tileProvider: NetworkTileProvider(),
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 4,
                  color: AppTheme.primaryPink,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                if (points.isNotEmpty)
                  Marker(
                    point: points.first,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                if (points.length > 1)
                  Marker(
                    point: points.last,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.stop_circle,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 60,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'history_zoom_in',
                onPressed: onZoomIn,
                backgroundColor: Theme.of(context).cardColor,
                child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'history_zoom_out',
                onPressed: onZoomOut,
                backgroundColor: Theme.of(context).cardColor,
                child: Icon(Icons.remove, color: Theme.of(context).iconTheme.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
