import 'package:drift/drift.dart';
import '../../core/api/api_client.dart';
import '../../core/database/database.dart';
import '../models/position.dart';

class TrackingRepository {
  final ApiClient _apiClient;
  final AppDatabase _database;

  TrackingRepository(this._apiClient, this._database);

  Future<void> savePosition(Position position) async {
    try {
      await _database.into(_database.localPositions).insert(
            LocalPositionsCompanion.insert(
              latitude: position.latitude,
              longitude: position.longitude,
              speed: Value(position.speed ?? 0.0),
              heading: Value(position.heading ?? 0.0),
              altitude: Value(position.altitude ?? 0.0),
              status: Value(position.status ?? 'unknown'),
              recordedAt: position.recordedAt,
              isSynced: Value(position.isSynced),
            ),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncPosition(
    Position position,
    String deviceId,
    String secretKey,
  ) async {
    try {
      await _apiClient.sendPosition({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'heading': position.heading,
        'altitude': position.altitude,
        'status': position.status,
        'recorded_at': position.recordedAt.toIso8601String(),
      });

      if (position.id != null) {
        await (_database.update(_database.localPositions)
              ..where((t) => t.id.equals(position.id!)))
            .write(const LocalPositionsCompanion(isSynced: Value(true)));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Position>> getUnsyncedPositions() async {
    try {
      final query = _database.select(_database.localPositions)
        ..where((t) => t.isSynced.equals(false))
        ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]);

      final results = await query.get();

      return results
          .map((row) => Position(
                id: row.id,
                latitude: row.latitude,
                longitude: row.longitude,
                speed: row.speed,
                heading: row.heading,
                altitude: row.altitude,
                status: row.status,
                recordedAt: row.recordedAt,
                isSynced: row.isSynced,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<Position?> get currentPositionStream {
    final query = _database.select(_database.localPositions)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
      ..limit(1);

    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return Position(
        id: row.id,
        latitude: row.latitude,
        longitude: row.longitude,
        speed: row.speed,
        heading: row.heading,
        altitude: row.altitude,
        status: row.status,
        recordedAt: row.recordedAt,
        isSynced: row.isSynced,
      );
    });
  }

  Future<void> cleanupOldData() async {
    try {
      await _database.cleanupOldData();
    } catch (e) {
      rethrow;
    }
  }
}
