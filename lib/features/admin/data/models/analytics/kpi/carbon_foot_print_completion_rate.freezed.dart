// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carbon_foot_print_completion_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarbonFootPrintCompletionRateKPI {

@JsonKey(name: 'completion_bilan_carbone_minimale') num get carbonFootPrintMinimalCompletionRate;@JsonKey(name: 'completion_bilan_carbone_detaille') num get carbonFootPrintDetailledCompletionRate;@JsonKey(name: 'objectif_completion_bilan_carbone_minimale') num get carbonFootPrintMinimalCompletionRateObjective;@JsonKey(name: 'objectif_completion_bilan_carbone_detaille') num get carbonFootPrintDetailledCompletionRateObjective;
/// Create a copy of CarbonFootPrintCompletionRateKPI
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarbonFootPrintCompletionRateKPICopyWith<CarbonFootPrintCompletionRateKPI> get copyWith => _$CarbonFootPrintCompletionRateKPICopyWithImpl<CarbonFootPrintCompletionRateKPI>(this as CarbonFootPrintCompletionRateKPI, _$identity);

  /// Serializes this CarbonFootPrintCompletionRateKPI to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarbonFootPrintCompletionRateKPI&&(identical(other.carbonFootPrintMinimalCompletionRate, carbonFootPrintMinimalCompletionRate) || other.carbonFootPrintMinimalCompletionRate == carbonFootPrintMinimalCompletionRate)&&(identical(other.carbonFootPrintDetailledCompletionRate, carbonFootPrintDetailledCompletionRate) || other.carbonFootPrintDetailledCompletionRate == carbonFootPrintDetailledCompletionRate)&&(identical(other.carbonFootPrintMinimalCompletionRateObjective, carbonFootPrintMinimalCompletionRateObjective) || other.carbonFootPrintMinimalCompletionRateObjective == carbonFootPrintMinimalCompletionRateObjective)&&(identical(other.carbonFootPrintDetailledCompletionRateObjective, carbonFootPrintDetailledCompletionRateObjective) || other.carbonFootPrintDetailledCompletionRateObjective == carbonFootPrintDetailledCompletionRateObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,carbonFootPrintMinimalCompletionRate,carbonFootPrintDetailledCompletionRate,carbonFootPrintMinimalCompletionRateObjective,carbonFootPrintDetailledCompletionRateObjective);

@override
String toString() {
  return 'CarbonFootPrintCompletionRateKPI(carbonFootPrintMinimalCompletionRate: $carbonFootPrintMinimalCompletionRate, carbonFootPrintDetailledCompletionRate: $carbonFootPrintDetailledCompletionRate, carbonFootPrintMinimalCompletionRateObjective: $carbonFootPrintMinimalCompletionRateObjective, carbonFootPrintDetailledCompletionRateObjective: $carbonFootPrintDetailledCompletionRateObjective)';
}


}

/// @nodoc
abstract mixin class $CarbonFootPrintCompletionRateKPICopyWith<$Res>  {
  factory $CarbonFootPrintCompletionRateKPICopyWith(CarbonFootPrintCompletionRateKPI value, $Res Function(CarbonFootPrintCompletionRateKPI) _then) = _$CarbonFootPrintCompletionRateKPICopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'completion_bilan_carbone_minimale') num carbonFootPrintMinimalCompletionRate,@JsonKey(name: 'completion_bilan_carbone_detaille') num carbonFootPrintDetailledCompletionRate,@JsonKey(name: 'objectif_completion_bilan_carbone_minimale') num carbonFootPrintMinimalCompletionRateObjective,@JsonKey(name: 'objectif_completion_bilan_carbone_detaille') num carbonFootPrintDetailledCompletionRateObjective
});




}
/// @nodoc
class _$CarbonFootPrintCompletionRateKPICopyWithImpl<$Res>
    implements $CarbonFootPrintCompletionRateKPICopyWith<$Res> {
  _$CarbonFootPrintCompletionRateKPICopyWithImpl(this._self, this._then);

  final CarbonFootPrintCompletionRateKPI _self;
  final $Res Function(CarbonFootPrintCompletionRateKPI) _then;

/// Create a copy of CarbonFootPrintCompletionRateKPI
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? carbonFootPrintMinimalCompletionRate = null,Object? carbonFootPrintDetailledCompletionRate = null,Object? carbonFootPrintMinimalCompletionRateObjective = null,Object? carbonFootPrintDetailledCompletionRateObjective = null,}) {
  return _then(_self.copyWith(
carbonFootPrintMinimalCompletionRate: null == carbonFootPrintMinimalCompletionRate ? _self.carbonFootPrintMinimalCompletionRate : carbonFootPrintMinimalCompletionRate // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintDetailledCompletionRate: null == carbonFootPrintDetailledCompletionRate ? _self.carbonFootPrintDetailledCompletionRate : carbonFootPrintDetailledCompletionRate // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintMinimalCompletionRateObjective: null == carbonFootPrintMinimalCompletionRateObjective ? _self.carbonFootPrintMinimalCompletionRateObjective : carbonFootPrintMinimalCompletionRateObjective // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintDetailledCompletionRateObjective: null == carbonFootPrintDetailledCompletionRateObjective ? _self.carbonFootPrintDetailledCompletionRateObjective : carbonFootPrintDetailledCompletionRateObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [CarbonFootPrintCompletionRateKPI].
extension CarbonFootPrintCompletionRateKPIPatterns on CarbonFootPrintCompletionRateKPI {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarbonFootPrintCompletionRateKPI value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarbonFootPrintCompletionRateKPI value)  $default,){
final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarbonFootPrintCompletionRateKPI value)?  $default,){
final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRate, @JsonKey(name: 'completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRate, @JsonKey(name: 'objectif_completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRateObjective, @JsonKey(name: 'objectif_completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRateObjective)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI() when $default != null:
return $default(_that.carbonFootPrintMinimalCompletionRate,_that.carbonFootPrintDetailledCompletionRate,_that.carbonFootPrintMinimalCompletionRateObjective,_that.carbonFootPrintDetailledCompletionRateObjective);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRate, @JsonKey(name: 'completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRate, @JsonKey(name: 'objectif_completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRateObjective, @JsonKey(name: 'objectif_completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRateObjective)  $default,) {final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI():
return $default(_that.carbonFootPrintMinimalCompletionRate,_that.carbonFootPrintDetailledCompletionRate,_that.carbonFootPrintMinimalCompletionRateObjective,_that.carbonFootPrintDetailledCompletionRateObjective);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRate, @JsonKey(name: 'completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRate, @JsonKey(name: 'objectif_completion_bilan_carbone_minimale')  num carbonFootPrintMinimalCompletionRateObjective, @JsonKey(name: 'objectif_completion_bilan_carbone_detaille')  num carbonFootPrintDetailledCompletionRateObjective)?  $default,) {final _that = this;
switch (_that) {
case _CarbonFootPrintCompletionRateKPI() when $default != null:
return $default(_that.carbonFootPrintMinimalCompletionRate,_that.carbonFootPrintDetailledCompletionRate,_that.carbonFootPrintMinimalCompletionRateObjective,_that.carbonFootPrintDetailledCompletionRateObjective);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarbonFootPrintCompletionRateKPI implements CarbonFootPrintCompletionRateKPI {
  const _CarbonFootPrintCompletionRateKPI({@JsonKey(name: 'completion_bilan_carbone_minimale') required this.carbonFootPrintMinimalCompletionRate, @JsonKey(name: 'completion_bilan_carbone_detaille') required this.carbonFootPrintDetailledCompletionRate, @JsonKey(name: 'objectif_completion_bilan_carbone_minimale') required this.carbonFootPrintMinimalCompletionRateObjective, @JsonKey(name: 'objectif_completion_bilan_carbone_detaille') required this.carbonFootPrintDetailledCompletionRateObjective});
  factory _CarbonFootPrintCompletionRateKPI.fromJson(Map<String, dynamic> json) => _$CarbonFootPrintCompletionRateKPIFromJson(json);

@override@JsonKey(name: 'completion_bilan_carbone_minimale') final  num carbonFootPrintMinimalCompletionRate;
@override@JsonKey(name: 'completion_bilan_carbone_detaille') final  num carbonFootPrintDetailledCompletionRate;
@override@JsonKey(name: 'objectif_completion_bilan_carbone_minimale') final  num carbonFootPrintMinimalCompletionRateObjective;
@override@JsonKey(name: 'objectif_completion_bilan_carbone_detaille') final  num carbonFootPrintDetailledCompletionRateObjective;

/// Create a copy of CarbonFootPrintCompletionRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarbonFootPrintCompletionRateKPICopyWith<_CarbonFootPrintCompletionRateKPI> get copyWith => __$CarbonFootPrintCompletionRateKPICopyWithImpl<_CarbonFootPrintCompletionRateKPI>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarbonFootPrintCompletionRateKPIToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarbonFootPrintCompletionRateKPI&&(identical(other.carbonFootPrintMinimalCompletionRate, carbonFootPrintMinimalCompletionRate) || other.carbonFootPrintMinimalCompletionRate == carbonFootPrintMinimalCompletionRate)&&(identical(other.carbonFootPrintDetailledCompletionRate, carbonFootPrintDetailledCompletionRate) || other.carbonFootPrintDetailledCompletionRate == carbonFootPrintDetailledCompletionRate)&&(identical(other.carbonFootPrintMinimalCompletionRateObjective, carbonFootPrintMinimalCompletionRateObjective) || other.carbonFootPrintMinimalCompletionRateObjective == carbonFootPrintMinimalCompletionRateObjective)&&(identical(other.carbonFootPrintDetailledCompletionRateObjective, carbonFootPrintDetailledCompletionRateObjective) || other.carbonFootPrintDetailledCompletionRateObjective == carbonFootPrintDetailledCompletionRateObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,carbonFootPrintMinimalCompletionRate,carbonFootPrintDetailledCompletionRate,carbonFootPrintMinimalCompletionRateObjective,carbonFootPrintDetailledCompletionRateObjective);

@override
String toString() {
  return 'CarbonFootPrintCompletionRateKPI(carbonFootPrintMinimalCompletionRate: $carbonFootPrintMinimalCompletionRate, carbonFootPrintDetailledCompletionRate: $carbonFootPrintDetailledCompletionRate, carbonFootPrintMinimalCompletionRateObjective: $carbonFootPrintMinimalCompletionRateObjective, carbonFootPrintDetailledCompletionRateObjective: $carbonFootPrintDetailledCompletionRateObjective)';
}


}

/// @nodoc
abstract mixin class _$CarbonFootPrintCompletionRateKPICopyWith<$Res> implements $CarbonFootPrintCompletionRateKPICopyWith<$Res> {
  factory _$CarbonFootPrintCompletionRateKPICopyWith(_CarbonFootPrintCompletionRateKPI value, $Res Function(_CarbonFootPrintCompletionRateKPI) _then) = __$CarbonFootPrintCompletionRateKPICopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'completion_bilan_carbone_minimale') num carbonFootPrintMinimalCompletionRate,@JsonKey(name: 'completion_bilan_carbone_detaille') num carbonFootPrintDetailledCompletionRate,@JsonKey(name: 'objectif_completion_bilan_carbone_minimale') num carbonFootPrintMinimalCompletionRateObjective,@JsonKey(name: 'objectif_completion_bilan_carbone_detaille') num carbonFootPrintDetailledCompletionRateObjective
});




}
/// @nodoc
class __$CarbonFootPrintCompletionRateKPICopyWithImpl<$Res>
    implements _$CarbonFootPrintCompletionRateKPICopyWith<$Res> {
  __$CarbonFootPrintCompletionRateKPICopyWithImpl(this._self, this._then);

  final _CarbonFootPrintCompletionRateKPI _self;
  final $Res Function(_CarbonFootPrintCompletionRateKPI) _then;

/// Create a copy of CarbonFootPrintCompletionRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? carbonFootPrintMinimalCompletionRate = null,Object? carbonFootPrintDetailledCompletionRate = null,Object? carbonFootPrintMinimalCompletionRateObjective = null,Object? carbonFootPrintDetailledCompletionRateObjective = null,}) {
  return _then(_CarbonFootPrintCompletionRateKPI(
carbonFootPrintMinimalCompletionRate: null == carbonFootPrintMinimalCompletionRate ? _self.carbonFootPrintMinimalCompletionRate : carbonFootPrintMinimalCompletionRate // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintDetailledCompletionRate: null == carbonFootPrintDetailledCompletionRate ? _self.carbonFootPrintDetailledCompletionRate : carbonFootPrintDetailledCompletionRate // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintMinimalCompletionRateObjective: null == carbonFootPrintMinimalCompletionRateObjective ? _self.carbonFootPrintMinimalCompletionRateObjective : carbonFootPrintMinimalCompletionRateObjective // ignore: cast_nullable_to_non_nullable
as num,carbonFootPrintDetailledCompletionRateObjective: null == carbonFootPrintDetailledCompletionRateObjective ? _self.carbonFootPrintDetailledCompletionRateObjective : carbonFootPrintDetailledCompletionRateObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
