import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../bloc/history_bloc.dart';
import 'widgets/history_date_range_picker.dart';
import 'widgets/history_list_view.dart';
import 'widgets/history_map_view.dart';
import 'widgets/history_states.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  late DateTime _startDate;
  late DateTime _endDate;
  late final _mapController = AnimatedMapController(vsync: this);
  bool _showMap = true;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  void _loadHistory() {
    context.read<HistoryBloc>().add(
      HistoryEvent.loadHistory(startDate: _startDate, endDate: _endDate),
    );
  }

  void _zoomIn() {
    _mapController.animateTo(
      dest: _mapController.mapController.camera.center,
      zoom: _mapController.mapController.camera.zoom + 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _zoomOut() {
    _mapController.animateTo(
      dest: _mapController.mapController.camera.center,
      zoom: _mapController.mapController.camera.zoom - 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      locale: context.locale,
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
            HistoryDateRangePicker(
              startDate: _startDate,
              endDate: _endDate,
              onTap: _selectDateRange,
              formatDate: _formatDate,
            ),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const Center(child: CircularProgressIndicator()),
                    loading: (_) => const Center(child: CircularProgressIndicator()),
                    loaded: (loaded) {
                      if (loaded.positions.isEmpty) return const HistoryEmptyState();
                      
                      // Auto-fit map to bounds if loaded and showing map
                      if (_showMap) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final points = loaded.positions.map((p) => LatLng(p.latitude, p.longitude)).toList();
                          if (points.isNotEmpty) {
                            final bounds = LatLngBounds.fromPoints(points);
                            _mapController.mapController.fitCamera(
                              CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
                            );
                          }
                        });
                      }

                      return _showMap
                          ? HistoryMapView(
                              positions: loaded.positions,
                              mapController: _mapController,
                              isDark: isDark,
                              subdomains: subdomains,
                              onZoomIn: _zoomIn,
                              onZoomOut: _zoomOut,
                            )
                          : HistoryListView(positions: loaded.positions);
                    },
                    empty: (_) => const HistoryEmptyState(),
                    error: (error) => HistoryErrorState(
                      message: error.message,
                      onRetry: _loadHistory,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
