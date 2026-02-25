// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carbon_time_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarbonTimeSeries {

 DateTime get period;@JsonKey(name: 'average_co2') double get averageCo2;
/// Create a copy of CarbonTimeSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarbonTimeSeriesCopyWith<CarbonTimeSeries> get copyWith => _$CarbonTimeSeriesCopyWithImpl<CarbonTimeSeries>(this as CarbonTimeSeries, _$identity);

  /// Serializes this CarbonTimeSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarbonTimeSeries&&(identical(other.period, period) || other.period == period)&&(identical(other.averageCo2, averageCo2) || other.averageCo2 == averageCo2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,averageCo2);

@override
String toString() {
  return 'CarbonTimeSeries(period: $period, averageCo2: $averageCo2)';
}


}

/// @nodoc
abstract mixin class $CarbonTimeSeriesCopyWith<$Res>  {
  factory $CarbonTimeSeriesCopyWith(CarbonTimeSeries value, $Res Function(CarbonTimeSeries) _then) = _$CarbonTimeSeriesCopyWithImpl;
@useResult
$Res call({
 DateTime period,@JsonKey(name: 'average_co2') double averageCo2
});




}
/// @nodoc
class _$CarbonTimeSeriesCopyWithImpl<$Res>
    implements $CarbonTimeSeriesCopyWith<$Res> {
  _$CarbonTimeSeriesCopyWithImpl(this._self, this._then);

  final CarbonTimeSeries _self;
  final $Res Function(CarbonTimeSeries) _then;

/// Create a copy of CarbonTimeSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? averageCo2 = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DateTime,averageCo2: null == averageCo2 ? _self.averageCo2 : averageCo2 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CarbonTimeSeries].
extension CarbonTimeSeriesPatterns on CarbonTimeSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarbonTimeSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarbonTimeSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarbonTimeSeries value)  $default,){
final _that = this;
switch (_that) {
case _CarbonTimeSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarbonTimeSeries value)?  $default,){
final _that = this;
switch (_that) {
case _CarbonTimeSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime period, @JsonKey(name: 'average_co2')  double averageCo2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarbonTimeSeries() when $default != null:
return $default(_that.period,_that.averageCo2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime period, @JsonKey(name: 'average_co2')  double averageCo2)  $default,) {final _that = this;
switch (_that) {
case _CarbonTimeSeries():
return $default(_that.period,_that.averageCo2);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime period, @JsonKey(name: 'average_co2')  double averageCo2)?  $default,) {final _that = this;
switch (_that) {
case _CarbonTimeSeries() when $default != null:
return $default(_that.period,_that.averageCo2);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarbonTimeSeries implements CarbonTimeSeries {
  const _CarbonTimeSeries({required this.period, @JsonKey(name: 'average_co2') required this.averageCo2});
  factory _CarbonTimeSeries.fromJson(Map<String, dynamic> json) => _$CarbonTimeSeriesFromJson(json);

@override final  DateTime period;
@override@JsonKey(name: 'average_co2') final  double averageCo2;

/// Create a copy of CarbonTimeSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarbonTimeSeriesCopyWith<_CarbonTimeSeries> get copyWith => __$CarbonTimeSeriesCopyWithImpl<_CarbonTimeSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarbonTimeSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarbonTimeSeries&&(identical(other.period, period) || other.period == period)&&(identical(other.averageCo2, averageCo2) || other.averageCo2 == averageCo2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,averageCo2);

@override
String toString() {
  return 'CarbonTimeSeries(period: $period, averageCo2: $averageCo2)';
}


}

/// @nodoc
abstract mixin class _$CarbonTimeSeriesCopyWith<$Res> implements $CarbonTimeSeriesCopyWith<$Res> {
  factory _$CarbonTimeSeriesCopyWith(_CarbonTimeSeries value, $Res Function(_CarbonTimeSeries) _then) = __$CarbonTimeSeriesCopyWithImpl;
@override @useResult
$Res call({
 DateTime period,@JsonKey(name: 'average_co2') double averageCo2
});




}
/// @nodoc
class __$CarbonTimeSeriesCopyWithImpl<$Res>
    implements _$CarbonTimeSeriesCopyWith<$Res> {
  __$CarbonTimeSeriesCopyWithImpl(this._self, this._then);

  final _CarbonTimeSeries _self;
  final $Res Function(_CarbonTimeSeries) _then;

/// Create a copy of CarbonTimeSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? averageCo2 = null,}) {
  return _then(_CarbonTimeSeries(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DateTime,averageCo2: null == averageCo2 ? _self.averageCo2 : averageCo2 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
