// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionUpload _$PositionUploadFromJson(Map<String, dynamic> json) =>
    PositionUpload(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      recordedAt: json['recorded_at'] as String,
    );

Map<String, dynamic> _$PositionUploadToJson(PositionUpload instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'altitude': instance.altitude,
      'status': instance.status,
      'recorded_at': instance.recordedAt,
    };
