import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../../core/api/api_client.dart';
import '../models/device_identity.dart';
import '../models/api_responses.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  AuthRepository(this._apiClient);

  Future<String> getHardwareId() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return info.id;
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return info.identifierForVendor ?? 'unknown_ios';
    }
    return 'unknown_platform';
  }

  Future<DeviceIdentity> initialize({String? secretKey}) async {
    final hardwareId = await getHardwareId();

    try {
      final response = await _apiClient.initializeDevice({
        'device_id': hardwareId,
        if (secretKey != null) 'secret_key': secretKey,
      });

      if (response.isAuthorized) {
        return DeviceIdentity(
          deviceId: hardwareId,
          deviceName: response.deviceName,
          secretKey: response.secretKey ?? '',
          isAuthorized: true,
        );
      } else {
        return DeviceIdentity(
          deviceId: hardwareId,
          deviceName: 'Waiting for approval...',
          secretKey: '',
          isAuthorized: false,
        );
      }
    } catch (e) {
      if (secretKey != null && secretKey.isNotEmpty) {
        return DeviceIdentity(
          deviceId: hardwareId,
          deviceName: 'Fleet Unit (Offline)',
          secretKey: secretKey,
          isAuthorized: true,
        );
      }

      return DeviceIdentity(
        deviceId: hardwareId,
        deviceName: 'Offline / Unknown',
        secretKey: '',
        isAuthorized: false,
      );
    }
  }

  Future<DeviceIdentity> register(String deviceId, String secretKey) async {
    try {
      final response = await _apiClient.initializeDevice({
        'device_id': deviceId,
        'secret_key': secretKey,
      });

      if (response.isAuthorized) {
        return DeviceIdentity(
          deviceId: deviceId,
          deviceName: response.deviceName,
          secretKey: response.secretKey ?? '',
          isAuthorized: true,
        );
      } else {
        throw Exception('Activation failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DeviceInfoResponse> pullDeviceInfo() async {
    try {
      return await _apiClient.getDeviceInfo();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pushDeviceInfo(Map<String, dynamic> info) async {
    try {
      await _apiClient.updateDeviceInfo(info);
    } catch (e) {
      rethrow;
    }
  }
}
