part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.initialize() = AuthInitialize;
  const factory AuthEvent.register(String deviceId, String secretKey) = AuthRegister;
  const factory AuthEvent.logout() = AuthLogout;
}
