// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'objectif_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ObjectifEntity {

 double get valeur; String get label; String get description; List<int> get colors;
/// Create a copy of ObjectifEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectifEntityCopyWith<ObjectifEntity> get copyWith => _$ObjectifEntityCopyWithImpl<ObjectifEntity>(this as ObjectifEntity, _$identity);

  /// Serializes this ObjectifEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectifEntity&&(identical(other.valeur, valeur) || other.valeur == valeur)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.colors, colors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valeur,label,description,const DeepCollectionEquality().hash(colors));

@override
String toString() {
  return 'ObjectifEntity(valeur: $valeur, label: $label, description: $description, colors: $colors)';
}


}

/// @nodoc
abstract mixin class $ObjectifEntityCopyWith<$Res>  {
  factory $ObjectifEntityCopyWith(ObjectifEntity value, $Res Function(ObjectifEntity) _then) = _$ObjectifEntityCopyWithImpl;
@useResult
$Res call({
 double valeur, String label, String description, List<int> colors
});




}
/// @nodoc
class _$ObjectifEntityCopyWithImpl<$Res>
    implements $ObjectifEntityCopyWith<$Res> {
  _$ObjectifEntityCopyWithImpl(this._self, this._then);

  final ObjectifEntity _self;
  final $Res Function(ObjectifEntity) _then;

/// Create a copy of ObjectifEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? valeur = null,Object? label = null,Object? description = null,Object? colors = null,}) {
  return _then(_self.copyWith(
valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectifEntity].
extension ObjectifEntityPatterns on ObjectifEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectifEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectifEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectifEntity value)  $default,){
final _that = this;
switch (_that) {
case _ObjectifEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectifEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectifEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double valeur,  String label,  String description,  List<int> colors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectifEntity() when $default != null:
return $default(_that.valeur,_that.label,_that.description,_that.colors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double valeur,  String label,  String description,  List<int> colors)  $default,) {final _that = this;
switch (_that) {
case _ObjectifEntity():
return $default(_that.valeur,_that.label,_that.description,_that.colors);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double valeur,  String label,  String description,  List<int> colors)?  $default,) {final _that = this;
switch (_that) {
case _ObjectifEntity() when $default != null:
return $default(_that.valeur,_that.label,_that.description,_that.colors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ObjectifEntity implements ObjectifEntity {
  const _ObjectifEntity({required this.valeur, required this.label, required this.description, required final  List<int> colors}): _colors = colors;
  factory _ObjectifEntity.fromJson(Map<String, dynamic> json) => _$ObjectifEntityFromJson(json);

@override final  double valeur;
@override final  String label;
@override final  String description;
 final  List<int> _colors;
@override List<int> get colors {
  if (_colors is EqualUnmodifiableListView) return _colors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colors);
}


/// Create a copy of ObjectifEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectifEntityCopyWith<_ObjectifEntity> get copyWith => __$ObjectifEntityCopyWithImpl<_ObjectifEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectifEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectifEntity&&(identical(other.valeur, valeur) || other.valeur == valeur)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._colors, _colors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,valeur,label,description,const DeepCollectionEquality().hash(_colors));

@override
String toString() {
  return 'ObjectifEntity(valeur: $valeur, label: $label, description: $description, colors: $colors)';
}


}

/// @nodoc
abstract mixin class _$ObjectifEntityCopyWith<$Res> implements $ObjectifEntityCopyWith<$Res> {
  factory _$ObjectifEntityCopyWith(_ObjectifEntity value, $Res Function(_ObjectifEntity) _then) = __$ObjectifEntityCopyWithImpl;
@override @useResult
$Res call({
 double valeur, String label, String description, List<int> colors
});




}
/// @nodoc
class __$ObjectifEntityCopyWithImpl<$Res>
    implements _$ObjectifEntityCopyWith<$Res> {
  __$ObjectifEntityCopyWithImpl(this._self, this._then);

  final _ObjectifEntity _self;
  final $Res Function(_ObjectifEntity) _then;

/// Create a copy of ObjectifEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? valeur = null,Object? label = null,Object? description = null,Object? colors = null,}) {
  return _then(_ObjectifEntity(
valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,colors: null == colors ? _self._colors : colors // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
