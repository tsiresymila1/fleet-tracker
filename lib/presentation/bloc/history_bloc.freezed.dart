// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HistoryEvent {

 DateTime get startDate; DateTime get endDate;
/// Create a copy of HistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEventCopyWith<HistoryEvent> get copyWith => _$HistoryEventCopyWithImpl<HistoryEvent>(this as HistoryEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEvent&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'HistoryEvent(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $HistoryEventCopyWith<$Res>  {
  factory $HistoryEventCopyWith(HistoryEvent value, $Res Function(HistoryEvent) _then) = _$HistoryEventCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$HistoryEventCopyWithImpl<$Res>
    implements $HistoryEventCopyWith<$Res> {
  _$HistoryEventCopyWithImpl(this._self, this._then);

  final HistoryEvent _self;
  final $Res Function(HistoryEvent) _then;

/// Create a copy of HistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryEvent].
extension HistoryEventPatterns on HistoryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HistoryLoadRequested value)?  loadHistory,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HistoryLoadRequested() when loadHistory != null:
return loadHistory(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HistoryLoadRequested value)  loadHistory,}){
final _that = this;
switch (_that) {
case HistoryLoadRequested():
return loadHistory(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HistoryLoadRequested value)?  loadHistory,}){
final _that = this;
switch (_that) {
case HistoryLoadRequested() when loadHistory != null:
return loadHistory(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime startDate,  DateTime endDate)?  loadHistory,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HistoryLoadRequested() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime startDate,  DateTime endDate)  loadHistory,}) {final _that = this;
switch (_that) {
case HistoryLoadRequested():
return loadHistory(_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime startDate,  DateTime endDate)?  loadHistory,}) {final _that = this;
switch (_that) {
case HistoryLoadRequested() when loadHistory != null:
return loadHistory(_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class HistoryLoadRequested implements HistoryEvent {
  const HistoryLoadRequested({required this.startDate, required this.endDate});
  

@override final  DateTime startDate;
@override final  DateTime endDate;

/// Create a copy of HistoryEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadRequestedCopyWith<HistoryLoadRequested> get copyWith => _$HistoryLoadRequestedCopyWithImpl<HistoryLoadRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoadRequested&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'HistoryEvent.loadHistory(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadRequestedCopyWith<$Res> implements $HistoryEventCopyWith<$Res> {
  factory $HistoryLoadRequestedCopyWith(HistoryLoadRequested value, $Res Function(HistoryLoadRequested) _then) = _$HistoryLoadRequestedCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$HistoryLoadRequestedCopyWithImpl<$Res>
    implements $HistoryLoadRequestedCopyWith<$Res> {
  _$HistoryLoadRequestedCopyWithImpl(this._self, this._then);

  final HistoryLoadRequested _self;
  final $Res Function(HistoryLoadRequested) _then;

/// Create a copy of HistoryEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(HistoryLoadRequested(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$HistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState()';
}


}

/// @nodoc
class $HistoryStateCopyWith<$Res>  {
$HistoryStateCopyWith(HistoryState _, $Res Function(HistoryState) __);
}


/// Adds pattern-matching-related methods to [HistoryState].
extension HistoryStatePatterns on HistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HistoryInitial value)?  initial,TResult Function( HistoryLoading value)?  loading,TResult Function( HistoryLoaded value)?  loaded,TResult Function( HistoryEmpty value)?  empty,TResult Function( HistoryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryEmpty() when empty != null:
return empty(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HistoryInitial value)  initial,required TResult Function( HistoryLoading value)  loading,required TResult Function( HistoryLoaded value)  loaded,required TResult Function( HistoryEmpty value)  empty,required TResult Function( HistoryError value)  error,}){
final _that = this;
switch (_that) {
case HistoryInitial():
return initial(_that);case HistoryLoading():
return loading(_that);case HistoryLoaded():
return loaded(_that);case HistoryEmpty():
return empty(_that);case HistoryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HistoryInitial value)?  initial,TResult? Function( HistoryLoading value)?  loading,TResult? Function( HistoryLoaded value)?  loaded,TResult? Function( HistoryEmpty value)?  empty,TResult? Function( HistoryError value)?  error,}){
final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial(_that);case HistoryLoading() when loading != null:
return loading(_that);case HistoryLoaded() when loaded != null:
return loaded(_that);case HistoryEmpty() when empty != null:
return empty(_that);case HistoryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PositionData> positions,  DateTime startDate,  DateTime endDate)?  loaded,TResult Function( DateTime startDate,  DateTime endDate)?  empty,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.positions,_that.startDate,_that.endDate);case HistoryEmpty() when empty != null:
return empty(_that.startDate,_that.endDate);case HistoryError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PositionData> positions,  DateTime startDate,  DateTime endDate)  loaded,required TResult Function( DateTime startDate,  DateTime endDate)  empty,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case HistoryInitial():
return initial();case HistoryLoading():
return loading();case HistoryLoaded():
return loaded(_that.positions,_that.startDate,_that.endDate);case HistoryEmpty():
return empty(_that.startDate,_that.endDate);case HistoryError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PositionData> positions,  DateTime startDate,  DateTime endDate)?  loaded,TResult? Function( DateTime startDate,  DateTime endDate)?  empty,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case HistoryInitial() when initial != null:
return initial();case HistoryLoading() when loading != null:
return loading();case HistoryLoaded() when loaded != null:
return loaded(_that.positions,_that.startDate,_that.endDate);case HistoryEmpty() when empty != null:
return empty(_that.startDate,_that.endDate);case HistoryError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HistoryInitial implements HistoryState {
  const HistoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState.initial()';
}


}




/// @nodoc


class HistoryLoading implements HistoryState {
  const HistoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HistoryState.loading()';
}


}




/// @nodoc


class HistoryLoaded implements HistoryState {
  const HistoryLoaded({required final  List<PositionData> positions, required this.startDate, required this.endDate}): _positions = positions;
  

 final  List<PositionData> _positions;
 List<PositionData> get positions {
  if (_positions is EqualUnmodifiableListView) return _positions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_positions);
}

 final  DateTime startDate;
 final  DateTime endDate;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryLoadedCopyWith<HistoryLoaded> get copyWith => _$HistoryLoadedCopyWithImpl<HistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryLoaded&&const DeepCollectionEquality().equals(other._positions, _positions)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_positions),startDate,endDate);

@override
String toString() {
  return 'HistoryState.loaded(positions: $positions, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $HistoryLoadedCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryLoadedCopyWith(HistoryLoaded value, $Res Function(HistoryLoaded) _then) = _$HistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<PositionData> positions, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$HistoryLoadedCopyWithImpl<$Res>
    implements $HistoryLoadedCopyWith<$Res> {
  _$HistoryLoadedCopyWithImpl(this._self, this._then);

  final HistoryLoaded _self;
  final $Res Function(HistoryLoaded) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? positions = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(HistoryLoaded(
positions: null == positions ? _self._positions : positions // ignore: cast_nullable_to_non_nullable
as List<PositionData>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class HistoryEmpty implements HistoryState {
  const HistoryEmpty({required this.startDate, required this.endDate});
  

 final  DateTime startDate;
 final  DateTime endDate;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEmptyCopyWith<HistoryEmpty> get copyWith => _$HistoryEmptyCopyWithImpl<HistoryEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEmpty&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate);

@override
String toString() {
  return 'HistoryState.empty(startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $HistoryEmptyCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryEmptyCopyWith(HistoryEmpty value, $Res Function(HistoryEmpty) _then) = _$HistoryEmptyCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$HistoryEmptyCopyWithImpl<$Res>
    implements $HistoryEmptyCopyWith<$Res> {
  _$HistoryEmptyCopyWithImpl(this._self, this._then);

  final HistoryEmpty _self;
  final $Res Function(HistoryEmpty) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,}) {
  return _then(HistoryEmpty(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class HistoryError implements HistoryState {
  const HistoryError(this.message);
  

 final  String message;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryErrorCopyWith<HistoryError> get copyWith => _$HistoryErrorCopyWithImpl<HistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HistoryErrorCopyWith<$Res> implements $HistoryStateCopyWith<$Res> {
  factory $HistoryErrorCopyWith(HistoryError value, $Res Function(HistoryError) _then) = _$HistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HistoryErrorCopyWithImpl<$Res>
    implements $HistoryErrorCopyWith<$Res> {
  _$HistoryErrorCopyWithImpl(this._self, this._then);

  final HistoryError _self;
  final $Res Function(HistoryError) _then;

/// Create a copy of HistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HistoryError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
