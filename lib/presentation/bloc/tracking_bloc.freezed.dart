// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent()';
}


}

/// @nodoc
class $TrackingEventCopyWith<$Res>  {
$TrackingEventCopyWith(TrackingEvent _, $Res Function(TrackingEvent) __);
}


/// Adds pattern-matching-related methods to [TrackingEvent].
extension TrackingEventPatterns on TrackingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TrackingStart value)?  start,TResult Function( TrackingStop value)?  stop,TResult Function( TrackingToggle value)?  toggle,TResult Function( TrackingPositionUpdated value)?  positionUpdated,TResult Function( TrackingAppResumed value)?  appResumed,TResult Function( TrackingAppPaused value)?  appPaused,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TrackingStart() when start != null:
return start(_that);case TrackingStop() when stop != null:
return stop(_that);case TrackingToggle() when toggle != null:
return toggle(_that);case TrackingPositionUpdated() when positionUpdated != null:
return positionUpdated(_that);case TrackingAppResumed() when appResumed != null:
return appResumed(_that);case TrackingAppPaused() when appPaused != null:
return appPaused(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TrackingStart value)  start,required TResult Function( TrackingStop value)  stop,required TResult Function( TrackingToggle value)  toggle,required TResult Function( TrackingPositionUpdated value)  positionUpdated,required TResult Function( TrackingAppResumed value)  appResumed,required TResult Function( TrackingAppPaused value)  appPaused,}){
final _that = this;
switch (_that) {
case TrackingStart():
return start(_that);case TrackingStop():
return stop(_that);case TrackingToggle():
return toggle(_that);case TrackingPositionUpdated():
return positionUpdated(_that);case TrackingAppResumed():
return appResumed(_that);case TrackingAppPaused():
return appPaused(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TrackingStart value)?  start,TResult? Function( TrackingStop value)?  stop,TResult? Function( TrackingToggle value)?  toggle,TResult? Function( TrackingPositionUpdated value)?  positionUpdated,TResult? Function( TrackingAppResumed value)?  appResumed,TResult? Function( TrackingAppPaused value)?  appPaused,}){
final _that = this;
switch (_that) {
case TrackingStart() when start != null:
return start(_that);case TrackingStop() when stop != null:
return stop(_that);case TrackingToggle() when toggle != null:
return toggle(_that);case TrackingPositionUpdated() when positionUpdated != null:
return positionUpdated(_that);case TrackingAppResumed() when appResumed != null:
return appResumed(_that);case TrackingAppPaused() when appPaused != null:
return appPaused(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  start,TResult Function()?  stop,TResult Function()?  toggle,TResult Function( Position position)?  positionUpdated,TResult Function()?  appResumed,TResult Function()?  appPaused,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TrackingStart() when start != null:
return start();case TrackingStop() when stop != null:
return stop();case TrackingToggle() when toggle != null:
return toggle();case TrackingPositionUpdated() when positionUpdated != null:
return positionUpdated(_that.position);case TrackingAppResumed() when appResumed != null:
return appResumed();case TrackingAppPaused() when appPaused != null:
return appPaused();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  start,required TResult Function()  stop,required TResult Function()  toggle,required TResult Function( Position position)  positionUpdated,required TResult Function()  appResumed,required TResult Function()  appPaused,}) {final _that = this;
switch (_that) {
case TrackingStart():
return start();case TrackingStop():
return stop();case TrackingToggle():
return toggle();case TrackingPositionUpdated():
return positionUpdated(_that.position);case TrackingAppResumed():
return appResumed();case TrackingAppPaused():
return appPaused();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  start,TResult? Function()?  stop,TResult? Function()?  toggle,TResult? Function( Position position)?  positionUpdated,TResult? Function()?  appResumed,TResult? Function()?  appPaused,}) {final _that = this;
switch (_that) {
case TrackingStart() when start != null:
return start();case TrackingStop() when stop != null:
return stop();case TrackingToggle() when toggle != null:
return toggle();case TrackingPositionUpdated() when positionUpdated != null:
return positionUpdated(_that.position);case TrackingAppResumed() when appResumed != null:
return appResumed();case TrackingAppPaused() when appPaused != null:
return appPaused();case _:
  return null;

}
}

}

/// @nodoc


class TrackingStart implements TrackingEvent {
  const TrackingStart();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingStart);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent.start()';
}


}




/// @nodoc


class TrackingStop implements TrackingEvent {
  const TrackingStop();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingStop);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent.stop()';
}


}




/// @nodoc


class TrackingToggle implements TrackingEvent {
  const TrackingToggle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingToggle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent.toggle()';
}


}




/// @nodoc


class TrackingPositionUpdated implements TrackingEvent {
  const TrackingPositionUpdated(this.position);
  

 final  Position position;

/// Create a copy of TrackingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingPositionUpdatedCopyWith<TrackingPositionUpdated> get copyWith => _$TrackingPositionUpdatedCopyWithImpl<TrackingPositionUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingPositionUpdated&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,position);

@override
String toString() {
  return 'TrackingEvent.positionUpdated(position: $position)';
}


}

/// @nodoc
abstract mixin class $TrackingPositionUpdatedCopyWith<$Res> implements $TrackingEventCopyWith<$Res> {
  factory $TrackingPositionUpdatedCopyWith(TrackingPositionUpdated value, $Res Function(TrackingPositionUpdated) _then) = _$TrackingPositionUpdatedCopyWithImpl;
@useResult
$Res call({
 Position position
});




}
/// @nodoc
class _$TrackingPositionUpdatedCopyWithImpl<$Res>
    implements $TrackingPositionUpdatedCopyWith<$Res> {
  _$TrackingPositionUpdatedCopyWithImpl(this._self, this._then);

  final TrackingPositionUpdated _self;
  final $Res Function(TrackingPositionUpdated) _then;

/// Create a copy of TrackingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? position = null,}) {
  return _then(TrackingPositionUpdated(
null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,
  ));
}


}

/// @nodoc


class TrackingAppResumed implements TrackingEvent {
  const TrackingAppResumed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingAppResumed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent.appResumed()';
}


}




/// @nodoc


class TrackingAppPaused implements TrackingEvent {
  const TrackingAppPaused();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingAppPaused);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingEvent.appPaused()';
}


}




/// @nodoc
mixin _$TrackingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState()';
}


}

/// @nodoc
class $TrackingStateCopyWith<$Res>  {
$TrackingStateCopyWith(TrackingState _, $Res Function(TrackingState) __);
}


/// Adds pattern-matching-related methods to [TrackingState].
extension TrackingStatePatterns on TrackingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TrackingInitial value)?  initial,TResult Function( TrackingLoading value)?  loading,TResult Function( TrackingActive value)?  active,TResult Function( TrackingError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TrackingInitial() when initial != null:
return initial(_that);case TrackingLoading() when loading != null:
return loading(_that);case TrackingActive() when active != null:
return active(_that);case TrackingError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TrackingInitial value)  initial,required TResult Function( TrackingLoading value)  loading,required TResult Function( TrackingActive value)  active,required TResult Function( TrackingError value)  error,}){
final _that = this;
switch (_that) {
case TrackingInitial():
return initial(_that);case TrackingLoading():
return loading(_that);case TrackingActive():
return active(_that);case TrackingError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TrackingInitial value)?  initial,TResult? Function( TrackingLoading value)?  loading,TResult? Function( TrackingActive value)?  active,TResult? Function( TrackingError value)?  error,}){
final _that = this;
switch (_that) {
case TrackingInitial() when initial != null:
return initial(_that);case TrackingLoading() when loading != null:
return loading(_that);case TrackingActive() when active != null:
return active(_that);case TrackingError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Position currentPosition)?  active,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TrackingInitial() when initial != null:
return initial();case TrackingLoading() when loading != null:
return loading();case TrackingActive() when active != null:
return active(_that.currentPosition);case TrackingError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Position currentPosition)  active,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TrackingInitial():
return initial();case TrackingLoading():
return loading();case TrackingActive():
return active(_that.currentPosition);case TrackingError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Position currentPosition)?  active,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TrackingInitial() when initial != null:
return initial();case TrackingLoading() when loading != null:
return loading();case TrackingActive() when active != null:
return active(_that.currentPosition);case TrackingError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TrackingInitial implements TrackingState {
  const TrackingInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState.initial()';
}


}




/// @nodoc


class TrackingLoading implements TrackingState {
  const TrackingLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackingState.loading()';
}


}




/// @nodoc


class TrackingActive implements TrackingState {
  const TrackingActive(this.currentPosition);
  

 final  Position currentPosition;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingActiveCopyWith<TrackingActive> get copyWith => _$TrackingActiveCopyWithImpl<TrackingActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingActive&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition));
}


@override
int get hashCode => Object.hash(runtimeType,currentPosition);

@override
String toString() {
  return 'TrackingState.active(currentPosition: $currentPosition)';
}


}

/// @nodoc
abstract mixin class $TrackingActiveCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory $TrackingActiveCopyWith(TrackingActive value, $Res Function(TrackingActive) _then) = _$TrackingActiveCopyWithImpl;
@useResult
$Res call({
 Position currentPosition
});




}
/// @nodoc
class _$TrackingActiveCopyWithImpl<$Res>
    implements $TrackingActiveCopyWith<$Res> {
  _$TrackingActiveCopyWithImpl(this._self, this._then);

  final TrackingActive _self;
  final $Res Function(TrackingActive) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentPosition = null,}) {
  return _then(TrackingActive(
null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Position,
  ));
}


}

/// @nodoc


class TrackingError implements TrackingState {
  const TrackingError(this.message);
  

 final  String message;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackingErrorCopyWith<TrackingError> get copyWith => _$TrackingErrorCopyWithImpl<TrackingError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackingError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TrackingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TrackingErrorCopyWith<$Res> implements $TrackingStateCopyWith<$Res> {
  factory $TrackingErrorCopyWith(TrackingError value, $Res Function(TrackingError) _then) = _$TrackingErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TrackingErrorCopyWithImpl<$Res>
    implements $TrackingErrorCopyWith<$Res> {
  _$TrackingErrorCopyWithImpl(this._self, this._then);

  final TrackingError _self;
  final $Res Function(TrackingError) _then;

/// Create a copy of TrackingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TrackingError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
