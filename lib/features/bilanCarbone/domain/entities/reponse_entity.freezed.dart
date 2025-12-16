// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reponse_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReponseUtilisateurEntity {

@JsonKey(includeIfNull: false) int? get id;@JsonKey(name: 'bilan_id') int get bilanId;@JsonKey(name: 'question_id') int get questionId; dynamic get valeur;
/// Create a copy of ReponseUtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReponseUtilisateurEntityCopyWith<ReponseUtilisateurEntity> get copyWith => _$ReponseUtilisateurEntityCopyWithImpl<ReponseUtilisateurEntity>(this as ReponseUtilisateurEntity, _$identity);

  /// Serializes this ReponseUtilisateurEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReponseUtilisateurEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bilanId, bilanId) || other.bilanId == bilanId)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&const DeepCollectionEquality().equals(other.valeur, valeur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bilanId,questionId,const DeepCollectionEquality().hash(valeur));

@override
String toString() {
  return 'ReponseUtilisateurEntity(id: $id, bilanId: $bilanId, questionId: $questionId, valeur: $valeur)';
}


}

/// @nodoc
abstract mixin class $ReponseUtilisateurEntityCopyWith<$Res>  {
  factory $ReponseUtilisateurEntityCopyWith(ReponseUtilisateurEntity value, $Res Function(ReponseUtilisateurEntity) _then) = _$ReponseUtilisateurEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) int? id,@JsonKey(name: 'bilan_id') int bilanId,@JsonKey(name: 'question_id') int questionId, dynamic valeur
});




}
/// @nodoc
class _$ReponseUtilisateurEntityCopyWithImpl<$Res>
    implements $ReponseUtilisateurEntityCopyWith<$Res> {
  _$ReponseUtilisateurEntityCopyWithImpl(this._self, this._then);

  final ReponseUtilisateurEntity _self;
  final $Res Function(ReponseUtilisateurEntity) _then;

/// Create a copy of ReponseUtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? bilanId = null,Object? questionId = null,Object? valeur = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bilanId: null == bilanId ? _self.bilanId : bilanId // ignore: cast_nullable_to_non_nullable
as int,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,valeur: freezed == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [ReponseUtilisateurEntity].
extension ReponseUtilisateurEntityPatterns on ReponseUtilisateurEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReponseUtilisateurEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReponseUtilisateurEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReponseUtilisateurEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  int? id, @JsonKey(name: 'bilan_id')  int bilanId, @JsonKey(name: 'question_id')  int questionId,  dynamic valeur)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity() when $default != null:
return $default(_that.id,_that.bilanId,_that.questionId,_that.valeur);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  int? id, @JsonKey(name: 'bilan_id')  int bilanId, @JsonKey(name: 'question_id')  int questionId,  dynamic valeur)  $default,) {final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity():
return $default(_that.id,_that.bilanId,_that.questionId,_that.valeur);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  int? id, @JsonKey(name: 'bilan_id')  int bilanId, @JsonKey(name: 'question_id')  int questionId,  dynamic valeur)?  $default,) {final _that = this;
switch (_that) {
case _ReponseUtilisateurEntity() when $default != null:
return $default(_that.id,_that.bilanId,_that.questionId,_that.valeur);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReponseUtilisateurEntity extends ReponseUtilisateurEntity {
  const _ReponseUtilisateurEntity({@JsonKey(includeIfNull: false) this.id, @JsonKey(name: 'bilan_id') this.bilanId = 0, @JsonKey(name: 'question_id') this.questionId = 0, this.valeur}): super._();
  factory _ReponseUtilisateurEntity.fromJson(Map<String, dynamic> json) => _$ReponseUtilisateurEntityFromJson(json);

@override@JsonKey(includeIfNull: false) final  int? id;
@override@JsonKey(name: 'bilan_id') final  int bilanId;
@override@JsonKey(name: 'question_id') final  int questionId;
@override final  dynamic valeur;

/// Create a copy of ReponseUtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReponseUtilisateurEntityCopyWith<_ReponseUtilisateurEntity> get copyWith => __$ReponseUtilisateurEntityCopyWithImpl<_ReponseUtilisateurEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReponseUtilisateurEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReponseUtilisateurEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bilanId, bilanId) || other.bilanId == bilanId)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&const DeepCollectionEquality().equals(other.valeur, valeur));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bilanId,questionId,const DeepCollectionEquality().hash(valeur));

@override
String toString() {
  return 'ReponseUtilisateurEntity(id: $id, bilanId: $bilanId, questionId: $questionId, valeur: $valeur)';
}


}

/// @nodoc
abstract mixin class _$ReponseUtilisateurEntityCopyWith<$Res> implements $ReponseUtilisateurEntityCopyWith<$Res> {
  factory _$ReponseUtilisateurEntityCopyWith(_ReponseUtilisateurEntity value, $Res Function(_ReponseUtilisateurEntity) _then) = __$ReponseUtilisateurEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) int? id,@JsonKey(name: 'bilan_id') int bilanId,@JsonKey(name: 'question_id') int questionId, dynamic valeur
});




}
/// @nodoc
class __$ReponseUtilisateurEntityCopyWithImpl<$Res>
    implements _$ReponseUtilisateurEntityCopyWith<$Res> {
  __$ReponseUtilisateurEntityCopyWithImpl(this._self, this._then);

  final _ReponseUtilisateurEntity _self;
  final $Res Function(_ReponseUtilisateurEntity) _then;

/// Create a copy of ReponseUtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? bilanId = null,Object? questionId = null,Object? valeur = freezed,}) {
  return _then(_ReponseUtilisateurEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,bilanId: null == bilanId ? _self.bilanId : bilanId // ignore: cast_nullable_to_non_nullable
as int,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as int,valeur: freezed == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
