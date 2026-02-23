// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenges_accepted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChallengesAcceptedKPI {

@JsonKey(name: 'nb_defis_releve') num get nbChallenges;@JsonKey(name: 'nb_defis_objectif') num get nbChallengesObjective;
/// Create a copy of ChallengesAcceptedKPI
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengesAcceptedKPICopyWith<ChallengesAcceptedKPI> get copyWith => _$ChallengesAcceptedKPICopyWithImpl<ChallengesAcceptedKPI>(this as ChallengesAcceptedKPI, _$identity);

  /// Serializes this ChallengesAcceptedKPI to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengesAcceptedKPI&&(identical(other.nbChallenges, nbChallenges) || other.nbChallenges == nbChallenges)&&(identical(other.nbChallengesObjective, nbChallengesObjective) || other.nbChallengesObjective == nbChallengesObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nbChallenges,nbChallengesObjective);

@override
String toString() {
  return 'ChallengesAcceptedKPI(nbChallenges: $nbChallenges, nbChallengesObjective: $nbChallengesObjective)';
}


}

/// @nodoc
abstract mixin class $ChallengesAcceptedKPICopyWith<$Res>  {
  factory $ChallengesAcceptedKPICopyWith(ChallengesAcceptedKPI value, $Res Function(ChallengesAcceptedKPI) _then) = _$ChallengesAcceptedKPICopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nb_defis_releve') num nbChallenges,@JsonKey(name: 'nb_defis_objectif') num nbChallengesObjective
});




}
/// @nodoc
class _$ChallengesAcceptedKPICopyWithImpl<$Res>
    implements $ChallengesAcceptedKPICopyWith<$Res> {
  _$ChallengesAcceptedKPICopyWithImpl(this._self, this._then);

  final ChallengesAcceptedKPI _self;
  final $Res Function(ChallengesAcceptedKPI) _then;

/// Create a copy of ChallengesAcceptedKPI
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nbChallenges = null,Object? nbChallengesObjective = null,}) {
  return _then(_self.copyWith(
nbChallenges: null == nbChallenges ? _self.nbChallenges : nbChallenges // ignore: cast_nullable_to_non_nullable
as num,nbChallengesObjective: null == nbChallengesObjective ? _self.nbChallengesObjective : nbChallengesObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengesAcceptedKPI].
extension ChallengesAcceptedKPIPatterns on ChallengesAcceptedKPI {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengesAcceptedKPI value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengesAcceptedKPI value)  $default,){
final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengesAcceptedKPI value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nb_defis_releve')  num nbChallenges, @JsonKey(name: 'nb_defis_objectif')  num nbChallengesObjective)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI() when $default != null:
return $default(_that.nbChallenges,_that.nbChallengesObjective);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nb_defis_releve')  num nbChallenges, @JsonKey(name: 'nb_defis_objectif')  num nbChallengesObjective)  $default,) {final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI():
return $default(_that.nbChallenges,_that.nbChallengesObjective);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nb_defis_releve')  num nbChallenges, @JsonKey(name: 'nb_defis_objectif')  num nbChallengesObjective)?  $default,) {final _that = this;
switch (_that) {
case _ChallengesAcceptedKPI() when $default != null:
return $default(_that.nbChallenges,_that.nbChallengesObjective);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengesAcceptedKPI implements ChallengesAcceptedKPI {
  const _ChallengesAcceptedKPI({@JsonKey(name: 'nb_defis_releve') required this.nbChallenges, @JsonKey(name: 'nb_defis_objectif') required this.nbChallengesObjective});
  factory _ChallengesAcceptedKPI.fromJson(Map<String, dynamic> json) => _$ChallengesAcceptedKPIFromJson(json);

@override@JsonKey(name: 'nb_defis_releve') final  num nbChallenges;
@override@JsonKey(name: 'nb_defis_objectif') final  num nbChallengesObjective;

/// Create a copy of ChallengesAcceptedKPI
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengesAcceptedKPICopyWith<_ChallengesAcceptedKPI> get copyWith => __$ChallengesAcceptedKPICopyWithImpl<_ChallengesAcceptedKPI>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengesAcceptedKPIToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengesAcceptedKPI&&(identical(other.nbChallenges, nbChallenges) || other.nbChallenges == nbChallenges)&&(identical(other.nbChallengesObjective, nbChallengesObjective) || other.nbChallengesObjective == nbChallengesObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nbChallenges,nbChallengesObjective);

@override
String toString() {
  return 'ChallengesAcceptedKPI(nbChallenges: $nbChallenges, nbChallengesObjective: $nbChallengesObjective)';
}


}

/// @nodoc
abstract mixin class _$ChallengesAcceptedKPICopyWith<$Res> implements $ChallengesAcceptedKPICopyWith<$Res> {
  factory _$ChallengesAcceptedKPICopyWith(_ChallengesAcceptedKPI value, $Res Function(_ChallengesAcceptedKPI) _then) = __$ChallengesAcceptedKPICopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nb_defis_releve') num nbChallenges,@JsonKey(name: 'nb_defis_objectif') num nbChallengesObjective
});




}
/// @nodoc
class __$ChallengesAcceptedKPICopyWithImpl<$Res>
    implements _$ChallengesAcceptedKPICopyWith<$Res> {
  __$ChallengesAcceptedKPICopyWithImpl(this._self, this._then);

  final _ChallengesAcceptedKPI _self;
  final $Res Function(_ChallengesAcceptedKPI) _then;

/// Create a copy of ChallengesAcceptedKPI
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nbChallenges = null,Object? nbChallengesObjective = null,}) {
  return _then(_ChallengesAcceptedKPI(
nbChallenges: null == nbChallenges ? _self.nbChallenges : nbChallenges // ignore: cast_nullable_to_non_nullable
as num,nbChallengesObjective: null == nbChallengesObjective ? _self.nbChallengesObjective : nbChallengesObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
