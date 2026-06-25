// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../app_effects.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppEffects {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppEffects);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppEffects()';
}


}

/// @nodoc
class $AppEffectsCopyWith<$Res>  {
$AppEffectsCopyWith(AppEffects _, $Res Function(AppEffects) __);
}


/// Adds pattern-matching-related methods to [AppEffects].
extension AppEffectsPatterns on AppEffects {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShowLoadingEffect value)?  showLoading,TResult Function( HideLoadingEffect value)?  hideLoading,TResult Function( ShowToastEffect value)?  showToast,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShowLoadingEffect() when showLoading != null:
return showLoading(_that);case HideLoadingEffect() when hideLoading != null:
return hideLoading(_that);case ShowToastEffect() when showToast != null:
return showToast(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShowLoadingEffect value)  showLoading,required TResult Function( HideLoadingEffect value)  hideLoading,required TResult Function( ShowToastEffect value)  showToast,}){
final _that = this;
switch (_that) {
case ShowLoadingEffect():
return showLoading(_that);case HideLoadingEffect():
return hideLoading(_that);case ShowToastEffect():
return showToast(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShowLoadingEffect value)?  showLoading,TResult? Function( HideLoadingEffect value)?  hideLoading,TResult? Function( ShowToastEffect value)?  showToast,}){
final _that = this;
switch (_that) {
case ShowLoadingEffect() when showLoading != null:
return showLoading(_that);case HideLoadingEffect() when hideLoading != null:
return hideLoading(_that);case ShowToastEffect() when showToast != null:
return showToast(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message,  bool dismissible)?  showLoading,TResult Function()?  hideLoading,TResult Function( String message,  ToastType type)?  showToast,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShowLoadingEffect() when showLoading != null:
return showLoading(_that.message,_that.dismissible);case HideLoadingEffect() when hideLoading != null:
return hideLoading();case ShowToastEffect() when showToast != null:
return showToast(_that.message,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message,  bool dismissible)  showLoading,required TResult Function()  hideLoading,required TResult Function( String message,  ToastType type)  showToast,}) {final _that = this;
switch (_that) {
case ShowLoadingEffect():
return showLoading(_that.message,_that.dismissible);case HideLoadingEffect():
return hideLoading();case ShowToastEffect():
return showToast(_that.message,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message,  bool dismissible)?  showLoading,TResult? Function()?  hideLoading,TResult? Function( String message,  ToastType type)?  showToast,}) {final _that = this;
switch (_that) {
case ShowLoadingEffect() when showLoading != null:
return showLoading(_that.message,_that.dismissible);case HideLoadingEffect() when hideLoading != null:
return hideLoading();case ShowToastEffect() when showToast != null:
return showToast(_that.message,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class ShowLoadingEffect implements AppEffects {
  const ShowLoadingEffect({this.message, this.dismissible = false});
  

 final  String? message;
@JsonKey() final  bool dismissible;

/// Create a copy of AppEffects
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowLoadingEffectCopyWith<ShowLoadingEffect> get copyWith => _$ShowLoadingEffectCopyWithImpl<ShowLoadingEffect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowLoadingEffect&&(identical(other.message, message) || other.message == message)&&(identical(other.dismissible, dismissible) || other.dismissible == dismissible));
}


@override
int get hashCode => Object.hash(runtimeType,message,dismissible);

@override
String toString() {
  return 'AppEffects.showLoading(message: $message, dismissible: $dismissible)';
}


}

/// @nodoc
abstract mixin class $ShowLoadingEffectCopyWith<$Res> implements $AppEffectsCopyWith<$Res> {
  factory $ShowLoadingEffectCopyWith(ShowLoadingEffect value, $Res Function(ShowLoadingEffect) _then) = _$ShowLoadingEffectCopyWithImpl;
@useResult
$Res call({
 String? message, bool dismissible
});




}
/// @nodoc
class _$ShowLoadingEffectCopyWithImpl<$Res>
    implements $ShowLoadingEffectCopyWith<$Res> {
  _$ShowLoadingEffectCopyWithImpl(this._self, this._then);

  final ShowLoadingEffect _self;
  final $Res Function(ShowLoadingEffect) _then;

/// Create a copy of AppEffects
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? dismissible = null,}) {
  return _then(ShowLoadingEffect(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,dismissible: null == dismissible ? _self.dismissible : dismissible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class HideLoadingEffect implements AppEffects {
  const HideLoadingEffect();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HideLoadingEffect);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppEffects.hideLoading()';
}


}




/// @nodoc


class ShowToastEffect implements AppEffects {
  const ShowToastEffect({required this.message, this.type = ToastType.info});
  

 final  String message;
@JsonKey() final  ToastType type;

/// Create a copy of AppEffects
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowToastEffectCopyWith<ShowToastEffect> get copyWith => _$ShowToastEffectCopyWithImpl<ShowToastEffect>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowToastEffect&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,message,type);

@override
String toString() {
  return 'AppEffects.showToast(message: $message, type: $type)';
}


}

/// @nodoc
abstract mixin class $ShowToastEffectCopyWith<$Res> implements $AppEffectsCopyWith<$Res> {
  factory $ShowToastEffectCopyWith(ShowToastEffect value, $Res Function(ShowToastEffect) _then) = _$ShowToastEffectCopyWithImpl;
@useResult
$Res call({
 String message, ToastType type
});




}
/// @nodoc
class _$ShowToastEffectCopyWithImpl<$Res>
    implements $ShowToastEffectCopyWith<$Res> {
  _$ShowToastEffectCopyWithImpl(this._self, this._then);

  final ShowToastEffect _self;
  final $Res Function(ShowToastEffect) _then;

/// Create a copy of AppEffects
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? type = null,}) {
  return _then(ShowToastEffect(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ToastType,
  ));
}


}

// dart format on
