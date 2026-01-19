part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authorized(DeviceIdentity identity) = AuthAuthorized;
  const factory AuthState.unauthorized(DeviceIdentity identity) = AuthUnauthorized;
  const factory AuthState.error(String message) = AuthError;
}
