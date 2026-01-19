// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalPositionsTable extends LocalPositions
    with TableInfo<$LocalPositionsTable, LocalPosition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingMeta = const VerificationMeta(
    'heading',
  );
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
    'heading',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    latitude,
    longitude,
    speed,
    heading,
    altitude,
    status,
    recordedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPosition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('heading')) {
      context.handle(
        _headingMeta,
        heading.isAcceptableOrUnknown(data['heading']!, _headingMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPosition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPosition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed'],
      ),
      heading: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LocalPositionsTable createAlias(String alias) {
    return $LocalPositionsTable(attachedDatabase, alias);
  }
}

class LocalPosition extends DataClass implements Insertable<LocalPosition> {
  final int id;
  final double latitude;
  final double longitude;
  final double? speed;
  final double? heading;
  final double? altitude;
  final String? status;
  final DateTime recordedAt;
  final bool isSynced;
  const LocalPosition({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    this.altitude,
    this.status,
    required this.recordedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<double>(speed);
    }
    if (!nullToAbsent || heading != null) {
      map['heading'] = Variable<double>(heading);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalPositionsCompanion toCompanion(bool nullToAbsent) {
    return LocalPositionsCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      speed: speed == null && nullToAbsent
          ? const Value.absent()
          : Value(speed),
      heading: heading == null && nullToAbsent
          ? const Value.absent()
          : Value(heading),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      recordedAt: Value(recordedAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalPosition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPosition(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      speed: serializer.fromJson<double?>(json['speed']),
      heading: serializer.fromJson<double?>(json['heading']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      status: serializer.fromJson<String?>(json['status']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'speed': serializer.toJson<double?>(speed),
      'heading': serializer.toJson<double?>(heading),
      'altitude': serializer.toJson<double?>(altitude),
      'status': serializer.toJson<String?>(status),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalPosition copyWith({
    int? id,
    double? latitude,
    double? longitude,
    Value<double?> speed = const Value.absent(),
    Value<double?> heading = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
    Value<String?> status = const Value.absent(),
    DateTime? recordedAt,
    bool? isSynced,
  }) => LocalPosition(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    speed: speed.present ? speed.value : this.speed,
    heading: heading.present ? heading.value : this.heading,
    altitude: altitude.present ? altitude.value : this.altitude,
    status: status.present ? status.value : this.status,
    recordedAt: recordedAt ?? this.recordedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  LocalPosition copyWithCompanion(LocalPositionsCompanion data) {
    return LocalPosition(
      id: data.id.present ? data.id.value : this.id,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      speed: data.speed.present ? data.speed.value : this.speed,
      heading: data.heading.present ? data.heading.value : this.heading,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      status: data.status.present ? data.status.value : this.status,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPosition(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('heading: $heading, ')
          ..write('altitude: $altitude, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    latitude,
    longitude,
    speed,
    heading,
    altitude,
    status,
    recordedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPosition &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.speed == this.speed &&
          other.heading == this.heading &&
          other.altitude == this.altitude &&
          other.status == this.status &&
          other.recordedAt == this.recordedAt &&
          other.isSynced == this.isSynced);
}

class LocalPositionsCompanion extends UpdateCompanion<LocalPosition> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double?> speed;
  final Value<double?> heading;
  final Value<double?> altitude;
  final Value<String?> status;
  final Value<DateTime> recordedAt;
  final Value<bool> isSynced;
  const LocalPositionsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.speed = const Value.absent(),
    this.heading = const Value.absent(),
    this.altitude = const Value.absent(),
    this.status = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  LocalPositionsCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    this.speed = const Value.absent(),
    this.heading = const Value.absent(),
    this.altitude = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime recordedAt,
    this.isSynced = const Value.absent(),
  }) : latitude = Value(latitude),
       longitude = Value(longitude),
       recordedAt = Value(recordedAt);
  static Insertable<LocalPosition> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? speed,
    Expression<double>? heading,
    Expression<double>? altitude,
    Expression<String>? status,
    Expression<DateTime>? recordedAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
      if (altitude != null) 'altitude': altitude,
      if (status != null) 'status': status,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  LocalPositionsCompanion copyWith({
    Value<int>? id,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double?>? speed,
    Value<double?>? heading,
    Value<double?>? altitude,
    Value<String?>? status,
    Value<DateTime>? recordedAt,
    Value<bool>? isSynced,
  }) {
    return LocalPositionsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      altitude: altitude ?? this.altitude,
      status: status ?? this.status,
      recordedAt: recordedAt ?? this.recordedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPositionsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('speed: $speed, ')
          ..write('heading: $heading, ')
          ..write('altitude: $altitude, ')
          ..write('status: $status, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalPositionsTable localPositions = $LocalPositionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [localPositions];
}

typedef $$LocalPositionsTableCreateCompanionBuilder =
    LocalPositionsCompanion Function({
      Value<int> id,
      required double latitude,
      required double longitude,
      Value<double?> speed,
      Value<double?> heading,
      Value<double?> altitude,
      Value<String?> status,
      required DateTime recordedAt,
      Value<bool> isSynced,
    });
typedef $$LocalPositionsTableUpdateCompanionBuilder =
    LocalPositionsCompanion Function({
      Value<int> id,
      Value<double> latitude,
      Value<double> longitude,
      Value<double?> speed,
      Value<double?> heading,
      Value<double?> altitude,
      Value<String?> status,
      Value<DateTime> recordedAt,
      Value<bool> isSynced,
    });

class $$LocalPositionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPositionsTable> {
  $$LocalPositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPositionsTable> {
  $$LocalPositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heading => $composableBuilder(
    column: $table.heading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPositionsTable> {
  $$LocalPositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get heading =>
      $composableBuilder(column: $table.heading, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$LocalPositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPositionsTable,
          LocalPosition,
          $$LocalPositionsTableFilterComposer,
          $$LocalPositionsTableOrderingComposer,
          $$LocalPositionsTableAnnotationComposer,
          $$LocalPositionsTableCreateCompanionBuilder,
          $$LocalPositionsTableUpdateCompanionBuilder,
          (
            LocalPosition,
            BaseReferences<_$AppDatabase, $LocalPositionsTable, LocalPosition>,
          ),
          LocalPosition,
          PrefetchHooks Function()
        > {
  $$LocalPositionsTableTableManager(
    _$AppDatabase db,
    $LocalPositionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalPositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double?> speed = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
              }) => LocalPositionsCompanion(
                id: id,
                latitude: latitude,
                longitude: longitude,
                speed: speed,
                heading: heading,
                altitude: altitude,
                status: status,
                recordedAt: recordedAt,
                isSynced: isSynced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<double?> speed = const Value.absent(),
                Value<double?> heading = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<String?> status = const Value.absent(),
                required DateTime recordedAt,
                Value<bool> isSynced = const Value.absent(),
              }) => LocalPositionsCompanion.insert(
                id: id,
                latitude: latitude,
                longitude: longitude,
                speed: speed,
                heading: heading,
                altitude: altitude,
                status: status,
                recordedAt: recordedAt,
                isSynced: isSynced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPositionsTable,
      LocalPosition,
      $$LocalPositionsTableFilterComposer,
      $$LocalPositionsTableOrderingComposer,
      $$LocalPositionsTableAnnotationComposer,
      $$LocalPositionsTableCreateCompanionBuilder,
      $$LocalPositionsTableUpdateCompanionBuilder,
      (
        LocalPosition,
        BaseReferences<_$AppDatabase, $LocalPositionsTable, LocalPosition>,
      ),
      LocalPosition,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalPositionsTableTableManager get localPositions =>
      $$LocalPositionsTableTableManager(_db, _db.localPositions);
}
