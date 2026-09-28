// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retention_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetentionRateKPI {

@JsonKey(name: 'j7') num get j7;@JsonKey(name: 'j7_objective') num get j7Objective;@JsonKey(name: 'j30') num get j30;@JsonKey(name: 'j30_objective') num get j30Objective;@JsonKey(name: 'current_retention_rate') num get currentRetentionRate;
/// Create a copy of RetentionRateKPI
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetentionRateKPICopyWith<RetentionRateKPI> get copyWith => _$RetentionRateKPICopyWithImpl<RetentionRateKPI>(this as RetentionRateKPI, _$identity);

  /// Serializes this RetentionRateKPI to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetentionRateKPI&&(identical(other.j7, j7) || other.j7 == j7)&&(identical(other.j7Objective, j7Objective) || other.j7Objective == j7Objective)&&(identical(other.j30, j30) || other.j30 == j30)&&(identical(other.j30Objective, j30Objective) || other.j30Objective == j30Objective)&&(identical(other.currentRetentionRate, currentRetentionRate) || other.currentRetentionRate == currentRetentionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,j7,j7Objective,j30,j30Objective,currentRetentionRate);

@override
String toString() {
  return 'RetentionRateKPI(j7: $j7, j7Objective: $j7Objective, j30: $j30, j30Objective: $j30Objective, currentRetentionRate: $currentRetentionRate)';
}


}

/// @nodoc
abstract mixin class $RetentionRateKPICopyWith<$Res>  {
  factory $RetentionRateKPICopyWith(RetentionRateKPI value, $Res Function(RetentionRateKPI) _then) = _$RetentionRateKPICopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'j7') num j7,@JsonKey(name: 'j7_objective') num j7Objective,@JsonKey(name: 'j30') num j30,@JsonKey(name: 'j30_objective') num j30Objective,@JsonKey(name: 'current_retention_rate') num currentRetentionRate
});




}
/// @nodoc
class _$RetentionRateKPICopyWithImpl<$Res>
    implements $RetentionRateKPICopyWith<$Res> {
  _$RetentionRateKPICopyWithImpl(this._self, this._then);

  final RetentionRateKPI _self;
  final $Res Function(RetentionRateKPI) _then;

/// Create a copy of RetentionRateKPI
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? j7 = null,Object? j7Objective = null,Object? j30 = null,Object? j30Objective = null,Object? currentRetentionRate = null,}) {
  return _then(_self.copyWith(
j7: null == j7 ? _self.j7 : j7 // ignore: cast_nullable_to_non_nullable
as num,j7Objective: null == j7Objective ? _self.j7Objective : j7Objective // ignore: cast_nullable_to_non_nullable
as num,j30: null == j30 ? _self.j30 : j30 // ignore: cast_nullable_to_non_nullable
as num,j30Objective: null == j30Objective ? _self.j30Objective : j30Objective // ignore: cast_nullable_to_non_nullable
as num,currentRetentionRate: null == currentRetentionRate ? _self.currentRetentionRate : currentRetentionRate // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [RetentionRateKPI].
extension RetentionRateKPIPatterns on RetentionRateKPI {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RetentionRateKPI value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RetentionRateKPI() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RetentionRateKPI value)  $default,){
final _that = this;
switch (_that) {
case _RetentionRateKPI():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RetentionRateKPI value)?  $default,){
final _that = this;
switch (_that) {
case _RetentionRateKPI() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'j7')  num j7, @JsonKey(name: 'j7_objective')  num j7Objective, @JsonKey(name: 'j30')  num j30, @JsonKey(name: 'j30_objective')  num j30Objective, @JsonKey(name: 'current_retention_rate')  num currentRetentionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RetentionRateKPI() when $default != null:
return $default(_that.j7,_that.j7Objective,_that.j30,_that.j30Objective,_that.currentRetentionRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'j7')  num j7, @JsonKey(name: 'j7_objective')  num j7Objective, @JsonKey(name: 'j30')  num j30, @JsonKey(name: 'j30_objective')  num j30Objective, @JsonKey(name: 'current_retention_rate')  num currentRetentionRate)  $default,) {final _that = this;
switch (_that) {
case _RetentionRateKPI():
return $default(_that.j7,_that.j7Objective,_that.j30,_that.j30Objective,_that.currentRetentionRate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'j7')  num j7, @JsonKey(name: 'j7_objective')  num j7Objective, @JsonKey(name: 'j30')  num j30, @JsonKey(name: 'j30_objective')  num j30Objective, @JsonKey(name: 'current_retention_rate')  num currentRetentionRate)?  $default,) {final _that = this;
switch (_that) {
case _RetentionRateKPI() when $default != null:
return $default(_that.j7,_that.j7Objective,_that.j30,_that.j30Objective,_that.currentRetentionRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RetentionRateKPI implements RetentionRateKPI {
  const _RetentionRateKPI({@JsonKey(name: 'j7') required this.j7, @JsonKey(name: 'j7_objective') required this.j7Objective, @JsonKey(name: 'j30') required this.j30, @JsonKey(name: 'j30_objective') required this.j30Objective, @JsonKey(name: 'current_retention_rate') required this.currentRetentionRate});
  factory _RetentionRateKPI.fromJson(Map<String, dynamic> json) => _$RetentionRateKPIFromJson(json);

@override@JsonKey(name: 'j7') final  num j7;
@override@JsonKey(name: 'j7_objective') final  num j7Objective;
@override@JsonKey(name: 'j30') final  num j30;
@override@JsonKey(name: 'j30_objective') final  num j30Objective;
@override@JsonKey(name: 'current_retention_rate') final  num currentRetentionRate;

/// Create a copy of RetentionRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetentionRateKPICopyWith<_RetentionRateKPI> get copyWith => __$RetentionRateKPICopyWithImpl<_RetentionRateKPI>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RetentionRateKPIToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetentionRateKPI&&(identical(other.j7, j7) || other.j7 == j7)&&(identical(other.j7Objective, j7Objective) || other.j7Objective == j7Objective)&&(identical(other.j30, j30) || other.j30 == j30)&&(identical(other.j30Objective, j30Objective) || other.j30Objective == j30Objective)&&(identical(other.currentRetentionRate, currentRetentionRate) || other.currentRetentionRate == currentRetentionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,j7,j7Objective,j30,j30Objective,currentRetentionRate);

@override
String toString() {
  return 'RetentionRateKPI(j7: $j7, j7Objective: $j7Objective, j30: $j30, j30Objective: $j30Objective, currentRetentionRate: $currentRetentionRate)';
}


}

/// @nodoc
abstract mixin class _$RetentionRateKPICopyWith<$Res> implements $RetentionRateKPICopyWith<$Res> {
  factory _$RetentionRateKPICopyWith(_RetentionRateKPI value, $Res Function(_RetentionRateKPI) _then) = __$RetentionRateKPICopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'j7') num j7,@JsonKey(name: 'j7_objective') num j7Objective,@JsonKey(name: 'j30') num j30,@JsonKey(name: 'j30_objective') num j30Objective,@JsonKey(name: 'current_retention_rate') num currentRetentionRate
});




}
/// @nodoc
class __$RetentionRateKPICopyWithImpl<$Res>
    implements _$RetentionRateKPICopyWith<$Res> {
  __$RetentionRateKPICopyWithImpl(this._self, this._then);

  final _RetentionRateKPI _self;
  final $Res Function(_RetentionRateKPI) _then;

/// Create a copy of RetentionRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? j7 = null,Object? j7Objective = null,Object? j30 = null,Object? j30Objective = null,Object? currentRetentionRate = null,}) {
  return _then(_RetentionRateKPI(
j7: null == j7 ? _self.j7 : j7 // ignore: cast_nullable_to_non_nullable
as num,j7Objective: null == j7Objective ? _self.j7Objective : j7Objective // ignore: cast_nullable_to_non_nullable
as num,j30: null == j30 ? _self.j30 : j30 // ignore: cast_nullable_to_non_nullable
as num,j30Objective: null == j30Objective ? _self.j30Objective : j30Objective // ignore: cast_nullable_to_non_nullable
as num,currentRetentionRate: null == currentRetentionRate ? _self.currentRetentionRate : currentRetentionRate // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
