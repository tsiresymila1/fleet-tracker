// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfoResponse _$DeviceInfoResponseFromJson(Map<String, dynamic> json) =>
    DeviceInfoResponse(
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String,
      isAuthorized: json['authorized'] as bool,
      secretKey: json['secret_key'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DeviceInfoResponseToJson(DeviceInfoResponse instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'device_name': instance.deviceName,
      'authorized': instance.isAuthorized,
      'secret_key': instance.secretKey,
      'metadata': instance.metadata,
    };

GenericResponse _$GenericResponseFromJson(Map<String, dynamic> json) =>
    GenericResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GenericResponseToJson(GenericResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

PositionHistoryResponse _$PositionHistoryResponseFromJson(
  Map<String, dynamic> json,
) => PositionHistoryResponse(
  success: json['success'] as bool,
  positions: (json['positions'] as List<dynamic>)
      .map((e) => PositionData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PositionHistoryResponseToJson(
  PositionHistoryResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'positions': instance.positions,
};

PositionData _$PositionDataFromJson(Map<String, dynamic> json) => PositionData(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  speed: (json['speed'] as num?)?.toDouble(),
  heading: (json['heading'] as num?)?.toDouble(),
  altitude: (json['altitude'] as num?)?.toDouble(),
  status: json['status'] as String?,
  recordedAt: json['recorded_at'] as String,
);

Map<String, dynamic> _$PositionDataToJson(PositionData instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'speed': instance.speed,
      'heading': instance.heading,
      'altitude': instance.altitude,
      'status': instance.status,
      'recorded_at': instance.recordedAt,
    };
