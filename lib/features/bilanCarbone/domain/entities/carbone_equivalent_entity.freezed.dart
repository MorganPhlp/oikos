// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carbone_equivalent_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarboneEquivalentEntity {

 int get id;@JsonKey(name: 'equivalent_label') String get equivalentLabel;@JsonKey(name: 'valeur_1_tonne') double get valeur1Tonne;
/// Create a copy of CarboneEquivalentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarboneEquivalentEntityCopyWith<CarboneEquivalentEntity> get copyWith => _$CarboneEquivalentEntityCopyWithImpl<CarboneEquivalentEntity>(this as CarboneEquivalentEntity, _$identity);

  /// Serializes this CarboneEquivalentEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarboneEquivalentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.equivalentLabel, equivalentLabel) || other.equivalentLabel == equivalentLabel)&&(identical(other.valeur1Tonne, valeur1Tonne) || other.valeur1Tonne == valeur1Tonne));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,equivalentLabel,valeur1Tonne);

@override
String toString() {
  return 'CarboneEquivalentEntity(id: $id, equivalentLabel: $equivalentLabel, valeur1Tonne: $valeur1Tonne)';
}


}

/// @nodoc
abstract mixin class $CarboneEquivalentEntityCopyWith<$Res>  {
  factory $CarboneEquivalentEntityCopyWith(CarboneEquivalentEntity value, $Res Function(CarboneEquivalentEntity) _then) = _$CarboneEquivalentEntityCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'equivalent_label') String equivalentLabel,@JsonKey(name: 'valeur_1_tonne') double valeur1Tonne
});




}
/// @nodoc
class _$CarboneEquivalentEntityCopyWithImpl<$Res>
    implements $CarboneEquivalentEntityCopyWith<$Res> {
  _$CarboneEquivalentEntityCopyWithImpl(this._self, this._then);

  final CarboneEquivalentEntity _self;
  final $Res Function(CarboneEquivalentEntity) _then;

/// Create a copy of CarboneEquivalentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? equivalentLabel = null,Object? valeur1Tonne = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,equivalentLabel: null == equivalentLabel ? _self.equivalentLabel : equivalentLabel // ignore: cast_nullable_to_non_nullable
as String,valeur1Tonne: null == valeur1Tonne ? _self.valeur1Tonne : valeur1Tonne // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CarboneEquivalentEntity].
extension CarboneEquivalentEntityPatterns on CarboneEquivalentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarboneEquivalentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarboneEquivalentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarboneEquivalentEntity value)  $default,){
final _that = this;
switch (_that) {
case _CarboneEquivalentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarboneEquivalentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CarboneEquivalentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'equivalent_label')  String equivalentLabel, @JsonKey(name: 'valeur_1_tonne')  double valeur1Tonne)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarboneEquivalentEntity() when $default != null:
return $default(_that.id,_that.equivalentLabel,_that.valeur1Tonne);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'equivalent_label')  String equivalentLabel, @JsonKey(name: 'valeur_1_tonne')  double valeur1Tonne)  $default,) {final _that = this;
switch (_that) {
case _CarboneEquivalentEntity():
return $default(_that.id,_that.equivalentLabel,_that.valeur1Tonne);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'equivalent_label')  String equivalentLabel, @JsonKey(name: 'valeur_1_tonne')  double valeur1Tonne)?  $default,) {final _that = this;
switch (_that) {
case _CarboneEquivalentEntity() when $default != null:
return $default(_that.id,_that.equivalentLabel,_that.valeur1Tonne);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarboneEquivalentEntity implements CarboneEquivalentEntity {
  const _CarboneEquivalentEntity({this.id = 0, @JsonKey(name: 'equivalent_label') this.equivalentLabel = '', @JsonKey(name: 'valeur_1_tonne') this.valeur1Tonne = 0.0});
  factory _CarboneEquivalentEntity.fromJson(Map<String, dynamic> json) => _$CarboneEquivalentEntityFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey(name: 'equivalent_label') final  String equivalentLabel;
@override@JsonKey(name: 'valeur_1_tonne') final  double valeur1Tonne;

/// Create a copy of CarboneEquivalentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarboneEquivalentEntityCopyWith<_CarboneEquivalentEntity> get copyWith => __$CarboneEquivalentEntityCopyWithImpl<_CarboneEquivalentEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarboneEquivalentEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarboneEquivalentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.equivalentLabel, equivalentLabel) || other.equivalentLabel == equivalentLabel)&&(identical(other.valeur1Tonne, valeur1Tonne) || other.valeur1Tonne == valeur1Tonne));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,equivalentLabel,valeur1Tonne);

@override
String toString() {
  return 'CarboneEquivalentEntity(id: $id, equivalentLabel: $equivalentLabel, valeur1Tonne: $valeur1Tonne)';
}


}

/// @nodoc
abstract mixin class _$CarboneEquivalentEntityCopyWith<$Res> implements $CarboneEquivalentEntityCopyWith<$Res> {
  factory _$CarboneEquivalentEntityCopyWith(_CarboneEquivalentEntity value, $Res Function(_CarboneEquivalentEntity) _then) = __$CarboneEquivalentEntityCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'equivalent_label') String equivalentLabel,@JsonKey(name: 'valeur_1_tonne') double valeur1Tonne
});




}
/// @nodoc
class __$CarboneEquivalentEntityCopyWithImpl<$Res>
    implements _$CarboneEquivalentEntityCopyWith<$Res> {
  __$CarboneEquivalentEntityCopyWithImpl(this._self, this._then);

  final _CarboneEquivalentEntity _self;
  final $Res Function(_CarboneEquivalentEntity) _then;

/// Create a copy of CarboneEquivalentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? equivalentLabel = null,Object? valeur1Tonne = null,}) {
  return _then(_CarboneEquivalentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,equivalentLabel: null == equivalentLabel ? _self.equivalentLabel : equivalentLabel // ignore: cast_nullable_to_non_nullable
as String,valeur1Tonne: null == valeur1Tonne ? _self.valeur1Tonne : valeur1Tonne // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
