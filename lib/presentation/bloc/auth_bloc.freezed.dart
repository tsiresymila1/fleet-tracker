// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitialize value)?  initialize,TResult Function( AuthRegister value)?  register,TResult Function( AuthLogout value)?  logout,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitialize() when initialize != null:
return initialize(_that);case AuthRegister() when register != null:
return register(_that);case AuthLogout() when logout != null:
return logout(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitialize value)  initialize,required TResult Function( AuthRegister value)  register,required TResult Function( AuthLogout value)  logout,}){
final _that = this;
switch (_that) {
case AuthInitialize():
return initialize(_that);case AuthRegister():
return register(_that);case AuthLogout():
return logout(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitialize value)?  initialize,TResult? Function( AuthRegister value)?  register,TResult? Function( AuthLogout value)?  logout,}){
final _that = this;
switch (_that) {
case AuthInitialize() when initialize != null:
return initialize(_that);case AuthRegister() when register != null:
return register(_that);case AuthLogout() when logout != null:
return logout(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initialize,TResult Function( String deviceId,  String secretKey)?  register,TResult Function()?  logout,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitialize() when initialize != null:
return initialize();case AuthRegister() when register != null:
return register(_that.deviceId,_that.secretKey);case AuthLogout() when logout != null:
return logout();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initialize,required TResult Function( String deviceId,  String secretKey)  register,required TResult Function()  logout,}) {final _that = this;
switch (_that) {
case AuthInitialize():
return initialize();case AuthRegister():
return register(_that.deviceId,_that.secretKey);case AuthLogout():
return logout();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initialize,TResult? Function( String deviceId,  String secretKey)?  register,TResult? Function()?  logout,}) {final _that = this;
switch (_that) {
case AuthInitialize() when initialize != null:
return initialize();case AuthRegister() when register != null:
return register(_that.deviceId,_that.secretKey);case AuthLogout() when logout != null:
return logout();case _:
  return null;

}
}

}

/// @nodoc


class AuthInitialize implements AuthEvent {
  const AuthInitialize();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitialize);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.initialize()';
}


}




/// @nodoc


class AuthRegister implements AuthEvent {
  const AuthRegister(this.deviceId, this.secretKey);
  

 final  String deviceId;
 final  String secretKey;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthRegisterCopyWith<AuthRegister> get copyWith => _$AuthRegisterCopyWithImpl<AuthRegister>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthRegister&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.secretKey, secretKey) || other.secretKey == secretKey));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId,secretKey);

@override
String toString() {
  return 'AuthEvent.register(deviceId: $deviceId, secretKey: $secretKey)';
}


}

/// @nodoc
abstract mixin class $AuthRegisterCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthRegisterCopyWith(AuthRegister value, $Res Function(AuthRegister) _then) = _$AuthRegisterCopyWithImpl;
@useResult
$Res call({
 String deviceId, String secretKey
});




}
/// @nodoc
class _$AuthRegisterCopyWithImpl<$Res>
    implements $AuthRegisterCopyWith<$Res> {
  _$AuthRegisterCopyWithImpl(this._self, this._then);

  final AuthRegister _self;
  final $Res Function(AuthRegister) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? secretKey = null,}) {
  return _then(AuthRegister(
null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,null == secretKey ? _self.secretKey : secretKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthLogout implements AuthEvent {
  const AuthLogout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLogout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logout()';
}


}




/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitial value)?  initial,TResult Function( AuthLoading value)?  loading,TResult Function( AuthAuthorized value)?  authorized,TResult Function( AuthUnauthorized value)?  unauthorized,TResult Function( AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthAuthorized() when authorized != null:
return authorized(_that);case AuthUnauthorized() when unauthorized != null:
return unauthorized(_that);case AuthError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitial value)  initial,required TResult Function( AuthLoading value)  loading,required TResult Function( AuthAuthorized value)  authorized,required TResult Function( AuthUnauthorized value)  unauthorized,required TResult Function( AuthError value)  error,}){
final _that = this;
switch (_that) {
case AuthInitial():
return initial(_that);case AuthLoading():
return loading(_that);case AuthAuthorized():
return authorized(_that);case AuthUnauthorized():
return unauthorized(_that);case AuthError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitial value)?  initial,TResult? Function( AuthLoading value)?  loading,TResult? Function( AuthAuthorized value)?  authorized,TResult? Function( AuthUnauthorized value)?  unauthorized,TResult? Function( AuthError value)?  error,}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthAuthorized() when authorized != null:
return authorized(_that);case AuthUnauthorized() when unauthorized != null:
return unauthorized(_that);case AuthError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( DeviceIdentity identity)?  authorized,TResult Function( DeviceIdentity identity)?  unauthorized,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthAuthorized() when authorized != null:
return authorized(_that.identity);case AuthUnauthorized() when unauthorized != null:
return unauthorized(_that.identity);case AuthError() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( DeviceIdentity identity)  authorized,required TResult Function( DeviceIdentity identity)  unauthorized,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AuthInitial():
return initial();case AuthLoading():
return loading();case AuthAuthorized():
return authorized(_that.identity);case AuthUnauthorized():
return unauthorized(_that.identity);case AuthError():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( DeviceIdentity identity)?  authorized,TResult? Function( DeviceIdentity identity)?  unauthorized,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthAuthorized() when authorized != null:
return authorized(_that.identity);case AuthUnauthorized() when unauthorized != null:
return unauthorized(_that.identity);case AuthError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthInitial implements AuthState {
  const AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class AuthLoading implements AuthState {
  const AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class AuthAuthorized implements AuthState {
  const AuthAuthorized(this.identity);
  

 final  DeviceIdentity identity;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthorizedCopyWith<AuthAuthorized> get copyWith => _$AuthAuthorizedCopyWithImpl<AuthAuthorized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthorized&&(identical(other.identity, identity) || other.identity == identity));
}


@override
int get hashCode => Object.hash(runtimeType,identity);

@override
String toString() {
  return 'AuthState.authorized(identity: $identity)';
}


}

/// @nodoc
abstract mixin class $AuthAuthorizedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthorizedCopyWith(AuthAuthorized value, $Res Function(AuthAuthorized) _then) = _$AuthAuthorizedCopyWithImpl;
@useResult
$Res call({
 DeviceIdentity identity
});




}
/// @nodoc
class _$AuthAuthorizedCopyWithImpl<$Res>
    implements $AuthAuthorizedCopyWith<$Res> {
  _$AuthAuthorizedCopyWithImpl(this._self, this._then);

  final AuthAuthorized _self;
  final $Res Function(AuthAuthorized) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? identity = null,}) {
  return _then(AuthAuthorized(
null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as DeviceIdentity,
  ));
}


}

/// @nodoc


class AuthUnauthorized implements AuthState {
  const AuthUnauthorized(this.identity);
  

 final  DeviceIdentity identity;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUnauthorizedCopyWith<AuthUnauthorized> get copyWith => _$AuthUnauthorizedCopyWithImpl<AuthUnauthorized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnauthorized&&(identical(other.identity, identity) || other.identity == identity));
}


@override
int get hashCode => Object.hash(runtimeType,identity);

@override
String toString() {
  return 'AuthState.unauthorized(identity: $identity)';
}


}

/// @nodoc
abstract mixin class $AuthUnauthorizedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthUnauthorizedCopyWith(AuthUnauthorized value, $Res Function(AuthUnauthorized) _then) = _$AuthUnauthorizedCopyWithImpl;
@useResult
$Res call({
 DeviceIdentity identity
});




}
/// @nodoc
class _$AuthUnauthorizedCopyWithImpl<$Res>
    implements $AuthUnauthorizedCopyWith<$Res> {
  _$AuthUnauthorizedCopyWithImpl(this._self, this._then);

  final AuthUnauthorized _self;
  final $Res Function(AuthUnauthorized) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? identity = null,}) {
  return _then(AuthUnauthorized(
null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as DeviceIdentity,
  ));
}


}

/// @nodoc


class AuthError implements AuthState {
  const AuthError(this.message);
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
