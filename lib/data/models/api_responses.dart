import 'package:json_annotation/json_annotation.dart';

part 'api_responses.g.dart';

@JsonSerializable()
class DeviceInfoResponse {
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @JsonKey(name: 'device_name')
  final String deviceName;
  @JsonKey(name: 'authorized')
  final bool isAuthorized;
  @JsonKey(name: 'secret_key')
  final String? secretKey;
  final Map<String, dynamic>? metadata;

  DeviceInfoResponse({
    this.deviceId,
    required this.deviceName,
    required this.isAuthorized,
    this.secretKey,
    this.metadata,
  });

  factory DeviceInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoResponseToJson(this);
}

@JsonSerializable()
class GenericResponse {
  final bool success;
  final String? message;
  final Map<String, dynamic>? data;

  GenericResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenericResponseToJson(this);
}

@JsonSerializable()
class PositionHistoryResponse {
  final bool success;
  final List<PositionData> positions;

  PositionHistoryResponse({
    required this.success,
    required this.positions,
  });

  factory PositionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PositionHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PositionHistoryResponseToJson(this);
}

@JsonSerializable()
class PositionData {
  final double latitude;
  final double longitude;
  final double? speed;
  final double? heading;
  final double? altitude;
  final String? status;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;

  PositionData({
    required this.latitude,
    required this.longitude,
    this.speed,
    this.heading,
    this.altitude,
    this.status,
    required this.recordedAt,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) =>
      _$PositionDataFromJson(json);

  Map<String, dynamic> toJson() => _$PositionDataToJson(this);
}
