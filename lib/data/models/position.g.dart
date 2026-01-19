// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
  id: (json['id'] as num?)?.toInt(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  speed: (json['speed'] as num?)?.toDouble(),
  heading: (json['heading'] as num?)?.toDouble(),
  altitude: (json['altitude'] as num?)?.toDouble(),
  status: json['status'] as String?,
  recordedAt: DateTime.parse(json['recorded_at'] as String),
  isSynced: json['is_synced'] as bool? ?? false,
);

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
  'id': instance.id,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'speed': instance.speed,
  'heading': instance.heading,
  'altitude': instance.altitude,
  'status': instance.status,
  'recorded_at': instance.recordedAt.toIso8601String(),
  'is_synced': instance.isSynced,
};
