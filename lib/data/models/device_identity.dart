import 'package:json_annotation/json_annotation.dart';

part 'device_identity.g.dart';

@JsonSerializable()
class DeviceIdentity {
  final String deviceId;
  final String deviceName;
  final String secretKey;
  final bool isAuthorized;

  const DeviceIdentity({
    required this.deviceId,
    required this.deviceName,
    required this.secretKey,
    required this.isAuthorized,
  });

  factory DeviceIdentity.fromJson(Map<String, dynamic> json) =>
      _$DeviceIdentityFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceIdentityToJson(this);

  DeviceIdentity copyWith({
    String? deviceId,
    String? deviceName,
    String? secretKey,
    bool? isAuthorized,
  }) {
    return DeviceIdentity(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      secretKey: secretKey ?? this.secretKey,
      isAuthorized: isAuthorized ?? this.isAuthorized,
    );
  }
}
