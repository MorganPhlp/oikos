// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_use_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyUseRateKPI {

@JsonKey(name: 'taux_utilisation_jour') num get dailyUseRate;@JsonKey(name: 'objectif_taux_utilisation_jour') num get dailyUseRateObjective;
/// Create a copy of DailyUseRateKPI
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyUseRateKPICopyWith<DailyUseRateKPI> get copyWith => _$DailyUseRateKPICopyWithImpl<DailyUseRateKPI>(this as DailyUseRateKPI, _$identity);

  /// Serializes this DailyUseRateKPI to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyUseRateKPI&&(identical(other.dailyUseRate, dailyUseRate) || other.dailyUseRate == dailyUseRate)&&(identical(other.dailyUseRateObjective, dailyUseRateObjective) || other.dailyUseRateObjective == dailyUseRateObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyUseRate,dailyUseRateObjective);

@override
String toString() {
  return 'DailyUseRateKPI(dailyUseRate: $dailyUseRate, dailyUseRateObjective: $dailyUseRateObjective)';
}


}

/// @nodoc
abstract mixin class $DailyUseRateKPICopyWith<$Res>  {
  factory $DailyUseRateKPICopyWith(DailyUseRateKPI value, $Res Function(DailyUseRateKPI) _then) = _$DailyUseRateKPICopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'taux_utilisation_jour') num dailyUseRate,@JsonKey(name: 'objectif_taux_utilisation_jour') num dailyUseRateObjective
});




}
/// @nodoc
class _$DailyUseRateKPICopyWithImpl<$Res>
    implements $DailyUseRateKPICopyWith<$Res> {
  _$DailyUseRateKPICopyWithImpl(this._self, this._then);

  final DailyUseRateKPI _self;
  final $Res Function(DailyUseRateKPI) _then;

/// Create a copy of DailyUseRateKPI
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyUseRate = null,Object? dailyUseRateObjective = null,}) {
  return _then(_self.copyWith(
dailyUseRate: null == dailyUseRate ? _self.dailyUseRate : dailyUseRate // ignore: cast_nullable_to_non_nullable
as num,dailyUseRateObjective: null == dailyUseRateObjective ? _self.dailyUseRateObjective : dailyUseRateObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyUseRateKPI].
extension DailyUseRateKPIPatterns on DailyUseRateKPI {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyUseRateKPI value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyUseRateKPI() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyUseRateKPI value)  $default,){
final _that = this;
switch (_that) {
case _DailyUseRateKPI():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyUseRateKPI value)?  $default,){
final _that = this;
switch (_that) {
case _DailyUseRateKPI() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'taux_utilisation_jour')  num dailyUseRate, @JsonKey(name: 'objectif_taux_utilisation_jour')  num dailyUseRateObjective)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyUseRateKPI() when $default != null:
return $default(_that.dailyUseRate,_that.dailyUseRateObjective);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'taux_utilisation_jour')  num dailyUseRate, @JsonKey(name: 'objectif_taux_utilisation_jour')  num dailyUseRateObjective)  $default,) {final _that = this;
switch (_that) {
case _DailyUseRateKPI():
return $default(_that.dailyUseRate,_that.dailyUseRateObjective);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'taux_utilisation_jour')  num dailyUseRate, @JsonKey(name: 'objectif_taux_utilisation_jour')  num dailyUseRateObjective)?  $default,) {final _that = this;
switch (_that) {
case _DailyUseRateKPI() when $default != null:
return $default(_that.dailyUseRate,_that.dailyUseRateObjective);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyUseRateKPI implements DailyUseRateKPI {
  const _DailyUseRateKPI({@JsonKey(name: 'taux_utilisation_jour') required this.dailyUseRate, @JsonKey(name: 'objectif_taux_utilisation_jour') required this.dailyUseRateObjective});
  factory _DailyUseRateKPI.fromJson(Map<String, dynamic> json) => _$DailyUseRateKPIFromJson(json);

@override@JsonKey(name: 'taux_utilisation_jour') final  num dailyUseRate;
@override@JsonKey(name: 'objectif_taux_utilisation_jour') final  num dailyUseRateObjective;

/// Create a copy of DailyUseRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyUseRateKPICopyWith<_DailyUseRateKPI> get copyWith => __$DailyUseRateKPICopyWithImpl<_DailyUseRateKPI>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyUseRateKPIToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyUseRateKPI&&(identical(other.dailyUseRate, dailyUseRate) || other.dailyUseRate == dailyUseRate)&&(identical(other.dailyUseRateObjective, dailyUseRateObjective) || other.dailyUseRateObjective == dailyUseRateObjective));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyUseRate,dailyUseRateObjective);

@override
String toString() {
  return 'DailyUseRateKPI(dailyUseRate: $dailyUseRate, dailyUseRateObjective: $dailyUseRateObjective)';
}


}

/// @nodoc
abstract mixin class _$DailyUseRateKPICopyWith<$Res> implements $DailyUseRateKPICopyWith<$Res> {
  factory _$DailyUseRateKPICopyWith(_DailyUseRateKPI value, $Res Function(_DailyUseRateKPI) _then) = __$DailyUseRateKPICopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'taux_utilisation_jour') num dailyUseRate,@JsonKey(name: 'objectif_taux_utilisation_jour') num dailyUseRateObjective
});




}
/// @nodoc
class __$DailyUseRateKPICopyWithImpl<$Res>
    implements _$DailyUseRateKPICopyWith<$Res> {
  __$DailyUseRateKPICopyWithImpl(this._self, this._then);

  final _DailyUseRateKPI _self;
  final $Res Function(_DailyUseRateKPI) _then;

/// Create a copy of DailyUseRateKPI
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyUseRate = null,Object? dailyUseRateObjective = null,}) {
  return _then(_DailyUseRateKPI(
dailyUseRate: null == dailyUseRate ? _self.dailyUseRate : dailyUseRate // ignore: cast_nullable_to_non_nullable
as num,dailyUseRateObjective: null == dailyUseRateObjective ? _self.dailyUseRateObjective : dailyUseRateObjective // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
