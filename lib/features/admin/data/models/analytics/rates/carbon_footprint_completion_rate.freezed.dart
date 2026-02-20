// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carbon_footprint_completion_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarbonFootprintCompletionRate {

@JsonKey(name: 'completion_percentage') double get completionPourcentage;@JsonKey(name: 'total_utilisateurs') int get totalUsers;@JsonKey(name: 'utilisateurs_bilan_termine') int get usersWithCompletedBilan;
/// Create a copy of CarbonFootprintCompletionRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarbonFootprintCompletionRateCopyWith<CarbonFootprintCompletionRate> get copyWith => _$CarbonFootprintCompletionRateCopyWithImpl<CarbonFootprintCompletionRate>(this as CarbonFootprintCompletionRate, _$identity);

  /// Serializes this CarbonFootprintCompletionRate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarbonFootprintCompletionRate&&(identical(other.completionPourcentage, completionPourcentage) || other.completionPourcentage == completionPourcentage)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.usersWithCompletedBilan, usersWithCompletedBilan) || other.usersWithCompletedBilan == usersWithCompletedBilan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completionPourcentage,totalUsers,usersWithCompletedBilan);

@override
String toString() {
  return 'CarbonFootprintCompletionRate(completionPourcentage: $completionPourcentage, totalUsers: $totalUsers, usersWithCompletedBilan: $usersWithCompletedBilan)';
}


}

/// @nodoc
abstract mixin class $CarbonFootprintCompletionRateCopyWith<$Res>  {
  factory $CarbonFootprintCompletionRateCopyWith(CarbonFootprintCompletionRate value, $Res Function(CarbonFootprintCompletionRate) _then) = _$CarbonFootprintCompletionRateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'completion_percentage') double completionPourcentage,@JsonKey(name: 'total_utilisateurs') int totalUsers,@JsonKey(name: 'utilisateurs_bilan_termine') int usersWithCompletedBilan
});




}
/// @nodoc
class _$CarbonFootprintCompletionRateCopyWithImpl<$Res>
    implements $CarbonFootprintCompletionRateCopyWith<$Res> {
  _$CarbonFootprintCompletionRateCopyWithImpl(this._self, this._then);

  final CarbonFootprintCompletionRate _self;
  final $Res Function(CarbonFootprintCompletionRate) _then;

/// Create a copy of CarbonFootprintCompletionRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completionPourcentage = null,Object? totalUsers = null,Object? usersWithCompletedBilan = null,}) {
  return _then(_self.copyWith(
completionPourcentage: null == completionPourcentage ? _self.completionPourcentage : completionPourcentage // ignore: cast_nullable_to_non_nullable
as double,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,usersWithCompletedBilan: null == usersWithCompletedBilan ? _self.usersWithCompletedBilan : usersWithCompletedBilan // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CarbonFootprintCompletionRate].
extension CarbonFootprintCompletionRatePatterns on CarbonFootprintCompletionRate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarbonFootprintCompletionRate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarbonFootprintCompletionRate value)  $default,){
final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarbonFootprintCompletionRate value)?  $default,){
final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'completion_percentage')  double completionPourcentage, @JsonKey(name: 'total_utilisateurs')  int totalUsers, @JsonKey(name: 'utilisateurs_bilan_termine')  int usersWithCompletedBilan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate() when $default != null:
return $default(_that.completionPourcentage,_that.totalUsers,_that.usersWithCompletedBilan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'completion_percentage')  double completionPourcentage, @JsonKey(name: 'total_utilisateurs')  int totalUsers, @JsonKey(name: 'utilisateurs_bilan_termine')  int usersWithCompletedBilan)  $default,) {final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate():
return $default(_that.completionPourcentage,_that.totalUsers,_that.usersWithCompletedBilan);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'completion_percentage')  double completionPourcentage, @JsonKey(name: 'total_utilisateurs')  int totalUsers, @JsonKey(name: 'utilisateurs_bilan_termine')  int usersWithCompletedBilan)?  $default,) {final _that = this;
switch (_that) {
case _CarbonFootprintCompletionRate() when $default != null:
return $default(_that.completionPourcentage,_that.totalUsers,_that.usersWithCompletedBilan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarbonFootprintCompletionRate extends CarbonFootprintCompletionRate {
  const _CarbonFootprintCompletionRate({@JsonKey(name: 'completion_percentage') required this.completionPourcentage, @JsonKey(name: 'total_utilisateurs') required this.totalUsers, @JsonKey(name: 'utilisateurs_bilan_termine') required this.usersWithCompletedBilan}): super._();
  factory _CarbonFootprintCompletionRate.fromJson(Map<String, dynamic> json) => _$CarbonFootprintCompletionRateFromJson(json);

@override@JsonKey(name: 'completion_percentage') final  double completionPourcentage;
@override@JsonKey(name: 'total_utilisateurs') final  int totalUsers;
@override@JsonKey(name: 'utilisateurs_bilan_termine') final  int usersWithCompletedBilan;

/// Create a copy of CarbonFootprintCompletionRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarbonFootprintCompletionRateCopyWith<_CarbonFootprintCompletionRate> get copyWith => __$CarbonFootprintCompletionRateCopyWithImpl<_CarbonFootprintCompletionRate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarbonFootprintCompletionRateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarbonFootprintCompletionRate&&(identical(other.completionPourcentage, completionPourcentage) || other.completionPourcentage == completionPourcentage)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.usersWithCompletedBilan, usersWithCompletedBilan) || other.usersWithCompletedBilan == usersWithCompletedBilan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completionPourcentage,totalUsers,usersWithCompletedBilan);

@override
String toString() {
  return 'CarbonFootprintCompletionRate(completionPourcentage: $completionPourcentage, totalUsers: $totalUsers, usersWithCompletedBilan: $usersWithCompletedBilan)';
}


}

/// @nodoc
abstract mixin class _$CarbonFootprintCompletionRateCopyWith<$Res> implements $CarbonFootprintCompletionRateCopyWith<$Res> {
  factory _$CarbonFootprintCompletionRateCopyWith(_CarbonFootprintCompletionRate value, $Res Function(_CarbonFootprintCompletionRate) _then) = __$CarbonFootprintCompletionRateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'completion_percentage') double completionPourcentage,@JsonKey(name: 'total_utilisateurs') int totalUsers,@JsonKey(name: 'utilisateurs_bilan_termine') int usersWithCompletedBilan
});




}
/// @nodoc
class __$CarbonFootprintCompletionRateCopyWithImpl<$Res>
    implements _$CarbonFootprintCompletionRateCopyWith<$Res> {
  __$CarbonFootprintCompletionRateCopyWithImpl(this._self, this._then);

  final _CarbonFootprintCompletionRate _self;
  final $Res Function(_CarbonFootprintCompletionRate) _then;

/// Create a copy of CarbonFootprintCompletionRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completionPourcentage = null,Object? totalUsers = null,Object? usersWithCompletedBilan = null,}) {
  return _then(_CarbonFootprintCompletionRate(
completionPourcentage: null == completionPourcentage ? _self.completionPourcentage : completionPourcentage // ignore: cast_nullable_to_non_nullable
as double,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,usersWithCompletedBilan: null == usersWithCompletedBilan ? _self.usersWithCompletedBilan : usersWithCompletedBilan // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
