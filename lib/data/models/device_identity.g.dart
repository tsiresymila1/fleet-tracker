// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceIdentity _$DeviceIdentityFromJson(Map<String, dynamic> json) =>
    DeviceIdentity(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      secretKey: json['secretKey'] as String,
      isAuthorized: json['isAuthorized'] as bool,
    );

Map<String, dynamic> _$DeviceIdentityToJson(DeviceIdentity instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'secretKey': instance.secretKey,
      'isAuthorized': instance.isAuthorized,
    };
