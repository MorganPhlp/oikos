// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_step_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakStepModel {

@JsonKey(name: 'from_streak_phase') int get from;@JsonKey(name: 'to_streak_phase') int get to;@JsonKey(name: 'required_actions_quotidiennes') int get requiredActionsQuotidiennes;@JsonKey(name: 'required_actions_communautaires') int get requiredActionsCommunautaires;
/// Create a copy of StreakStepModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakStepModelCopyWith<StreakStepModel> get copyWith => _$StreakStepModelCopyWithImpl<StreakStepModel>(this as StreakStepModel, _$identity);

  /// Serializes this StreakStepModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakStepModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.requiredActionsQuotidiennes, requiredActionsQuotidiennes) || other.requiredActionsQuotidiennes == requiredActionsQuotidiennes)&&(identical(other.requiredActionsCommunautaires, requiredActionsCommunautaires) || other.requiredActionsCommunautaires == requiredActionsCommunautaires));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,requiredActionsQuotidiennes,requiredActionsCommunautaires);

@override
String toString() {
  return 'StreakStepModel(from: $from, to: $to, requiredActionsQuotidiennes: $requiredActionsQuotidiennes, requiredActionsCommunautaires: $requiredActionsCommunautaires)';
}


}

/// @nodoc
abstract mixin class $StreakStepModelCopyWith<$Res>  {
  factory $StreakStepModelCopyWith(StreakStepModel value, $Res Function(StreakStepModel) _then) = _$StreakStepModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'from_streak_phase') int from,@JsonKey(name: 'to_streak_phase') int to,@JsonKey(name: 'required_actions_quotidiennes') int requiredActionsQuotidiennes,@JsonKey(name: 'required_actions_communautaires') int requiredActionsCommunautaires
});




}
/// @nodoc
class _$StreakStepModelCopyWithImpl<$Res>
    implements $StreakStepModelCopyWith<$Res> {
  _$StreakStepModelCopyWithImpl(this._self, this._then);

  final StreakStepModel _self;
  final $Res Function(StreakStepModel) _then;

/// Create a copy of StreakStepModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? requiredActionsQuotidiennes = null,Object? requiredActionsCommunautaires = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,requiredActionsQuotidiennes: null == requiredActionsQuotidiennes ? _self.requiredActionsQuotidiennes : requiredActionsQuotidiennes // ignore: cast_nullable_to_non_nullable
as int,requiredActionsCommunautaires: null == requiredActionsCommunautaires ? _self.requiredActionsCommunautaires : requiredActionsCommunautaires // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakStepModel].
extension StreakStepModelPatterns on StreakStepModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakStepModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakStepModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakStepModel value)  $default,){
final _that = this;
switch (_that) {
case _StreakStepModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakStepModel value)?  $default,){
final _that = this;
switch (_that) {
case _StreakStepModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'from_streak_phase')  int from, @JsonKey(name: 'to_streak_phase')  int to, @JsonKey(name: 'required_actions_quotidiennes')  int requiredActionsQuotidiennes, @JsonKey(name: 'required_actions_communautaires')  int requiredActionsCommunautaires)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakStepModel() when $default != null:
return $default(_that.from,_that.to,_that.requiredActionsQuotidiennes,_that.requiredActionsCommunautaires);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'from_streak_phase')  int from, @JsonKey(name: 'to_streak_phase')  int to, @JsonKey(name: 'required_actions_quotidiennes')  int requiredActionsQuotidiennes, @JsonKey(name: 'required_actions_communautaires')  int requiredActionsCommunautaires)  $default,) {final _that = this;
switch (_that) {
case _StreakStepModel():
return $default(_that.from,_that.to,_that.requiredActionsQuotidiennes,_that.requiredActionsCommunautaires);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'from_streak_phase')  int from, @JsonKey(name: 'to_streak_phase')  int to, @JsonKey(name: 'required_actions_quotidiennes')  int requiredActionsQuotidiennes, @JsonKey(name: 'required_actions_communautaires')  int requiredActionsCommunautaires)?  $default,) {final _that = this;
switch (_that) {
case _StreakStepModel() when $default != null:
return $default(_that.from,_that.to,_that.requiredActionsQuotidiennes,_that.requiredActionsCommunautaires);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakStepModel extends StreakStepModel {
  const _StreakStepModel({@JsonKey(name: 'from_streak_phase') required this.from, @JsonKey(name: 'to_streak_phase') required this.to, @JsonKey(name: 'required_actions_quotidiennes') required this.requiredActionsQuotidiennes, @JsonKey(name: 'required_actions_communautaires') required this.requiredActionsCommunautaires}): super._();
  factory _StreakStepModel.fromJson(Map<String, dynamic> json) => _$StreakStepModelFromJson(json);

@override@JsonKey(name: 'from_streak_phase') final  int from;
@override@JsonKey(name: 'to_streak_phase') final  int to;
@override@JsonKey(name: 'required_actions_quotidiennes') final  int requiredActionsQuotidiennes;
@override@JsonKey(name: 'required_actions_communautaires') final  int requiredActionsCommunautaires;

/// Create a copy of StreakStepModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakStepModelCopyWith<_StreakStepModel> get copyWith => __$StreakStepModelCopyWithImpl<_StreakStepModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakStepModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakStepModel&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.requiredActionsQuotidiennes, requiredActionsQuotidiennes) || other.requiredActionsQuotidiennes == requiredActionsQuotidiennes)&&(identical(other.requiredActionsCommunautaires, requiredActionsCommunautaires) || other.requiredActionsCommunautaires == requiredActionsCommunautaires));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,requiredActionsQuotidiennes,requiredActionsCommunautaires);

@override
String toString() {
  return 'StreakStepModel(from: $from, to: $to, requiredActionsQuotidiennes: $requiredActionsQuotidiennes, requiredActionsCommunautaires: $requiredActionsCommunautaires)';
}


}

/// @nodoc
abstract mixin class _$StreakStepModelCopyWith<$Res> implements $StreakStepModelCopyWith<$Res> {
  factory _$StreakStepModelCopyWith(_StreakStepModel value, $Res Function(_StreakStepModel) _then) = __$StreakStepModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'from_streak_phase') int from,@JsonKey(name: 'to_streak_phase') int to,@JsonKey(name: 'required_actions_quotidiennes') int requiredActionsQuotidiennes,@JsonKey(name: 'required_actions_communautaires') int requiredActionsCommunautaires
});




}
/// @nodoc
class __$StreakStepModelCopyWithImpl<$Res>
    implements _$StreakStepModelCopyWith<$Res> {
  __$StreakStepModelCopyWithImpl(this._self, this._then);

  final _StreakStepModel _self;
  final $Res Function(_StreakStepModel) _then;

/// Create a copy of StreakStepModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? requiredActionsQuotidiennes = null,Object? requiredActionsCommunautaires = null,}) {
  return _then(_StreakStepModel(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,requiredActionsQuotidiennes: null == requiredActionsQuotidiennes ? _self.requiredActionsQuotidiennes : requiredActionsQuotidiennes // ignore: cast_nullable_to_non_nullable
as int,requiredActionsCommunautaires: null == requiredActionsCommunautaires ? _self.requiredActionsCommunautaires : requiredActionsCommunautaires // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
