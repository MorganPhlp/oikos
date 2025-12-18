// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categorie_empreinte_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategorieEmpreinteEntity {

 String get nom; String get icone; String get couleurHEX; String get description;
/// Create a copy of CategorieEmpreinteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorieEmpreinteEntityCopyWith<CategorieEmpreinteEntity> get copyWith => _$CategorieEmpreinteEntityCopyWithImpl<CategorieEmpreinteEntity>(this as CategorieEmpreinteEntity, _$identity);

  /// Serializes this CategorieEmpreinteEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorieEmpreinteEntity&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.icone, icone) || other.icone == icone)&&(identical(other.couleurHEX, couleurHEX) || other.couleurHEX == couleurHEX)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nom,icone,couleurHEX,description);

@override
String toString() {
  return 'CategorieEmpreinteEntity(nom: $nom, icone: $icone, couleurHEX: $couleurHEX, description: $description)';
}


}

/// @nodoc
abstract mixin class $CategorieEmpreinteEntityCopyWith<$Res>  {
  factory $CategorieEmpreinteEntityCopyWith(CategorieEmpreinteEntity value, $Res Function(CategorieEmpreinteEntity) _then) = _$CategorieEmpreinteEntityCopyWithImpl;
@useResult
$Res call({
 String nom, String icone, String couleurHEX, String description
});




}
/// @nodoc
class _$CategorieEmpreinteEntityCopyWithImpl<$Res>
    implements $CategorieEmpreinteEntityCopyWith<$Res> {
  _$CategorieEmpreinteEntityCopyWithImpl(this._self, this._then);

  final CategorieEmpreinteEntity _self;
  final $Res Function(CategorieEmpreinteEntity) _then;

/// Create a copy of CategorieEmpreinteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nom = null,Object? icone = null,Object? couleurHEX = null,Object? description = null,}) {
  return _then(_self.copyWith(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,icone: null == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String,couleurHEX: null == couleurHEX ? _self.couleurHEX : couleurHEX // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategorieEmpreinteEntity].
extension CategorieEmpreinteEntityPatterns on CategorieEmpreinteEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorieEmpreinteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorieEmpreinteEntity value)  $default,){
final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorieEmpreinteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nom,  String icone,  String couleurHEX,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity() when $default != null:
return $default(_that.nom,_that.icone,_that.couleurHEX,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nom,  String icone,  String couleurHEX,  String description)  $default,) {final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity():
return $default(_that.nom,_that.icone,_that.couleurHEX,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nom,  String icone,  String couleurHEX,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CategorieEmpreinteEntity() when $default != null:
return $default(_that.nom,_that.icone,_that.couleurHEX,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategorieEmpreinteEntity extends CategorieEmpreinteEntity {
  const _CategorieEmpreinteEntity({this.nom = '', this.icone = '', this.couleurHEX = '', this.description = ''}): super._();
  factory _CategorieEmpreinteEntity.fromJson(Map<String, dynamic> json) => _$CategorieEmpreinteEntityFromJson(json);

@override@JsonKey() final  String nom;
@override@JsonKey() final  String icone;
@override@JsonKey() final  String couleurHEX;
@override@JsonKey() final  String description;

/// Create a copy of CategorieEmpreinteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorieEmpreinteEntityCopyWith<_CategorieEmpreinteEntity> get copyWith => __$CategorieEmpreinteEntityCopyWithImpl<_CategorieEmpreinteEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategorieEmpreinteEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorieEmpreinteEntity&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.icone, icone) || other.icone == icone)&&(identical(other.couleurHEX, couleurHEX) || other.couleurHEX == couleurHEX)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nom,icone,couleurHEX,description);

@override
String toString() {
  return 'CategorieEmpreinteEntity(nom: $nom, icone: $icone, couleurHEX: $couleurHEX, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CategorieEmpreinteEntityCopyWith<$Res> implements $CategorieEmpreinteEntityCopyWith<$Res> {
  factory _$CategorieEmpreinteEntityCopyWith(_CategorieEmpreinteEntity value, $Res Function(_CategorieEmpreinteEntity) _then) = __$CategorieEmpreinteEntityCopyWithImpl;
@override @useResult
$Res call({
 String nom, String icone, String couleurHEX, String description
});




}
/// @nodoc
class __$CategorieEmpreinteEntityCopyWithImpl<$Res>
    implements _$CategorieEmpreinteEntityCopyWith<$Res> {
  __$CategorieEmpreinteEntityCopyWithImpl(this._self, this._then);

  final _CategorieEmpreinteEntity _self;
  final $Res Function(_CategorieEmpreinteEntity) _then;

/// Create a copy of CategorieEmpreinteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nom = null,Object? icone = null,Object? couleurHEX = null,Object? description = null,}) {
  return _then(_CategorieEmpreinteEntity(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,icone: null == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String,couleurHEX: null == couleurHEX ? _self.couleurHEX : couleurHEX // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
