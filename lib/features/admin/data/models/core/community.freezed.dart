// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Community {

 String get code;@JsonKey(name: 'nom') String get name;@JsonKey(name: 'entreprise_id') String get companyId; String get description;@JsonKey(name: 'nombre_membres') int? get membersCount;@JsonKey(name: 'bilan_moyen') double? get avgScore;@JsonKey(name: 'logo_url') String? get logoUrl;@JsonKey(name: 'couleurhex') String? get colorHex;
/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCopyWith<Community> get copyWith => _$CommunityCopyWithImpl<Community>(this as Community, _$identity);

  /// Serializes this Community to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Community&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.description, description) || other.description == description)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,companyId,description,membersCount,avgScore,logoUrl,colorHex);

@override
String toString() {
  return 'Community(code: $code, name: $name, companyId: $companyId, description: $description, membersCount: $membersCount, avgScore: $avgScore, logoUrl: $logoUrl, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class $CommunityCopyWith<$Res>  {
  factory $CommunityCopyWith(Community value, $Res Function(Community) _then) = _$CommunityCopyWithImpl;
@useResult
$Res call({
 String code,@JsonKey(name: 'nom') String name,@JsonKey(name: 'entreprise_id') String companyId, String description,@JsonKey(name: 'nombre_membres') int? membersCount,@JsonKey(name: 'bilan_moyen') double? avgScore,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'couleurhex') String? colorHex
});




}
/// @nodoc
class _$CommunityCopyWithImpl<$Res>
    implements $CommunityCopyWith<$Res> {
  _$CommunityCopyWithImpl(this._self, this._then);

  final Community _self;
  final $Res Function(Community) _then;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? companyId = null,Object? description = null,Object? membersCount = freezed,Object? avgScore = freezed,Object? logoUrl = freezed,Object? colorHex = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Community].
extension CommunityPatterns on Community {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Community value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Community() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Community value)  $default,){
final _that = this;
switch (_that) {
case _Community():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Community value)?  $default,){
final _that = this;
switch (_that) {
case _Community() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'nom')  String name, @JsonKey(name: 'entreprise_id')  String companyId,  String description, @JsonKey(name: 'nombre_membres')  int? membersCount, @JsonKey(name: 'bilan_moyen')  double? avgScore, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'couleurhex')  String? colorHex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Community() when $default != null:
return $default(_that.code,_that.name,_that.companyId,_that.description,_that.membersCount,_that.avgScore,_that.logoUrl,_that.colorHex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'nom')  String name, @JsonKey(name: 'entreprise_id')  String companyId,  String description, @JsonKey(name: 'nombre_membres')  int? membersCount, @JsonKey(name: 'bilan_moyen')  double? avgScore, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'couleurhex')  String? colorHex)  $default,) {final _that = this;
switch (_that) {
case _Community():
return $default(_that.code,_that.name,_that.companyId,_that.description,_that.membersCount,_that.avgScore,_that.logoUrl,_that.colorHex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code, @JsonKey(name: 'nom')  String name, @JsonKey(name: 'entreprise_id')  String companyId,  String description, @JsonKey(name: 'nombre_membres')  int? membersCount, @JsonKey(name: 'bilan_moyen')  double? avgScore, @JsonKey(name: 'logo_url')  String? logoUrl, @JsonKey(name: 'couleurhex')  String? colorHex)?  $default,) {final _that = this;
switch (_that) {
case _Community() when $default != null:
return $default(_that.code,_that.name,_that.companyId,_that.description,_that.membersCount,_that.avgScore,_that.logoUrl,_that.colorHex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Community implements Community {
  const _Community({required this.code, @JsonKey(name: 'nom') required this.name, @JsonKey(name: 'entreprise_id') required this.companyId, required this.description, @JsonKey(name: 'nombre_membres') this.membersCount = 0, @JsonKey(name: 'bilan_moyen') this.avgScore = 0, @JsonKey(name: 'logo_url') this.logoUrl, @JsonKey(name: 'couleurhex') this.colorHex});
  factory _Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);

@override final  String code;
@override@JsonKey(name: 'nom') final  String name;
@override@JsonKey(name: 'entreprise_id') final  String companyId;
@override final  String description;
@override@JsonKey(name: 'nombre_membres') final  int? membersCount;
@override@JsonKey(name: 'bilan_moyen') final  double? avgScore;
@override@JsonKey(name: 'logo_url') final  String? logoUrl;
@override@JsonKey(name: 'couleurhex') final  String? colorHex;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCopyWith<_Community> get copyWith => __$CommunityCopyWithImpl<_Community>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Community&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.description, description) || other.description == description)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,companyId,description,membersCount,avgScore,logoUrl,colorHex);

@override
String toString() {
  return 'Community(code: $code, name: $name, companyId: $companyId, description: $description, membersCount: $membersCount, avgScore: $avgScore, logoUrl: $logoUrl, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$CommunityCopyWith<$Res> implements $CommunityCopyWith<$Res> {
  factory _$CommunityCopyWith(_Community value, $Res Function(_Community) _then) = __$CommunityCopyWithImpl;
@override @useResult
$Res call({
 String code,@JsonKey(name: 'nom') String name,@JsonKey(name: 'entreprise_id') String companyId, String description,@JsonKey(name: 'nombre_membres') int? membersCount,@JsonKey(name: 'bilan_moyen') double? avgScore,@JsonKey(name: 'logo_url') String? logoUrl,@JsonKey(name: 'couleurhex') String? colorHex
});




}
/// @nodoc
class __$CommunityCopyWithImpl<$Res>
    implements _$CommunityCopyWith<$Res> {
  __$CommunityCopyWithImpl(this._self, this._then);

  final _Community _self;
  final $Res Function(_Community) _then;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? companyId = null,Object? description = null,Object? membersCount = freezed,Object? avgScore = freezed,Object? logoUrl = freezed,Object? colorHex = freezed,}) {
  return _then(_Community(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
