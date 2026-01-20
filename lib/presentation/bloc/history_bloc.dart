import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_client.dart';
import '../../data/models/api_responses.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  late ApiClient _apiClient;

  HistoryBloc() : super(const HistoryState.initial()) {
    _initApiClient();
    on<HistoryLoadRequested>(_onLoadHistory);
  }

  Future<void> _initApiClient() async {
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio(BaseOptions(
      baseUrl: 'https://fleet-move-tracker.vercel.app/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final deviceId = prefs.getString('device_id');
        final secretKey = prefs.getString('secret_key');
        if (deviceId != null && secretKey != null) {
          options.headers['X-DEVICE-ID'] = deviceId;
          options.headers['X-DEVICE-KEY'] = secretKey;
        }
        handler.next(options);
      },
    ));

    _apiClient = ApiClient(dio);
  }

  Future<void> _onLoadHistory(
    HistoryLoadRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryState.loading());

    try {
      final startDateStr = _formatDate(event.startDate);
      final endDateStr = _formatDate(event.endDate);

      final response = await _apiClient.getPositionHistory(
        startDateStr,
        endDateStr,
      );

      if (response.success && response.positions.isNotEmpty) {
        emit(HistoryState.loaded(
          positions: response.positions,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      } else {
        emit(HistoryState.empty(
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }
    } catch (e) {
      emit(HistoryState.error(e.toString()));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
