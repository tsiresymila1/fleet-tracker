import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide JsonKey;
import '../../data/models/position.dart';
import '../../data/models/position_upload.dart';
import '../../core/utils/tracking_handler.dart';
import '../../core/database/database.dart';
import '../../core/api/api_client.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';
part 'tracking_bloc.freezed.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> with WidgetsBindingObserver {
  StreamSubscription<geo.Position>? _uiPositionSubscription;
  bool _isServiceEnabled = false;
  
  // For UI tracking - replicate background service logic
  AppDatabase? _db;
  ApiClient? _apiClient;
  SharedPreferences? _prefs;
  geo.Position? _lastPosition;
  DateTime? _lastDeviceInfoSync;
  Timer? _syncTimer;

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
      
      // Always start with UI tracking when app is open
      // Background service will only be used when app goes to background
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
      debugPrint('   ✓ Stopping background service...');
      await _stopService();
      debugPrint('   ✓ Removing task data callback...');
      FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
      debugPrint('   ✓ Starting UI tracking...');
      await _startUiTracking();
      debugPrint('   ✅ UI tracking started successfully');
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
      debugPrint('   ✓ Starting background service...');
      await _startService();
      debugPrint('   ✓ Adding task data callback...');
      FlutterForegroundTask.addTaskDataCallback(_onTaskData);
      debugPrint('   ✅ Background service started successfully');
    } else {
      debugPrint('   ⚠ Tracking not enabled, skipping');
    }
  }

  Future<void> _startUiTracking() async {
    await _stopUiTracking();
    
    // Initialize database and API client for UI tracking
    _db = AppDatabase();
    _prefs = await SharedPreferences.getInstance();
    
    final dio = Dio(BaseOptions(
      baseUrl: 'https://fleet-move-tracker.vercel.app/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    
    // Add auth interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final deviceId = _prefs?.getString('device_id');
        final secretKey = _prefs?.getString('secret_key');
        if (deviceId != null && secretKey != null) {
          options.headers['X-DEVICE-ID'] = deviceId;
          options.headers['X-DEVICE-KEY'] = secretKey;
        }
        handler.next(options);
      },
    ));
    _apiClient = ApiClient(dio);
    
    const locationSettings = geo.LocationSettings(
      accuracy: geo.LocationAccuracy.high,
      distanceFilter: 5,
    );

    _uiPositionSubscription = geo.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((pos) async {
      // Update UI state
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
      
      // Save to database if enough distance moved
      if (_shouldSave(pos)) {
        await _processPosition(pos);
        _lastPosition = pos;
      }
    });
    
    // Start periodic sync timer (every 30 seconds)
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _syncPendingPositions();
      
      // Sync device info every 5 minutes
      if (_shouldSyncDeviceInfo()) {
        await _syncDeviceInfo();
      }
    });
    
    debugPrint('UI-thread tracking started with full processing');
  }
  
  bool _shouldSave(geo.Position current) {
    if (_lastPosition == null) return true;
    final distance = geo.Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      current.latitude,
      current.longitude,
    );
    return distance >= 10; // Save every 10 meters
  }
  
  bool _shouldSyncDeviceInfo() {
    if (_lastDeviceInfoSync == null) return true;
    return DateTime.now().difference(_lastDeviceInfoSync!) > const Duration(minutes: 5);
  }
  
  Future<void> _processPosition(geo.Position pos) async {
    if (_db == null) return;
    
    final status = pos.speed > 0.5 ? 'moving' : 'stopped';
    final entry = LocalPositionsCompanion.insert(
      latitude: pos.latitude,
      longitude: pos.longitude,
      speed: Value(pos.speed),
      heading: Value(pos.heading),
      altitude: Value(pos.altitude),
      recordedAt: DateTime.now(),
      status: Value(status),
    );

    await _db!.into(_db!.localPositions).insert(entry);
  }
  
  Future<void> _syncPendingPositions() async {
    if (_db == null || _apiClient == null) return;
    
    try {
      final pending = await (_db!.select(_db!.localPositions)
            ..where((t) => t.isSynced.equals(false))
            ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)])
            ..limit(10))
          .get();

      if (pending.isEmpty) return;
      
      final batchData = pending.map((pos) => PositionUpload(
        latitude: pos.latitude,
        longitude: pos.longitude,
        speed: pos.speed,
        heading: pos.heading,
        altitude: pos.altitude,
        status: pos.status,
        recordedAt: pos.recordedAt.toIso8601String(),
      )).toList();

      await _apiClient!.sendPositions(batchData);

      for (var pos in pending) {
        await (_db!.delete(_db!.localPositions)..where((t) => t.id.equals(pos.id))).go();
      }
      
      debugPrint('UI tracking: Synced ${pending.length} positions');
    } catch (e) {
      debugPrint('UI tracking sync error: $e');
    }
  }
  
  Future<void> _syncDeviceInfo() async {
    if (_apiClient == null || _prefs == null) return;
    
    try {
      final info = await _apiClient!.getDeviceInfo();
      if (info.deviceName.isNotEmpty) {
        await _prefs!.setString('device_name', info.deviceName);
      }
      _lastDeviceInfoSync = DateTime.now();
    } catch (e) {
      debugPrint('Device info sync error: $e');
    }
  }

  Future<void> _stopUiTracking() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    await _uiPositionSubscription?.cancel();
    _uiPositionSubscription = null;
    await _db?.close();
    _db = null;
    _apiClient = null;
    _prefs = null;
    _lastPosition = null;
    debugPrint('UI-thread tracking stopped');
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
      
      // Request notification permission for Android 13+ FIRST
      debugPrint('   📱 Requesting notification permission...');
      final notifPermission = await FlutterForegroundTask.requestNotificationPermission();
      debugPrint('   Notification permission: $notifPermission');

      // Request battery optimization exemption for uninterrupted tracking
      debugPrint('   🔋 Requesting battery optimization exemption...');
      final batteryPermission = await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      debugPrint('   Battery optimization: $batteryPermission');

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
