// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../configuration_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfigurationInfo {

/// 配置数据版本号，用于后续数据结构变更时的迁移兼容
@JsonKey(name: 'version') int get version;/// AI 平台配置列表
@JsonKey(name: 'platforms') List<AiPlatform> get platforms;/// 应用偏好设置
@JsonKey(name: 'preferences') List<AppPreference> get preferences;/// 回复风格配置（9 种内置风格）
@JsonKey(name: 'replyStyles') List<ReplyStyle> get replyStyles;
/// Create a copy of ConfigurationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigurationInfoCopyWith<ConfigurationInfo> get copyWith => _$ConfigurationInfoCopyWithImpl<ConfigurationInfo>(this as ConfigurationInfo, _$identity);

  /// Serializes this ConfigurationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigurationInfo&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.platforms, platforms)&&const DeepCollectionEquality().equals(other.preferences, preferences)&&const DeepCollectionEquality().equals(other.replyStyles, replyStyles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(platforms),const DeepCollectionEquality().hash(preferences),const DeepCollectionEquality().hash(replyStyles));

@override
String toString() {
  return 'ConfigurationInfo(version: $version, platforms: $platforms, preferences: $preferences, replyStyles: $replyStyles)';
}


}

/// @nodoc
abstract mixin class $ConfigurationInfoCopyWith<$Res>  {
  factory $ConfigurationInfoCopyWith(ConfigurationInfo value, $Res Function(ConfigurationInfo) _then) = _$ConfigurationInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version') int version,@JsonKey(name: 'platforms') List<AiPlatform> platforms,@JsonKey(name: 'preferences') List<AppPreference> preferences,@JsonKey(name: 'replyStyles') List<ReplyStyle> replyStyles
});




}
/// @nodoc
class _$ConfigurationInfoCopyWithImpl<$Res>
    implements $ConfigurationInfoCopyWith<$Res> {
  _$ConfigurationInfoCopyWithImpl(this._self, this._then);

  final ConfigurationInfo _self;
  final $Res Function(ConfigurationInfo) _then;

/// Create a copy of ConfigurationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? platforms = null,Object? preferences = null,Object? replyStyles = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,platforms: null == platforms ? _self.platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<AiPlatform>,preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<AppPreference>,replyStyles: null == replyStyles ? _self.replyStyles : replyStyles // ignore: cast_nullable_to_non_nullable
as List<ReplyStyle>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConfigurationInfo].
extension ConfigurationInfoPatterns on ConfigurationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConfigurationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConfigurationInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConfigurationInfo value)  $default,){
final _that = this;
switch (_that) {
case _ConfigurationInfo():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConfigurationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ConfigurationInfo() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'version')  int version, @JsonKey(name: 'platforms')  List<AiPlatform> platforms, @JsonKey(name: 'preferences')  List<AppPreference> preferences, @JsonKey(name: 'replyStyles')  List<ReplyStyle> replyStyles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConfigurationInfo() when $default != null:
return $default(_that.version,_that.platforms,_that.preferences,_that.replyStyles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'version')  int version, @JsonKey(name: 'platforms')  List<AiPlatform> platforms, @JsonKey(name: 'preferences')  List<AppPreference> preferences, @JsonKey(name: 'replyStyles')  List<ReplyStyle> replyStyles)  $default,) {final _that = this;
switch (_that) {
case _ConfigurationInfo():
return $default(_that.version,_that.platforms,_that.preferences,_that.replyStyles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'version')  int version, @JsonKey(name: 'platforms')  List<AiPlatform> platforms, @JsonKey(name: 'preferences')  List<AppPreference> preferences, @JsonKey(name: 'replyStyles')  List<ReplyStyle> replyStyles)?  $default,) {final _that = this;
switch (_that) {
case _ConfigurationInfo() when $default != null:
return $default(_that.version,_that.platforms,_that.preferences,_that.replyStyles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConfigurationInfo implements ConfigurationInfo {
  const _ConfigurationInfo({@JsonKey(name: 'version') this.version = 1, @JsonKey(name: 'platforms') final  List<AiPlatform> platforms = AppConstants.defaultAiPlatform, @JsonKey(name: 'preferences') final  List<AppPreference> preferences = AppConstants.defaultAppPreference, @JsonKey(name: 'replyStyles') final  List<ReplyStyle> replyStyles = AppConstants.defaultReplyStyles}): _platforms = platforms,_preferences = preferences,_replyStyles = replyStyles;
  factory _ConfigurationInfo.fromJson(Map<String, dynamic> json) => _$ConfigurationInfoFromJson(json);

/// 配置数据版本号，用于后续数据结构变更时的迁移兼容
@override@JsonKey(name: 'version') final  int version;
/// AI 平台配置列表
 final  List<AiPlatform> _platforms;
/// AI 平台配置列表
@override@JsonKey(name: 'platforms') List<AiPlatform> get platforms {
  if (_platforms is EqualUnmodifiableListView) return _platforms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_platforms);
}

/// 应用偏好设置
 final  List<AppPreference> _preferences;
/// 应用偏好设置
@override@JsonKey(name: 'preferences') List<AppPreference> get preferences {
  if (_preferences is EqualUnmodifiableListView) return _preferences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_preferences);
}

/// 回复风格配置（9 种内置风格）
 final  List<ReplyStyle> _replyStyles;
/// 回复风格配置（9 种内置风格）
@override@JsonKey(name: 'replyStyles') List<ReplyStyle> get replyStyles {
  if (_replyStyles is EqualUnmodifiableListView) return _replyStyles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replyStyles);
}


/// Create a copy of ConfigurationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigurationInfoCopyWith<_ConfigurationInfo> get copyWith => __$ConfigurationInfoCopyWithImpl<_ConfigurationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigurationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigurationInfo&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._platforms, _platforms)&&const DeepCollectionEquality().equals(other._preferences, _preferences)&&const DeepCollectionEquality().equals(other._replyStyles, _replyStyles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_platforms),const DeepCollectionEquality().hash(_preferences),const DeepCollectionEquality().hash(_replyStyles));

@override
String toString() {
  return 'ConfigurationInfo(version: $version, platforms: $platforms, preferences: $preferences, replyStyles: $replyStyles)';
}


}

/// @nodoc
abstract mixin class _$ConfigurationInfoCopyWith<$Res> implements $ConfigurationInfoCopyWith<$Res> {
  factory _$ConfigurationInfoCopyWith(_ConfigurationInfo value, $Res Function(_ConfigurationInfo) _then) = __$ConfigurationInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version') int version,@JsonKey(name: 'platforms') List<AiPlatform> platforms,@JsonKey(name: 'preferences') List<AppPreference> preferences,@JsonKey(name: 'replyStyles') List<ReplyStyle> replyStyles
});




}
/// @nodoc
class __$ConfigurationInfoCopyWithImpl<$Res>
    implements _$ConfigurationInfoCopyWith<$Res> {
  __$ConfigurationInfoCopyWithImpl(this._self, this._then);

  final _ConfigurationInfo _self;
  final $Res Function(_ConfigurationInfo) _then;

/// Create a copy of ConfigurationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? platforms = null,Object? preferences = null,Object? replyStyles = null,}) {
  return _then(_ConfigurationInfo(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,platforms: null == platforms ? _self._platforms : platforms // ignore: cast_nullable_to_non_nullable
as List<AiPlatform>,preferences: null == preferences ? _self._preferences : preferences // ignore: cast_nullable_to_non_nullable
as List<AppPreference>,replyStyles: null == replyStyles ? _self._replyStyles : replyStyles // ignore: cast_nullable_to_non_nullable
as List<ReplyStyle>,
  ));
}


}


/// @nodoc
mixin _$AiPlatform {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'baseUrl') String get baseUrl;@JsonKey(name: 'apiKey') String get apiKey;/// 该平台可用的模型列表（内置默认值 + API 刷新）
@JsonKey(name: 'models') List<String> get models;/// 当前选中的模型
@JsonKey(name: 'selectedModel') String get selectedModel;/// 是否启用该平台
@JsonKey(name: 'enable') bool get enable;
/// Create a copy of AiPlatform
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiPlatformCopyWith<AiPlatform> get copyWith => _$AiPlatformCopyWithImpl<AiPlatform>(this as AiPlatform, _$identity);

  /// Serializes this AiPlatform to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiPlatform&&(identical(other.name, name) || other.name == name)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&const DeepCollectionEquality().equals(other.models, models)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&(identical(other.enable, enable) || other.enable == enable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,baseUrl,apiKey,const DeepCollectionEquality().hash(models),selectedModel,enable);

@override
String toString() {
  return 'AiPlatform(name: $name, baseUrl: $baseUrl, apiKey: $apiKey, models: $models, selectedModel: $selectedModel, enable: $enable)';
}


}

/// @nodoc
abstract mixin class $AiPlatformCopyWith<$Res>  {
  factory $AiPlatformCopyWith(AiPlatform value, $Res Function(AiPlatform) _then) = _$AiPlatformCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'baseUrl') String baseUrl,@JsonKey(name: 'apiKey') String apiKey,@JsonKey(name: 'models') List<String> models,@JsonKey(name: 'selectedModel') String selectedModel,@JsonKey(name: 'enable') bool enable
});




}
/// @nodoc
class _$AiPlatformCopyWithImpl<$Res>
    implements $AiPlatformCopyWith<$Res> {
  _$AiPlatformCopyWithImpl(this._self, this._then);

  final AiPlatform _self;
  final $Res Function(AiPlatform) _then;

/// Create a copy of AiPlatform
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? baseUrl = null,Object? apiKey = null,Object? models = null,Object? selectedModel = null,Object? enable = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<String>,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiPlatform].
extension AiPlatformPatterns on AiPlatform {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiPlatform value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiPlatform() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiPlatform value)  $default,){
final _that = this;
switch (_that) {
case _AiPlatform():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiPlatform value)?  $default,){
final _that = this;
switch (_that) {
case _AiPlatform() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'baseUrl')  String baseUrl, @JsonKey(name: 'apiKey')  String apiKey, @JsonKey(name: 'models')  List<String> models, @JsonKey(name: 'selectedModel')  String selectedModel, @JsonKey(name: 'enable')  bool enable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiPlatform() when $default != null:
return $default(_that.name,_that.baseUrl,_that.apiKey,_that.models,_that.selectedModel,_that.enable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'baseUrl')  String baseUrl, @JsonKey(name: 'apiKey')  String apiKey, @JsonKey(name: 'models')  List<String> models, @JsonKey(name: 'selectedModel')  String selectedModel, @JsonKey(name: 'enable')  bool enable)  $default,) {final _that = this;
switch (_that) {
case _AiPlatform():
return $default(_that.name,_that.baseUrl,_that.apiKey,_that.models,_that.selectedModel,_that.enable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'baseUrl')  String baseUrl, @JsonKey(name: 'apiKey')  String apiKey, @JsonKey(name: 'models')  List<String> models, @JsonKey(name: 'selectedModel')  String selectedModel, @JsonKey(name: 'enable')  bool enable)?  $default,) {final _that = this;
switch (_that) {
case _AiPlatform() when $default != null:
return $default(_that.name,_that.baseUrl,_that.apiKey,_that.models,_that.selectedModel,_that.enable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiPlatform implements AiPlatform {
  const _AiPlatform({@JsonKey(name: 'name') this.name = '', @JsonKey(name: 'baseUrl') this.baseUrl = '', @JsonKey(name: 'apiKey') this.apiKey = '', @JsonKey(name: 'models') final  List<String> models = const [], @JsonKey(name: 'selectedModel') this.selectedModel = '', @JsonKey(name: 'enable') this.enable = false}): _models = models;
  factory _AiPlatform.fromJson(Map<String, dynamic> json) => _$AiPlatformFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'baseUrl') final  String baseUrl;
@override@JsonKey(name: 'apiKey') final  String apiKey;
/// 该平台可用的模型列表（内置默认值 + API 刷新）
 final  List<String> _models;
/// 该平台可用的模型列表（内置默认值 + API 刷新）
@override@JsonKey(name: 'models') List<String> get models {
  if (_models is EqualUnmodifiableListView) return _models;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_models);
}

/// 当前选中的模型
@override@JsonKey(name: 'selectedModel') final  String selectedModel;
/// 是否启用该平台
@override@JsonKey(name: 'enable') final  bool enable;

/// Create a copy of AiPlatform
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiPlatformCopyWith<_AiPlatform> get copyWith => __$AiPlatformCopyWithImpl<_AiPlatform>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiPlatformToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiPlatform&&(identical(other.name, name) || other.name == name)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&const DeepCollectionEquality().equals(other._models, _models)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&(identical(other.enable, enable) || other.enable == enable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,baseUrl,apiKey,const DeepCollectionEquality().hash(_models),selectedModel,enable);

@override
String toString() {
  return 'AiPlatform(name: $name, baseUrl: $baseUrl, apiKey: $apiKey, models: $models, selectedModel: $selectedModel, enable: $enable)';
}


}

/// @nodoc
abstract mixin class _$AiPlatformCopyWith<$Res> implements $AiPlatformCopyWith<$Res> {
  factory _$AiPlatformCopyWith(_AiPlatform value, $Res Function(_AiPlatform) _then) = __$AiPlatformCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'baseUrl') String baseUrl,@JsonKey(name: 'apiKey') String apiKey,@JsonKey(name: 'models') List<String> models,@JsonKey(name: 'selectedModel') String selectedModel,@JsonKey(name: 'enable') bool enable
});




}
/// @nodoc
class __$AiPlatformCopyWithImpl<$Res>
    implements _$AiPlatformCopyWith<$Res> {
  __$AiPlatformCopyWithImpl(this._self, this._then);

  final _AiPlatform _self;
  final $Res Function(_AiPlatform) _then;

/// Create a copy of AiPlatform
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? baseUrl = null,Object? apiKey = null,Object? models = null,Object? selectedModel = null,Object? enable = null,}) {
  return _then(_AiPlatform(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<String>,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,enable: null == enable ? _self.enable : enable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ReplyStyle {

@JsonKey(name: 'id') int get id;@JsonKey(name: 'name') String get name;/// System Prompt，用于风格编辑功能
@JsonKey(name: 'prompt') String get prompt;/// 是否是用户自定义风格
@JsonKey(name: 'isCustomization') bool get isCustomization;
/// Create a copy of ReplyStyle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyStyleCopyWith<ReplyStyle> get copyWith => _$ReplyStyleCopyWithImpl<ReplyStyle>(this as ReplyStyle, _$identity);

  /// Serializes this ReplyStyle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyStyle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.isCustomization, isCustomization) || other.isCustomization == isCustomization));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,prompt,isCustomization);

@override
String toString() {
  return 'ReplyStyle(id: $id, name: $name, prompt: $prompt, isCustomization: $isCustomization)';
}


}

/// @nodoc
abstract mixin class $ReplyStyleCopyWith<$Res>  {
  factory $ReplyStyleCopyWith(ReplyStyle value, $Res Function(ReplyStyle) _then) = _$ReplyStyleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'name') String name,@JsonKey(name: 'prompt') String prompt,@JsonKey(name: 'isCustomization') bool isCustomization
});




}
/// @nodoc
class _$ReplyStyleCopyWithImpl<$Res>
    implements $ReplyStyleCopyWith<$Res> {
  _$ReplyStyleCopyWithImpl(this._self, this._then);

  final ReplyStyle _self;
  final $Res Function(ReplyStyle) _then;

/// Create a copy of ReplyStyle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? prompt = null,Object? isCustomization = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,isCustomization: null == isCustomization ? _self.isCustomization : isCustomization // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplyStyle].
extension ReplyStylePatterns on ReplyStyle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyStyle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyStyle() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyStyle value)  $default,){
final _that = this;
switch (_that) {
case _ReplyStyle():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyStyle value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyStyle() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'prompt')  String prompt, @JsonKey(name: 'isCustomization')  bool isCustomization)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyStyle() when $default != null:
return $default(_that.id,_that.name,_that.prompt,_that.isCustomization);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'prompt')  String prompt, @JsonKey(name: 'isCustomization')  bool isCustomization)  $default,) {final _that = this;
switch (_that) {
case _ReplyStyle():
return $default(_that.id,_that.name,_that.prompt,_that.isCustomization);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'prompt')  String prompt, @JsonKey(name: 'isCustomization')  bool isCustomization)?  $default,) {final _that = this;
switch (_that) {
case _ReplyStyle() when $default != null:
return $default(_that.id,_that.name,_that.prompt,_that.isCustomization);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplyStyle implements ReplyStyle {
  const _ReplyStyle({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') this.name = '', @JsonKey(name: 'prompt') this.prompt = '', @JsonKey(name: 'isCustomization') this.isCustomization = false});
  factory _ReplyStyle.fromJson(Map<String, dynamic> json) => _$ReplyStyleFromJson(json);

@override@JsonKey(name: 'id') final  int id;
@override@JsonKey(name: 'name') final  String name;
/// System Prompt，用于风格编辑功能
@override@JsonKey(name: 'prompt') final  String prompt;
/// 是否是用户自定义风格
@override@JsonKey(name: 'isCustomization') final  bool isCustomization;

/// Create a copy of ReplyStyle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyStyleCopyWith<_ReplyStyle> get copyWith => __$ReplyStyleCopyWithImpl<_ReplyStyle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplyStyleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyStyle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.isCustomization, isCustomization) || other.isCustomization == isCustomization));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,prompt,isCustomization);

@override
String toString() {
  return 'ReplyStyle(id: $id, name: $name, prompt: $prompt, isCustomization: $isCustomization)';
}


}

/// @nodoc
abstract mixin class _$ReplyStyleCopyWith<$Res> implements $ReplyStyleCopyWith<$Res> {
  factory _$ReplyStyleCopyWith(_ReplyStyle value, $Res Function(_ReplyStyle) _then) = __$ReplyStyleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int id,@JsonKey(name: 'name') String name,@JsonKey(name: 'prompt') String prompt,@JsonKey(name: 'isCustomization') bool isCustomization
});




}
/// @nodoc
class __$ReplyStyleCopyWithImpl<$Res>
    implements _$ReplyStyleCopyWith<$Res> {
  __$ReplyStyleCopyWithImpl(this._self, this._then);

  final _ReplyStyle _self;
  final $Res Function(_ReplyStyle) _then;

/// Create a copy of ReplyStyle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? prompt = null,Object? isCustomization = null,}) {
  return _then(_ReplyStyle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,isCustomization: null == isCustomization ? _self.isCustomization : isCustomization // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AppPreference {

@JsonKey(name: 'key') String get key;@JsonKey(name: 'name') String get name;@JsonKey(name: 'desc') String get desc;/// 开关状态，非空，默认关闭
@JsonKey(name: 'isOpen') bool get isOpen;
/// Create a copy of AppPreference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPreferenceCopyWith<AppPreference> get copyWith => _$AppPreferenceCopyWithImpl<AppPreference>(this as AppPreference, _$identity);

  /// Serializes this AppPreference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPreference&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,desc,isOpen);

@override
String toString() {
  return 'AppPreference(key: $key, name: $name, desc: $desc, isOpen: $isOpen)';
}


}

/// @nodoc
abstract mixin class $AppPreferenceCopyWith<$Res>  {
  factory $AppPreferenceCopyWith(AppPreference value, $Res Function(AppPreference) _then) = _$AppPreferenceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'key') String key,@JsonKey(name: 'name') String name,@JsonKey(name: 'desc') String desc,@JsonKey(name: 'isOpen') bool isOpen
});




}
/// @nodoc
class _$AppPreferenceCopyWithImpl<$Res>
    implements $AppPreferenceCopyWith<$Res> {
  _$AppPreferenceCopyWithImpl(this._self, this._then);

  final AppPreference _self;
  final $Res Function(AppPreference) _then;

/// Create a copy of AppPreference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? desc = null,Object? isOpen = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppPreference].
extension AppPreferencePatterns on AppPreference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppPreference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppPreference() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppPreference value)  $default,){
final _that = this;
switch (_that) {
case _AppPreference():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppPreference value)?  $default,){
final _that = this;
switch (_that) {
case _AppPreference() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'name')  String name, @JsonKey(name: 'desc')  String desc, @JsonKey(name: 'isOpen')  bool isOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppPreference() when $default != null:
return $default(_that.key,_that.name,_that.desc,_that.isOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'name')  String name, @JsonKey(name: 'desc')  String desc, @JsonKey(name: 'isOpen')  bool isOpen)  $default,) {final _that = this;
switch (_that) {
case _AppPreference():
return $default(_that.key,_that.name,_that.desc,_that.isOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'name')  String name, @JsonKey(name: 'desc')  String desc, @JsonKey(name: 'isOpen')  bool isOpen)?  $default,) {final _that = this;
switch (_that) {
case _AppPreference() when $default != null:
return $default(_that.key,_that.name,_that.desc,_that.isOpen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppPreference implements AppPreference {
  const _AppPreference({@JsonKey(name: 'key') this.key = '', @JsonKey(name: 'name') this.name = '', @JsonKey(name: 'desc') this.desc = '', @JsonKey(name: 'isOpen') this.isOpen = false});
  factory _AppPreference.fromJson(Map<String, dynamic> json) => _$AppPreferenceFromJson(json);

@override@JsonKey(name: 'key') final  String key;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'desc') final  String desc;
/// 开关状态，非空，默认关闭
@override@JsonKey(name: 'isOpen') final  bool isOpen;

/// Create a copy of AppPreference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPreferenceCopyWith<_AppPreference> get copyWith => __$AppPreferenceCopyWithImpl<_AppPreference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppPreferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPreference&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.isOpen, isOpen) || other.isOpen == isOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,desc,isOpen);

@override
String toString() {
  return 'AppPreference(key: $key, name: $name, desc: $desc, isOpen: $isOpen)';
}


}

/// @nodoc
abstract mixin class _$AppPreferenceCopyWith<$Res> implements $AppPreferenceCopyWith<$Res> {
  factory _$AppPreferenceCopyWith(_AppPreference value, $Res Function(_AppPreference) _then) = __$AppPreferenceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'key') String key,@JsonKey(name: 'name') String name,@JsonKey(name: 'desc') String desc,@JsonKey(name: 'isOpen') bool isOpen
});




}
/// @nodoc
class __$AppPreferenceCopyWithImpl<$Res>
    implements _$AppPreferenceCopyWith<$Res> {
  __$AppPreferenceCopyWithImpl(this._self, this._then);

  final _AppPreference _self;
  final $Res Function(_AppPreference) _then;

/// Create a copy of AppPreference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? desc = null,Object? isOpen = null,}) {
  return _then(_AppPreference(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,isOpen: null == isOpen ? _self.isOpen : isOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
