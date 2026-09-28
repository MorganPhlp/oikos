// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carbon_foot_print.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarbonFootPrint {

@JsonKey(name: 'utilisateur_id') String get userId;@JsonKey(name: 'scoretotalco2ean') double get score;@JsonKey(name: 'date_bilan') String get dateBilan;
/// Create a copy of CarbonFootPrint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarbonFootPrintCopyWith<CarbonFootPrint> get copyWith => _$CarbonFootPrintCopyWithImpl<CarbonFootPrint>(this as CarbonFootPrint, _$identity);

  /// Serializes this CarbonFootPrint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarbonFootPrint&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.score, score) || other.score == score)&&(identical(other.dateBilan, dateBilan) || other.dateBilan == dateBilan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,score,dateBilan);

@override
String toString() {
  return 'CarbonFootPrint(userId: $userId, score: $score, dateBilan: $dateBilan)';
}


}

/// @nodoc
abstract mixin class $CarbonFootPrintCopyWith<$Res>  {
  factory $CarbonFootPrintCopyWith(CarbonFootPrint value, $Res Function(CarbonFootPrint) _then) = _$CarbonFootPrintCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'utilisateur_id') String userId,@JsonKey(name: 'scoretotalco2ean') double score,@JsonKey(name: 'date_bilan') String dateBilan
});




}
/// @nodoc
class _$CarbonFootPrintCopyWithImpl<$Res>
    implements $CarbonFootPrintCopyWith<$Res> {
  _$CarbonFootPrintCopyWithImpl(this._self, this._then);

  final CarbonFootPrint _self;
  final $Res Function(CarbonFootPrint) _then;

/// Create a copy of CarbonFootPrint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? score = null,Object? dateBilan = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,dateBilan: null == dateBilan ? _self.dateBilan : dateBilan // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CarbonFootPrint].
extension CarbonFootPrintPatterns on CarbonFootPrint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarbonFootPrint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarbonFootPrint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarbonFootPrint value)  $default,){
final _that = this;
switch (_that) {
case _CarbonFootPrint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarbonFootPrint value)?  $default,){
final _that = this;
switch (_that) {
case _CarbonFootPrint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'utilisateur_id')  String userId, @JsonKey(name: 'scoretotalco2ean')  double score, @JsonKey(name: 'date_bilan')  String dateBilan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarbonFootPrint() when $default != null:
return $default(_that.userId,_that.score,_that.dateBilan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'utilisateur_id')  String userId, @JsonKey(name: 'scoretotalco2ean')  double score, @JsonKey(name: 'date_bilan')  String dateBilan)  $default,) {final _that = this;
switch (_that) {
case _CarbonFootPrint():
return $default(_that.userId,_that.score,_that.dateBilan);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'utilisateur_id')  String userId, @JsonKey(name: 'scoretotalco2ean')  double score, @JsonKey(name: 'date_bilan')  String dateBilan)?  $default,) {final _that = this;
switch (_that) {
case _CarbonFootPrint() when $default != null:
return $default(_that.userId,_that.score,_that.dateBilan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarbonFootPrint implements CarbonFootPrint {
  const _CarbonFootPrint({@JsonKey(name: 'utilisateur_id') required this.userId, @JsonKey(name: 'scoretotalco2ean') required this.score, @JsonKey(name: 'date_bilan') required this.dateBilan});
  factory _CarbonFootPrint.fromJson(Map<String, dynamic> json) => _$CarbonFootPrintFromJson(json);

@override@JsonKey(name: 'utilisateur_id') final  String userId;
@override@JsonKey(name: 'scoretotalco2ean') final  double score;
@override@JsonKey(name: 'date_bilan') final  String dateBilan;

/// Create a copy of CarbonFootPrint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarbonFootPrintCopyWith<_CarbonFootPrint> get copyWith => __$CarbonFootPrintCopyWithImpl<_CarbonFootPrint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarbonFootPrintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarbonFootPrint&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.score, score) || other.score == score)&&(identical(other.dateBilan, dateBilan) || other.dateBilan == dateBilan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,score,dateBilan);

@override
String toString() {
  return 'CarbonFootPrint(userId: $userId, score: $score, dateBilan: $dateBilan)';
}


}

/// @nodoc
abstract mixin class _$CarbonFootPrintCopyWith<$Res> implements $CarbonFootPrintCopyWith<$Res> {
  factory _$CarbonFootPrintCopyWith(_CarbonFootPrint value, $Res Function(_CarbonFootPrint) _then) = __$CarbonFootPrintCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'utilisateur_id') String userId,@JsonKey(name: 'scoretotalco2ean') double score,@JsonKey(name: 'date_bilan') String dateBilan
});




}
/// @nodoc
class __$CarbonFootPrintCopyWithImpl<$Res>
    implements _$CarbonFootPrintCopyWith<$Res> {
  __$CarbonFootPrintCopyWithImpl(this._self, this._then);

  final _CarbonFootPrint _self;
  final $Res Function(_CarbonFootPrint) _then;

/// Create a copy of CarbonFootPrint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? score = null,Object? dateBilan = null,}) {
  return _then(_CarbonFootPrint(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,dateBilan: null == dateBilan ? _self.dateBilan : dateBilan // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
