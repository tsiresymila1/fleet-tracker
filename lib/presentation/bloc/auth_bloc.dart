import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/device_identity.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<AuthInitialize>(_onInitialize);
    on<AuthRegister>(_onRegister);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onInitialize(
    AuthInitialize event,
    Emitter<AuthState> emit,
  ) async {
    try {
      String? secretKey;
      state.mapOrNull(
        authorized: (s) => secretKey = s.identity.secretKey,
      );

      final identity = await _repository.initialize(secretKey: secretKey);

      if (identity.isAuthorized) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('device_id', identity.deviceId);
        await prefs.setString('secret_key', identity.secretKey);
        emit(AuthState.authorized(identity));
      } else {
        emit(AuthState.unauthorized(identity));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final identity = await _repository.register(
        event.deviceId,
        event.secretKey,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', identity.deviceId);
      await prefs.setString('secret_key', identity.secretKey);
      emit(AuthState.authorized(identity));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('device_id');
    await prefs.remove('secret_key');
    add(const AuthInitialize());
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;

      if (type == 'authorized') {
        final identity = DeviceIdentity(
          deviceId: json['deviceId'] as String,
          deviceName: json['deviceName'] as String,
          secretKey: json['secretKey'] as String,
          isAuthorized: true,
        );
        return AuthState.authorized(identity);
      } else if (type == 'unauthorized') {
        final identity = DeviceIdentity(
          deviceId: json['deviceId'] as String,
          deviceName: json['deviceName'] as String,
          secretKey: json['secretKey'] as String? ?? '',
          isAuthorized: false,
        );
        return AuthState.unauthorized(identity);
      }

      return const AuthState.initial();
    } catch (_) {
      return const AuthState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.maybeMap(
      authorized: (s) => {
        'type': 'authorized',
        'deviceId': s.identity.deviceId,
        'deviceName': s.identity.deviceName,
        'secretKey': s.identity.secretKey,
      },
      unauthorized: (s) => {
        'type': 'unauthorized',
        'deviceId': s.identity.deviceId,
        'deviceName': s.identity.deviceName,
        'secretKey': s.identity.secretKey,
      },
      orElse: () => null,
    );
  }
}
