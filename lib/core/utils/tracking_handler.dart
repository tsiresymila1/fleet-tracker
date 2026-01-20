import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../api/api_client.dart';
import '../../data/models/position_upload.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(TrackingTaskHandler());
}

class TrackingTaskHandler extends TaskHandler {
  late AppDatabase _db;
  late ApiClient _apiClient;
  late SharedPreferences _prefs;
  Position? _lastPosition;
  DateTime? _lastDeviceInfoSync;
  DateTime? _lastSyncTime;
  StreamSubscription<Position>? _positionSubscription;

  // Sync interval: 30 seconds
  static const Duration _syncInterval = Duration(seconds: 30);

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _db = AppDatabase();
    _prefs = await SharedPreferences.getInstance();
    
    final dio = Dio(BaseOptions(
      baseUrl: 'https://fleet-move-tracker.vercel.app/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    // Add auth interceptor for cleaner API calls
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final deviceId = _prefs.getString('device_id');
        final secretKey = _prefs.getString('secret_key');
        // Debug logging for Auth
        debugPrint('TrackingHandler Interceptor: DeviceID=$deviceId, SecretKey=${secretKey != null ? '***${secretKey.substring(secretKey.length - 4)}' : 'null'}');

        if (deviceId != null && secretKey != null) {
          options.headers['X-DEVICE-ID'] = deviceId;
          options.headers['X-DEVICE-KEY'] = secretKey;
        } else {
             debugPrint('TrackingHandler: Missing Credentials in Prefs');
        }
        handler.next(options);
      },
    ));
    _apiClient = ApiClient(dio);

    // Start position stream for continuous updates
    _startPositionStream();
  }

  /// Start listening to position stream for continuous updates
  void _startPositionStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Only notify when moved at least 5 meters
    );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: (error) {
        debugPrint('Position stream error: $error');
      },
    );

    debugPrint('Position stream started');
  }

  /// Handle each position update from the stream
  Future<void> _onPositionUpdate(Position position) async {
    try {
      debugPrint('Stream position: ${position.latitude}, ${position.longitude}');

      // Save locally if enough distance moved
      if (_shouldSave(position)) {
        await _processPosition(position);
        _lastPosition = position;
      }

      // Update notification immediately with latest position
      _updateNotification(position);
    } catch (e) {
      debugPrint('Error processing stream position: $e');
    }
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    try {
      // Only sync to API every 30 seconds to limit API calls
      if (_shouldSync()) {
        await _syncPendingPositions();
        _lastSyncTime = DateTime.now();
      }

      // Sync device info periodically (e.g., every 5 minutes)
      if (_shouldSyncDeviceInfo()) {
        await _syncDeviceInfo();
      }
    } catch (e) {
      debugPrint('Error in repeat event: $e');
    }
  }

  /// Check if enough time has passed since last sync (30 seconds)
  bool _shouldSync() {
    if (_lastSyncTime == null) return true;
    return DateTime.now().difference(_lastSyncTime!) >= _syncInterval;
  }

  bool _shouldSave(Position current) {
    if (_lastPosition == null) return true;
    final distance = Geolocator.distanceBetween(
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

  Future<void> _processPosition(Position pos) async {
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

    await _db.into(_db.localPositions).insert(entry);
  }

  Future<void> _syncPendingPositions() async {

    // Get unsynced positions
    final pending = await (_db.select(_db.localPositions)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)])
          // Batch size to avoid timeouts
          ..limit(10))
        .get();

    if (pending.isEmpty) return;
    debugPrint("Sync position ........................");
    try {
      // Build batch data
      final batchData = pending.map((pos) => PositionUpload(
        latitude: pos.latitude,
        longitude: pos.longitude,
        speed: pos.speed,
        heading: pos.heading,
        altitude: pos.altitude,
        status: pos.status,
        recordedAt: pos.recordedAt.toIso8601String(),
      )).toList();

      // Send all positions in one request
      await _apiClient.sendPositions(batchData);

      // If successful, purge all synced positions
      for (var pos in pending) {
        await (_db.delete(_db.localPositions)..where((t) => t.id.equals(pos.id))).go();
      }
      
      debugPrint("Successfully synced ${pending.length} positions at ${DateTime.now().toIso8601String()}");
    } catch (e) {
      debugPrint("Error when sync positions :: $e");
      // If sync fails, positions remain in DB for retry later
    }
  }

  Future<void> _syncDeviceInfo() async {
    try {
      // Pull info
      final info = await _apiClient.getDeviceInfo();
      // Logic to update local preferences or state if needed (e.g. device name change)
      if (info.deviceName.isNotEmpty) {
        await _prefs.setString('device_name', info.deviceName);
      }
      
      // Push info (e.g. battery level, version - placeholders for now as we don't have battery info package here yet)
      // await _apiClient.updateDeviceInfo({...});
      
      _lastDeviceInfoSync = DateTime.now();
    } catch (_) {}
  }

  void _updateNotification(Position pos) {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Fleet Tracking Active',
      notificationText:
          'Location: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}',
    );
    
    // Send data to main isolate for UI updates
    FlutterForegroundTask.sendDataToMain({
      'latitude': pos.latitude,
      'longitude': pos.longitude,
      'speed': pos.speed,
      'heading': pos.heading,
      'altitude': pos.altitude,
      'recorded_at': pos.timestamp.toIso8601String(),
      'accuracy': pos.accuracy,
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    // Cancel position stream subscription
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    
    await _db.close();
  }
}
