// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../keyboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KeyboardState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyboardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KeyboardState()';
}


}

/// @nodoc
class $KeyboardStateCopyWith<$Res>  {
$KeyboardStateCopyWith(KeyboardState _, $Res Function(KeyboardState) __);
}


/// Adds pattern-matching-related methods to [KeyboardState].
extension KeyboardStatePatterns on KeyboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Data value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Data() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Data value)  data,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Data():
return data(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Data value)?  data,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Data() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ReplyStyle> styles,  ReplyStyle? selectedStyle,  String inputText,  int? generatingStyleId)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Data() when data != null:
return data(_that.styles,_that.selectedStyle,_that.inputText,_that.generatingStyleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ReplyStyle> styles,  ReplyStyle? selectedStyle,  String inputText,  int? generatingStyleId)  data,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Data():
return data(_that.styles,_that.selectedStyle,_that.inputText,_that.generatingStyleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ReplyStyle> styles,  ReplyStyle? selectedStyle,  String inputText,  int? generatingStyleId)?  data,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Data() when data != null:
return data(_that.styles,_that.selectedStyle,_that.inputText,_that.generatingStyleId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements KeyboardState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KeyboardState.initial()';
}


}




/// @nodoc


class _Loading implements KeyboardState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KeyboardState.loading()';
}


}




/// @nodoc


class _Data implements KeyboardState {
  const _Data({required final  List<ReplyStyle> styles, required this.selectedStyle, required this.inputText, this.generatingStyleId}): _styles = styles;
  

 final  List<ReplyStyle> _styles;
 List<ReplyStyle> get styles {
  if (_styles is EqualUnmodifiableListView) return _styles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_styles);
}

 final  ReplyStyle? selectedStyle;
 final  String inputText;
/// 当前正在生成回复的风格 ID，null 表示没有风格正在生成
 final  int? generatingStyleId;

/// Create a copy of KeyboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataCopyWith<_Data> get copyWith => __$DataCopyWithImpl<_Data>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Data&&const DeepCollectionEquality().equals(other._styles, _styles)&&(identical(other.selectedStyle, selectedStyle) || other.selectedStyle == selectedStyle)&&(identical(other.inputText, inputText) || other.inputText == inputText)&&(identical(other.generatingStyleId, generatingStyleId) || other.generatingStyleId == generatingStyleId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_styles),selectedStyle,inputText,generatingStyleId);

@override
String toString() {
  return 'KeyboardState.data(styles: $styles, selectedStyle: $selectedStyle, inputText: $inputText, generatingStyleId: $generatingStyleId)';
}


}

/// @nodoc
abstract mixin class _$DataCopyWith<$Res> implements $KeyboardStateCopyWith<$Res> {
  factory _$DataCopyWith(_Data value, $Res Function(_Data) _then) = __$DataCopyWithImpl;
@useResult
$Res call({
 List<ReplyStyle> styles, ReplyStyle? selectedStyle, String inputText, int? generatingStyleId
});


$ReplyStyleCopyWith<$Res>? get selectedStyle;

}
/// @nodoc
class __$DataCopyWithImpl<$Res>
    implements _$DataCopyWith<$Res> {
  __$DataCopyWithImpl(this._self, this._then);

  final _Data _self;
  final $Res Function(_Data) _then;

/// Create a copy of KeyboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? styles = null,Object? selectedStyle = freezed,Object? inputText = null,Object? generatingStyleId = freezed,}) {
  return _then(_Data(
styles: null == styles ? _self._styles : styles // ignore: cast_nullable_to_non_nullable
as List<ReplyStyle>,selectedStyle: freezed == selectedStyle ? _self.selectedStyle : selectedStyle // ignore: cast_nullable_to_non_nullable
as ReplyStyle?,inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,generatingStyleId: freezed == generatingStyleId ? _self.generatingStyleId : generatingStyleId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of KeyboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplyStyleCopyWith<$Res>? get selectedStyle {
    if (_self.selectedStyle == null) {
    return null;
  }

  return $ReplyStyleCopyWith<$Res>(_self.selectedStyle!, (value) {
    return _then(_self.copyWith(selectedStyle: value));
  });
}
}

// dart format on
