// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RankingData {

 List<Utilisateurs> get users; List<CarbonFootPrint> get carbonFootPrints; List<Community> get communities;
/// Create a copy of RankingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingDataCopyWith<RankingData> get copyWith => _$RankingDataCopyWithImpl<RankingData>(this as RankingData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingData&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.carbonFootPrints, carbonFootPrints)&&const DeepCollectionEquality().equals(other.communities, communities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(carbonFootPrints),const DeepCollectionEquality().hash(communities));

@override
String toString() {
  return 'RankingData(users: $users, carbonFootPrints: $carbonFootPrints, communities: $communities)';
}


}

/// @nodoc
abstract mixin class $RankingDataCopyWith<$Res>  {
  factory $RankingDataCopyWith(RankingData value, $Res Function(RankingData) _then) = _$RankingDataCopyWithImpl;
@useResult
$Res call({
 List<Utilisateurs> users, List<CarbonFootPrint> carbonFootPrints, List<Community> communities
});




}
/// @nodoc
class _$RankingDataCopyWithImpl<$Res>
    implements $RankingDataCopyWith<$Res> {
  _$RankingDataCopyWithImpl(this._self, this._then);

  final RankingData _self;
  final $Res Function(RankingData) _then;

/// Create a copy of RankingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? carbonFootPrints = null,Object? communities = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<Utilisateurs>,carbonFootPrints: null == carbonFootPrints ? _self.carbonFootPrints : carbonFootPrints // ignore: cast_nullable_to_non_nullable
as List<CarbonFootPrint>,communities: null == communities ? _self.communities : communities // ignore: cast_nullable_to_non_nullable
as List<Community>,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingData].
extension RankingDataPatterns on RankingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingData value)  $default,){
final _that = this;
switch (_that) {
case _RankingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingData value)?  $default,){
final _that = this;
switch (_that) {
case _RankingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Utilisateurs> users,  List<CarbonFootPrint> carbonFootPrints,  List<Community> communities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingData() when $default != null:
return $default(_that.users,_that.carbonFootPrints,_that.communities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Utilisateurs> users,  List<CarbonFootPrint> carbonFootPrints,  List<Community> communities)  $default,) {final _that = this;
switch (_that) {
case _RankingData():
return $default(_that.users,_that.carbonFootPrints,_that.communities);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Utilisateurs> users,  List<CarbonFootPrint> carbonFootPrints,  List<Community> communities)?  $default,) {final _that = this;
switch (_that) {
case _RankingData() when $default != null:
return $default(_that.users,_that.carbonFootPrints,_that.communities);case _:
  return null;

}
}

}

/// @nodoc


class _RankingData implements RankingData {
  const _RankingData({required final  List<Utilisateurs> users, required final  List<CarbonFootPrint> carbonFootPrints, required final  List<Community> communities}): _users = users,_carbonFootPrints = carbonFootPrints,_communities = communities;
  

 final  List<Utilisateurs> _users;
@override List<Utilisateurs> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

 final  List<CarbonFootPrint> _carbonFootPrints;
@override List<CarbonFootPrint> get carbonFootPrints {
  if (_carbonFootPrints is EqualUnmodifiableListView) return _carbonFootPrints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_carbonFootPrints);
}

 final  List<Community> _communities;
@override List<Community> get communities {
  if (_communities is EqualUnmodifiableListView) return _communities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_communities);
}


/// Create a copy of RankingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingDataCopyWith<_RankingData> get copyWith => __$RankingDataCopyWithImpl<_RankingData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingData&&const DeepCollectionEquality().equals(other._users, _users)&&const DeepCollectionEquality().equals(other._carbonFootPrints, _carbonFootPrints)&&const DeepCollectionEquality().equals(other._communities, _communities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(_carbonFootPrints),const DeepCollectionEquality().hash(_communities));

@override
String toString() {
  return 'RankingData(users: $users, carbonFootPrints: $carbonFootPrints, communities: $communities)';
}


}

/// @nodoc
abstract mixin class _$RankingDataCopyWith<$Res> implements $RankingDataCopyWith<$Res> {
  factory _$RankingDataCopyWith(_RankingData value, $Res Function(_RankingData) _then) = __$RankingDataCopyWithImpl;
@override @useResult
$Res call({
 List<Utilisateurs> users, List<CarbonFootPrint> carbonFootPrints, List<Community> communities
});




}
/// @nodoc
class __$RankingDataCopyWithImpl<$Res>
    implements _$RankingDataCopyWith<$Res> {
  __$RankingDataCopyWithImpl(this._self, this._then);

  final _RankingData _self;
  final $Res Function(_RankingData) _then;

/// Create a copy of RankingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? carbonFootPrints = null,Object? communities = null,}) {
  return _then(_RankingData(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<Utilisateurs>,carbonFootPrints: null == carbonFootPrints ? _self._carbonFootPrints : carbonFootPrints // ignore: cast_nullable_to_non_nullable
as List<CarbonFootPrint>,communities: null == communities ? _self._communities : communities // ignore: cast_nullable_to_non_nullable
as List<Community>,
  ));
}


}

// dart format on
