import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../data/models/position.dart';
import '../../core/utils/tracking_handler.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';
part 'tracking_bloc.freezed.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {


  TrackingBloc() : super(const TrackingState.initial()) {
    on<TrackingStart>(_onStart);
    on<TrackingStop>(_onStop);
    on<TrackingToggle>(_onToggle);
    on<TrackingPositionUpdated>(_onPositionUpdated);
    
    // Initialize status check
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    final bool isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      add(const TrackingEvent.start());
    }
  }

  Future<void> _onStart(TrackingStart event, Emitter<TrackingState> emit) async {
    try {
      emit(const TrackingState.loading());
      
      // Start service asynchronously without blocking
      await _startService();
      
      // Register callback to receive updates
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
    } catch (e) {
      debugPrint('Error in _onStart: $e');
      emit(const TrackingState.initial());
    }
  }

  Future<void> _onStop(TrackingStop event, Emitter<TrackingState> emit) async {
    await _stopService();
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    emit(const TrackingState.initial());
  }

  Future<void> _onToggle(TrackingToggle event, Emitter<TrackingState> emit) async {
    final bool isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      add(const TrackingEvent.stop());
    } else {
      add(const TrackingEvent.start());
    }
  }

  void _onPositionUpdated(TrackingPositionUpdated event, Emitter<TrackingState> emit) {
    emit(TrackingState.active(event.position));
  }

  void _onTaskData(Object data) {
    debugPrint('Received task data: $data');
    if (data is Map<String, dynamic>) {
      final position = Position(
        latitude: data['latitude'] as double,
        longitude: data['longitude'] as double,
        speed: data['speed'] as double?,
        heading: data['heading'] as double?,
        altitude: data['altitude'] as double?,
        recordedAt: DateTime.parse(data['recorded_at'] as String),
        status: ((data['speed'] as num?) ?? 0) > 0.5 ? 'moving' : 'stopped',
        isSynced: false,
      );
      add(TrackingPositionUpdated(position));
    }
  }

  Future<void> _startService() async {
    try {
      // Request notification permission for Android 13+
      await FlutterForegroundTask.requestNotificationPermission();

      // Request battery optimization exemption for uninterrupted tracking
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();

      // Always init to allow communication even if service is already running
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'tracking_channel',
          channelName: 'Fleet Tracking',
          channelDescription: 'Continuous location tracking',
          channelImportance: NotificationChannelImportance.LOW,
          priority: NotificationPriority.LOW,
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(5000),
          autoRunOnBoot: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
      );

      if (await FlutterForegroundTask.isRunningService) return;

      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Fleet Tracking Active',
        notificationText: 'Monitoring location in background',
        callback: startCallback,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Foreground service start timed out');
          throw TimeoutException('Service start timeout');
        },
      );
    } catch (e) {
      debugPrint('Error starting foreground service: $e');
      rethrow;
    }
  }

  Future<void> _stopService() async {
    await FlutterForegroundTask.stopService();
  }

  @override
  Future<void> close() {
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    return super.close();
  }
}
