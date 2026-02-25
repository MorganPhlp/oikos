// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityData {

@JsonSerializable(explicitToJson: true) List<Utilisateurs> get users;@JsonSerializable(explicitToJson: true) List<Community> get communities;
/// Create a copy of CommunityData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityDataCopyWith<CommunityData> get copyWith => _$CommunityDataCopyWithImpl<CommunityData>(this as CommunityData, _$identity);

  /// Serializes this CommunityData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityData&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.communities, communities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(communities));

@override
String toString() {
  return 'CommunityData(users: $users, communities: $communities)';
}


}

/// @nodoc
abstract mixin class $CommunityDataCopyWith<$Res>  {
  factory $CommunityDataCopyWith(CommunityData value, $Res Function(CommunityData) _then) = _$CommunityDataCopyWithImpl;
@useResult
$Res call({
@JsonSerializable(explicitToJson: true) List<Utilisateurs> users,@JsonSerializable(explicitToJson: true) List<Community> communities
});




}
/// @nodoc
class _$CommunityDataCopyWithImpl<$Res>
    implements $CommunityDataCopyWith<$Res> {
  _$CommunityDataCopyWithImpl(this._self, this._then);

  final CommunityData _self;
  final $Res Function(CommunityData) _then;

/// Create a copy of CommunityData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,Object? communities = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<Utilisateurs>,communities: null == communities ? _self.communities : communities // ignore: cast_nullable_to_non_nullable
as List<Community>,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityData].
extension CommunityDataPatterns on CommunityData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityData value)  $default,){
final _that = this;
switch (_that) {
case _CommunityData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityData value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonSerializable(explicitToJson: true)  List<Utilisateurs> users, @JsonSerializable(explicitToJson: true)  List<Community> communities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityData() when $default != null:
return $default(_that.users,_that.communities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonSerializable(explicitToJson: true)  List<Utilisateurs> users, @JsonSerializable(explicitToJson: true)  List<Community> communities)  $default,) {final _that = this;
switch (_that) {
case _CommunityData():
return $default(_that.users,_that.communities);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonSerializable(explicitToJson: true)  List<Utilisateurs> users, @JsonSerializable(explicitToJson: true)  List<Community> communities)?  $default,) {final _that = this;
switch (_that) {
case _CommunityData() when $default != null:
return $default(_that.users,_that.communities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityData implements CommunityData {
  const _CommunityData({@JsonSerializable(explicitToJson: true) required final  List<Utilisateurs> users, @JsonSerializable(explicitToJson: true) required final  List<Community> communities}): _users = users,_communities = communities;
  factory _CommunityData.fromJson(Map<String, dynamic> json) => _$CommunityDataFromJson(json);

 final  List<Utilisateurs> _users;
@override@JsonSerializable(explicitToJson: true) List<Utilisateurs> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

 final  List<Community> _communities;
@override@JsonSerializable(explicitToJson: true) List<Community> get communities {
  if (_communities is EqualUnmodifiableListView) return _communities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_communities);
}


/// Create a copy of CommunityData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityDataCopyWith<_CommunityData> get copyWith => __$CommunityDataCopyWithImpl<_CommunityData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityData&&const DeepCollectionEquality().equals(other._users, _users)&&const DeepCollectionEquality().equals(other._communities, _communities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(_communities));

@override
String toString() {
  return 'CommunityData(users: $users, communities: $communities)';
}


}

/// @nodoc
abstract mixin class _$CommunityDataCopyWith<$Res> implements $CommunityDataCopyWith<$Res> {
  factory _$CommunityDataCopyWith(_CommunityData value, $Res Function(_CommunityData) _then) = __$CommunityDataCopyWithImpl;
@override @useResult
$Res call({
@JsonSerializable(explicitToJson: true) List<Utilisateurs> users,@JsonSerializable(explicitToJson: true) List<Community> communities
});




}
/// @nodoc
class __$CommunityDataCopyWithImpl<$Res>
    implements _$CommunityDataCopyWith<$Res> {
  __$CommunityDataCopyWithImpl(this._self, this._then);

  final _CommunityData _self;
  final $Res Function(_CommunityData) _then;

/// Create a copy of CommunityData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,Object? communities = null,}) {
  return _then(_CommunityData(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<Utilisateurs>,communities: null == communities ? _self._communities : communities // ignore: cast_nullable_to_non_nullable
as List<Community>,
  ));
}


}

// dart format on
