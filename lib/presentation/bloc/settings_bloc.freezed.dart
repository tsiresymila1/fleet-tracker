// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsUpdateTheme value)?  updateTheme,TResult Function( SettingsUpdateLanguage value)?  updateLanguage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsUpdateTheme() when updateTheme != null:
return updateTheme(_that);case SettingsUpdateLanguage() when updateLanguage != null:
return updateLanguage(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsUpdateTheme value)  updateTheme,required TResult Function( SettingsUpdateLanguage value)  updateLanguage,}){
final _that = this;
switch (_that) {
case SettingsUpdateTheme():
return updateTheme(_that);case SettingsUpdateLanguage():
return updateLanguage(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsUpdateTheme value)?  updateTheme,TResult? Function( SettingsUpdateLanguage value)?  updateLanguage,}){
final _that = this;
switch (_that) {
case SettingsUpdateTheme() when updateTheme != null:
return updateTheme(_that);case SettingsUpdateLanguage() when updateLanguage != null:
return updateLanguage(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ThemeMode themeMode)?  updateTheme,TResult Function( Locale locale)?  updateLanguage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsUpdateTheme() when updateTheme != null:
return updateTheme(_that.themeMode);case SettingsUpdateLanguage() when updateLanguage != null:
return updateLanguage(_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ThemeMode themeMode)  updateTheme,required TResult Function( Locale locale)  updateLanguage,}) {final _that = this;
switch (_that) {
case SettingsUpdateTheme():
return updateTheme(_that.themeMode);case SettingsUpdateLanguage():
return updateLanguage(_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ThemeMode themeMode)?  updateTheme,TResult? Function( Locale locale)?  updateLanguage,}) {final _that = this;
switch (_that) {
case SettingsUpdateTheme() when updateTheme != null:
return updateTheme(_that.themeMode);case SettingsUpdateLanguage() when updateLanguage != null:
return updateLanguage(_that.locale);case _:
  return null;

}
}

}

/// @nodoc


class SettingsUpdateTheme implements SettingsEvent {
  const SettingsUpdateTheme(this.themeMode);
  

 final  ThemeMode themeMode;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUpdateThemeCopyWith<SettingsUpdateTheme> get copyWith => _$SettingsUpdateThemeCopyWithImpl<SettingsUpdateTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUpdateTheme&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode);

@override
String toString() {
  return 'SettingsEvent.updateTheme(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $SettingsUpdateThemeCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory $SettingsUpdateThemeCopyWith(SettingsUpdateTheme value, $Res Function(SettingsUpdateTheme) _then) = _$SettingsUpdateThemeCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class _$SettingsUpdateThemeCopyWithImpl<$Res>
    implements $SettingsUpdateThemeCopyWith<$Res> {
  _$SettingsUpdateThemeCopyWithImpl(this._self, this._then);

  final SettingsUpdateTheme _self;
  final $Res Function(SettingsUpdateTheme) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeMode = null,}) {
  return _then(SettingsUpdateTheme(
null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc


class SettingsUpdateLanguage implements SettingsEvent {
  const SettingsUpdateLanguage(this.locale);
  

 final  Locale locale;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUpdateLanguageCopyWith<SettingsUpdateLanguage> get copyWith => _$SettingsUpdateLanguageCopyWithImpl<SettingsUpdateLanguage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUpdateLanguage&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,locale);

@override
String toString() {
  return 'SettingsEvent.updateLanguage(locale: $locale)';
}


}

/// @nodoc
abstract mixin class $SettingsUpdateLanguageCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory $SettingsUpdateLanguageCopyWith(SettingsUpdateLanguage value, $Res Function(SettingsUpdateLanguage) _then) = _$SettingsUpdateLanguageCopyWithImpl;
@useResult
$Res call({
 Locale locale
});




}
/// @nodoc
class _$SettingsUpdateLanguageCopyWithImpl<$Res>
    implements $SettingsUpdateLanguageCopyWith<$Res> {
  _$SettingsUpdateLanguageCopyWithImpl(this._self, this._then);

  final SettingsUpdateLanguage _self;
  final $Res Function(SettingsUpdateLanguage) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locale = null,}) {
  return _then(SettingsUpdateLanguage(
null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,
  ));
}


}

/// @nodoc
mixin _$SettingsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState()';
}


}

/// @nodoc
class $SettingsStateCopyWith<$Res>  {
$SettingsStateCopyWith(SettingsState _, $Res Function(SettingsState) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsInitial value)?  initial,TResult Function( SettingsLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial(_that);case SettingsLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsInitial value)  initial,required TResult Function( SettingsLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case SettingsInitial():
return initial(_that);case SettingsLoaded():
return loaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsInitial value)?  initial,TResult? Function( SettingsLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial(_that);case SettingsLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ThemeMode themeMode,  Locale locale)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial();case SettingsLoaded() when loaded != null:
return loaded(_that.themeMode,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ThemeMode themeMode,  Locale locale)  loaded,}) {final _that = this;
switch (_that) {
case SettingsInitial():
return initial();case SettingsLoaded():
return loaded(_that.themeMode,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ThemeMode themeMode,  Locale locale)?  loaded,}) {final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial();case SettingsLoaded() when loaded != null:
return loaded(_that.themeMode,_that.locale);case _:
  return null;

}
}

}

/// @nodoc


class SettingsInitial implements SettingsState {
  const SettingsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.initial()';
}


}




/// @nodoc


class SettingsLoaded implements SettingsState {
  const SettingsLoaded({required this.themeMode, required this.locale});
  

 final  ThemeMode themeMode;
 final  Locale locale;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsLoadedCopyWith<SettingsLoaded> get copyWith => _$SettingsLoadedCopyWithImpl<SettingsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsLoaded&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.locale, locale) || other.locale == locale));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,locale);

@override
String toString() {
  return 'SettingsState.loaded(themeMode: $themeMode, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $SettingsLoadedCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsLoadedCopyWith(SettingsLoaded value, $Res Function(SettingsLoaded) _then) = _$SettingsLoadedCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, Locale locale
});




}
/// @nodoc
class _$SettingsLoadedCopyWithImpl<$Res>
    implements $SettingsLoadedCopyWith<$Res> {
  _$SettingsLoadedCopyWithImpl(this._self, this._then);

  final SettingsLoaded _self;
  final $Res Function(SettingsLoaded) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? locale = null,}) {
  return _then(SettingsLoaded(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale,
  ));
}


}

// dart format on
