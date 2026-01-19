import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

part 'database.g.dart';

class LocalPositions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get speed => real().nullable()();
  RealColumn get heading => real().nullable()();
  RealColumn get altitude => real().nullable()();
  TextColumn get status => text().nullable()(); // moving, stopped
  DateTimeColumn get recordedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [LocalPositions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));

      // if (Platform.isAndroid) {
      //   await applyWorkaroundToOpenSqlite3OnOldAndroidDevices();
      // }

      final cachebase = await getTemporaryDirectory();
      sqlite3.tempDirectory = cachebase.path;

      return NativeDatabase.createInBackground(file);
    });
  }

  // Cleanup old data (older than 7 days)
  Future<void> cleanupOldData() {
    return (delete(localPositions)..where(
          (t) => t.recordedAt.isSmallerThanValue(
            DateTime.now().subtract(const Duration(days: 7)),
          ),
        ))
        .go();
  }
}
