// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_insights_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalInsightsStats {

@JsonKey(name: 'co2_total') double get totalCo2Saved;@JsonKey(name: 'defis_actifs') int get activeChallenges;@JsonKey(name: 'taux_retention') int get retentionRate;@JsonKey(name: 'total_utilisateurs') double get activeUsers;
/// Create a copy of GlobalInsightsStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalInsightsStatsCopyWith<GlobalInsightsStats> get copyWith => _$GlobalInsightsStatsCopyWithImpl<GlobalInsightsStats>(this as GlobalInsightsStats, _$identity);

  /// Serializes this GlobalInsightsStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalInsightsStats&&(identical(other.totalCo2Saved, totalCo2Saved) || other.totalCo2Saved == totalCo2Saved)&&(identical(other.activeChallenges, activeChallenges) || other.activeChallenges == activeChallenges)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCo2Saved,activeChallenges,retentionRate,activeUsers);

@override
String toString() {
  return 'GlobalInsightsStats(totalCo2Saved: $totalCo2Saved, activeChallenges: $activeChallenges, retentionRate: $retentionRate, activeUsers: $activeUsers)';
}


}

/// @nodoc
abstract mixin class $GlobalInsightsStatsCopyWith<$Res>  {
  factory $GlobalInsightsStatsCopyWith(GlobalInsightsStats value, $Res Function(GlobalInsightsStats) _then) = _$GlobalInsightsStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'co2_total') double totalCo2Saved,@JsonKey(name: 'defis_actifs') int activeChallenges,@JsonKey(name: 'taux_retention') int retentionRate,@JsonKey(name: 'total_utilisateurs') double activeUsers
});




}
/// @nodoc
class _$GlobalInsightsStatsCopyWithImpl<$Res>
    implements $GlobalInsightsStatsCopyWith<$Res> {
  _$GlobalInsightsStatsCopyWithImpl(this._self, this._then);

  final GlobalInsightsStats _self;
  final $Res Function(GlobalInsightsStats) _then;

/// Create a copy of GlobalInsightsStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCo2Saved = null,Object? activeChallenges = null,Object? retentionRate = null,Object? activeUsers = null,}) {
  return _then(_self.copyWith(
totalCo2Saved: null == totalCo2Saved ? _self.totalCo2Saved : totalCo2Saved // ignore: cast_nullable_to_non_nullable
as double,activeChallenges: null == activeChallenges ? _self.activeChallenges : activeChallenges // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalInsightsStats].
extension GlobalInsightsStatsPatterns on GlobalInsightsStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalInsightsStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalInsightsStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalInsightsStats value)  $default,){
final _that = this;
switch (_that) {
case _GlobalInsightsStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalInsightsStats value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalInsightsStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'co2_total')  double totalCo2Saved, @JsonKey(name: 'defis_actifs')  int activeChallenges, @JsonKey(name: 'taux_retention')  int retentionRate, @JsonKey(name: 'total_utilisateurs')  double activeUsers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalInsightsStats() when $default != null:
return $default(_that.totalCo2Saved,_that.activeChallenges,_that.retentionRate,_that.activeUsers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'co2_total')  double totalCo2Saved, @JsonKey(name: 'defis_actifs')  int activeChallenges, @JsonKey(name: 'taux_retention')  int retentionRate, @JsonKey(name: 'total_utilisateurs')  double activeUsers)  $default,) {final _that = this;
switch (_that) {
case _GlobalInsightsStats():
return $default(_that.totalCo2Saved,_that.activeChallenges,_that.retentionRate,_that.activeUsers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'co2_total')  double totalCo2Saved, @JsonKey(name: 'defis_actifs')  int activeChallenges, @JsonKey(name: 'taux_retention')  int retentionRate, @JsonKey(name: 'total_utilisateurs')  double activeUsers)?  $default,) {final _that = this;
switch (_that) {
case _GlobalInsightsStats() when $default != null:
return $default(_that.totalCo2Saved,_that.activeChallenges,_that.retentionRate,_that.activeUsers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalInsightsStats implements GlobalInsightsStats {
  const _GlobalInsightsStats({@JsonKey(name: 'co2_total') required this.totalCo2Saved, @JsonKey(name: 'defis_actifs') required this.activeChallenges, @JsonKey(name: 'taux_retention') required this.retentionRate, @JsonKey(name: 'total_utilisateurs') required this.activeUsers});
  factory _GlobalInsightsStats.fromJson(Map<String, dynamic> json) => _$GlobalInsightsStatsFromJson(json);

@override@JsonKey(name: 'co2_total') final  double totalCo2Saved;
@override@JsonKey(name: 'defis_actifs') final  int activeChallenges;
@override@JsonKey(name: 'taux_retention') final  int retentionRate;
@override@JsonKey(name: 'total_utilisateurs') final  double activeUsers;

/// Create a copy of GlobalInsightsStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalInsightsStatsCopyWith<_GlobalInsightsStats> get copyWith => __$GlobalInsightsStatsCopyWithImpl<_GlobalInsightsStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalInsightsStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalInsightsStats&&(identical(other.totalCo2Saved, totalCo2Saved) || other.totalCo2Saved == totalCo2Saved)&&(identical(other.activeChallenges, activeChallenges) || other.activeChallenges == activeChallenges)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.activeUsers, activeUsers) || other.activeUsers == activeUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCo2Saved,activeChallenges,retentionRate,activeUsers);

@override
String toString() {
  return 'GlobalInsightsStats(totalCo2Saved: $totalCo2Saved, activeChallenges: $activeChallenges, retentionRate: $retentionRate, activeUsers: $activeUsers)';
}


}

/// @nodoc
abstract mixin class _$GlobalInsightsStatsCopyWith<$Res> implements $GlobalInsightsStatsCopyWith<$Res> {
  factory _$GlobalInsightsStatsCopyWith(_GlobalInsightsStats value, $Res Function(_GlobalInsightsStats) _then) = __$GlobalInsightsStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'co2_total') double totalCo2Saved,@JsonKey(name: 'defis_actifs') int activeChallenges,@JsonKey(name: 'taux_retention') int retentionRate,@JsonKey(name: 'total_utilisateurs') double activeUsers
});




}
/// @nodoc
class __$GlobalInsightsStatsCopyWithImpl<$Res>
    implements _$GlobalInsightsStatsCopyWith<$Res> {
  __$GlobalInsightsStatsCopyWithImpl(this._self, this._then);

  final _GlobalInsightsStats _self;
  final $Res Function(_GlobalInsightsStats) _then;

/// Create a copy of GlobalInsightsStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCo2Saved = null,Object? activeChallenges = null,Object? retentionRate = null,Object? activeUsers = null,}) {
  return _then(_GlobalInsightsStats(
totalCo2Saved: null == totalCo2Saved ? _self.totalCo2Saved : totalCo2Saved // ignore: cast_nullable_to_non_nullable
as double,activeChallenges: null == activeChallenges ? _self.activeChallenges : activeChallenges // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as int,activeUsers: null == activeUsers ? _self.activeUsers : activeUsers // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
