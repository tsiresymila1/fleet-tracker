import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../data/models/position.dart';
import '../../core/utils/tracking_handler.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';
part 'tracking_bloc.freezed.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> with WidgetsBindingObserver {
  bool _isServiceEnabled = false;
  
  // UI position subscription - only for UI updates, not for saving/syncing
  StreamSubscription<geo.Position>? _uiPositionSubscription;

  TrackingBloc() : super(const TrackingState.initial()) {
    on<TrackingStart>(_onStart);
    on<TrackingStop>(_onStop);
    on<TrackingToggle>(_onToggle);
    on<TrackingPositionUpdated>(_onPositionUpdated);
    on<TrackingAppResumed>(_onAppResumed);
    on<TrackingAppPaused>(_onAppPaused);
    
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize status check
    _checkServiceStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('═══════════════════════════════════════');
    debugPrint('App Lifecycle State Changed: $state');
    debugPrint('Current tracking enabled: $_isServiceEnabled');
    debugPrint('═══════════════════════════════════════');
    
    if (state == AppLifecycleState.resumed) {
      debugPrint('▶ App RESUMED - Switching to UI tracking');
      add(const TrackingEvent.appResumed());
    } else if (state == AppLifecycleState.paused) {
      debugPrint('⏸ App PAUSED - Switching to background service');
      add(const TrackingEvent.appPaused());
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('⏯ App INACTIVE');
    } else if (state == AppLifecycleState.detached) {
      debugPrint('⏏ App DETACHED');
    } else if (state == AppLifecycleState.hidden) {
      debugPrint('👁 App HIDDEN');
    }
  }

  Future<void> _checkServiceStatus() async {
    final bool isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      _isServiceEnabled = true;
      add(const TrackingEvent.start());
      return;
    }

    // Auto-start if registered
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString('device_id');
      final secretKey = prefs.getString('secret_key');
      
      if (deviceId != null && secretKey != null) {
        debugPrint('Auto-starting tracking on launch');
        add(const TrackingEvent.start());
      }
    } catch (e) {
      debugPrint('Error in auto-start check: $e');
    }
  }

  Future<void> _onStart(TrackingStart event, Emitter<TrackingState> emit) async {
    try {
      emit(const TrackingState.loading());
      _isServiceEnabled = true;
      
      // Always start background service for tracking
      await _startService();
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
      
      // Also start UI tracking for real-time UI updates
      await _startUiTracking();
    } catch (e) {
      debugPrint('Error in _onStart: $e');
      emit(const TrackingState.initial());
    }
  }

  Future<void> _onStop(TrackingStop event, Emitter<TrackingState> emit) async {
    _isServiceEnabled = false;
    await _stopService();
    await _stopUiTracking();
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    emit(const TrackingState.initial());
  }

  Future<void> _onToggle(TrackingToggle event, Emitter<TrackingState> emit) async {
    if (_isServiceEnabled) {
      add(const TrackingEvent.stop());
    } else {
      add(const TrackingEvent.start());
    }
  }

  void _onPositionUpdated(TrackingPositionUpdated event, Emitter<TrackingState> emit) {
    emit(TrackingState.active(event.position));
  }

  Future<void> _onAppResumed(TrackingAppResumed event, Emitter<TrackingState> emit) async {
    debugPrint('🔄 _onAppResumed called');
    debugPrint('   Tracking enabled: $_isServiceEnabled');
    
    if (_isServiceEnabled) {
      debugPrint('   ✓ Starting UI tracking for real-time updates...');
      await _startUiTracking();
      debugPrint('   ✅ UI tracking started');
    } else {
      debugPrint('   ⚠ Tracking not enabled, skipping');
    }
  }

  Future<void> _onAppPaused(TrackingAppPaused event, Emitter<TrackingState> emit) async {
    debugPrint('🔄 _onAppPaused called');
    debugPrint('   Tracking enabled: $_isServiceEnabled');
    
    if (_isServiceEnabled) {
      debugPrint('   ✓ Stopping UI tracking...');
      await _stopUiTracking();
      debugPrint('   ⚠ Background service continues running');
    } else {
      debugPrint('   ⚠ Tracking not enabled, skipping');
    }
  }

  Future<void> _startUiTracking() async {
    await _stopUiTracking();
    
    debugPrint('   📡 Starting UI position stream...');
    
    const locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 5,
    );

    // UI tracking only updates the UI state - all saving/syncing done by background service
    _uiPositionSubscription = geo.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((pos) {
      // Update UI state only
      final position = Position(
        latitude: pos.latitude,
        longitude: pos.longitude,
        speed: pos.speed,
        heading: pos.heading,
        altitude: pos.altitude,
        recordedAt: DateTime.now(),
        status: pos.speed > 0.5 ? 'moving' : 'stopped',
        isSynced: false,
      );
      add(TrackingPositionUpdated(position));
    });
    
    debugPrint('   ✅ UI tracking started (display only)');
  }
  
  Future<void> _stopUiTracking() async {
    await _uiPositionSubscription?.cancel();
    _uiPositionSubscription = null;
    debugPrint('   ✓ UI tracking stopped');
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
      debugPrint('🚀 Starting foreground service...');
      
      // Verify location permissions are granted (required for FOREGROUND_SERVICE_LOCATION on Android 14+)
      debugPrint('   📍 Verifying location permissions...');
      final locationPermission = await geo.Geolocator.checkPermission();
      if (locationPermission == geo.LocationPermission.denied || 
          locationPermission == geo.LocationPermission.deniedForever) {
        debugPrint('   ❌ Location permission not granted. Requesting...');
        final requested = await geo.Geolocator.requestPermission();
        if (requested == geo.LocationPermission.denied || 
            requested == geo.LocationPermission.deniedForever) {
          debugPrint('   ❌ Location permission denied. Cannot start foreground service.');
          throw Exception('Location permission required for background tracking');
        }
      }
      debugPrint('   ✓ Location permissions verified');
      
      // NOW initialize foreground task AFTER permissions are granted
      debugPrint('   ⚙️ Initializing foreground task...');
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'tracking_channel',
          channelName: 'Fleet Tracking',
          channelDescription: 'Continuous location tracking',
          channelImportance: NotificationChannelImportance.DEFAULT,
          priority: NotificationPriority.DEFAULT,
        ),
        iosNotificationOptions: const IOSNotificationOptions(
          showNotification: true,
          playSound: false,
        ),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(5000),
        ),
      );
      debugPrint('   ✓ Foreground task initialized');

      final isRunning = await FlutterForegroundTask.isRunningService;
      debugPrint('   Service already running: $isRunning');
      
      if (isRunning) {
        debugPrint('   ⚠️ Service already running, skipping start');
        return;
      }

      debugPrint('   🎬 Starting service with notification...');
      final result = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Fleet Tracking Active',
        notificationText: 'Monitoring location in background',
        callback: startCallback,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('   ❌ Foreground service start timed out');
          throw TimeoutException('Service start timeout');
        },
      );
      
      debugPrint('   ✅ Service started successfully: $result');
      
      // Verify service is running
      final verifyRunning = await FlutterForegroundTask.isRunningService;
      debugPrint('   🔍 Verification - Service running: $verifyRunning');
      
    } catch (e, stackTrace) {
      debugPrint('   ❌ Error starting foreground service: $e');
      debugPrint('   Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _stopService() async {
    await FlutterForegroundTask.stopService();
  }
  
  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    _stopUiTracking();
    return super.close();
  }
}
