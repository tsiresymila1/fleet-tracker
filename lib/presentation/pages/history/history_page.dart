import 'package:easy_localization/easy_localization.dart';
import 'package:fleet_tracker/core/utils/map_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/api_responses.dart';
import '../../bloc/history_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  final MapController _mapController = MapController();
  bool _showMap = true;

  @override
  void initState() {
    super.initState();
    // Default: yesterday to today
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 1));

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  void _loadHistory() {
    context.read<HistoryBloc>().add(
      HistoryEvent.loadHistory(startDate: _startDate, endDate: _endDate),
    );
  }

  void _zoomIn() {
    _mapController.animateTo(
      dest: _mapController.camera.center,
      zoom: _mapController.camera.zoom + 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _zoomOut() {
    _mapController.animateTo(
      dest: _mapController.camera.center,
      zoom: _mapController.camera.zoom - 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppTheme.primaryPink),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadHistory();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subdomains = isDark ? const ['a', 'b', 'c'] : const ['a', 'b', 'c'];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('history_title'.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(_showMap ? Icons.list : Icons.map),
              onPressed: () => setState(() => _showMap = !_showMap),
              tooltip: _showMap
                  ? 'history_show_list'.tr()
                  : 'history_show_map'.tr(),
            ),
          ],
        ),
        body: Column(
          children: [
            // Date Range Selector
            _buildDateRangeSelector(),

            // Content
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (loaded) => _showMap
                        ? _buildMapView(loaded.positions, isDark, subdomains)
                        : _buildListView(loaded.positions),
                    empty: (_) => _buildEmptyState(),
                    error: (error) => _buildErrorState(error.message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: _selectDateRange,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.date_range, color: AppTheme.primaryPink),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(
    List<PositionData> positions,
    bool isDark,
    List<String> subdomains,
  ) {
    if (positions.isEmpty) return _buildEmptyState();

    final points = positions
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    // Fit map to show all points
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (points.isEmpty) return;

      try {
        final bounds = LatLngBounds.fromPoints(points);
        // Check if valid bounds for fitting (not collapsed to a point)
        if (bounds.north != bounds.south || bounds.east != bounds.west) {
          _mapController.fitCamera(
            CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
          );
        } else {
          _mapController.move(points.first, 15);
        }
      } catch (e) {
        debugPrint('Map camera error: $e');
        _mapController.move(points.first, 15);
      }
    });

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: points.isNotEmpty
                ? points.first
                : const LatLng(0, 0),
            initialZoom: 14,
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
                heroTag: 'zoom_in',
                onPressed: _zoomIn,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: _zoomOut,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<PositionData> positions) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final pos = positions[index];
        final time = DateTime.tryParse(pos.recordedAt);
        final timeStr = time != null
            ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
            : pos.recordedAt;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: pos.status == 'moving'
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              child: Icon(
                pos.status == 'moving' ? Icons.directions_car : Icons.pause,
                color: pos.status == 'moving' ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              '${pos.status ?? 'unknown'} • ${(pos.speed ?? 0 * 3.6).toStringAsFixed(1)} km/h',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              timeStr,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text(
            'history_no_data'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.red.shade300),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadHistory, child: Text('retry'.tr())),
        ],
      ),
    );
  }
}
