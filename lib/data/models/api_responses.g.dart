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
