// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreakModel {

@JsonKey(name: 'utilisateur_id') String get utilisateurId;@JsonKey(name: 'effective_streak') int get currentStreak;@JsonKey(name: 'last_updated') DateTime? get lastUpdated;@JsonKey(name: 'saison_nom') String? get saisonNom;@JsonKey(name: 'saison_debut') DateTime? get saisonDebut;@JsonKey(name: 'saison_fin') DateTime? get saisonFin;@JsonKey(name: 'streak_theme_path') String? get streakThemePath;@JsonKey(name: 'entreprise_name') String? get entrepriseName;@JsonKey(name: 'last_streak_seen') int? get lastStreakSeen;
/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakModelCopyWith<StreakModel> get copyWith => _$StreakModelCopyWithImpl<StreakModel>(this as StreakModel, _$identity);

  /// Serializes this StreakModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakModel&&(identical(other.utilisateurId, utilisateurId) || other.utilisateurId == utilisateurId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.saisonNom, saisonNom) || other.saisonNom == saisonNom)&&(identical(other.saisonDebut, saisonDebut) || other.saisonDebut == saisonDebut)&&(identical(other.saisonFin, saisonFin) || other.saisonFin == saisonFin)&&(identical(other.streakThemePath, streakThemePath) || other.streakThemePath == streakThemePath)&&(identical(other.entrepriseName, entrepriseName) || other.entrepriseName == entrepriseName)&&(identical(other.lastStreakSeen, lastStreakSeen) || other.lastStreakSeen == lastStreakSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,utilisateurId,currentStreak,lastUpdated,saisonNom,saisonDebut,saisonFin,streakThemePath,entrepriseName,lastStreakSeen);

@override
String toString() {
  return 'StreakModel(utilisateurId: $utilisateurId, currentStreak: $currentStreak, lastUpdated: $lastUpdated, saisonNom: $saisonNom, saisonDebut: $saisonDebut, saisonFin: $saisonFin, streakThemePath: $streakThemePath, entrepriseName: $entrepriseName, lastStreakSeen: $lastStreakSeen)';
}


}

/// @nodoc
abstract mixin class $StreakModelCopyWith<$Res>  {
  factory $StreakModelCopyWith(StreakModel value, $Res Function(StreakModel) _then) = _$StreakModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'utilisateur_id') String utilisateurId,@JsonKey(name: 'effective_streak') int currentStreak,@JsonKey(name: 'last_updated') DateTime? lastUpdated,@JsonKey(name: 'saison_nom') String? saisonNom,@JsonKey(name: 'saison_debut') DateTime? saisonDebut,@JsonKey(name: 'saison_fin') DateTime? saisonFin,@JsonKey(name: 'streak_theme_path') String? streakThemePath,@JsonKey(name: 'entreprise_name') String? entrepriseName,@JsonKey(name: 'last_streak_seen') int? lastStreakSeen
});




}
/// @nodoc
class _$StreakModelCopyWithImpl<$Res>
    implements $StreakModelCopyWith<$Res> {
  _$StreakModelCopyWithImpl(this._self, this._then);

  final StreakModel _self;
  final $Res Function(StreakModel) _then;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? utilisateurId = null,Object? currentStreak = null,Object? lastUpdated = freezed,Object? saisonNom = freezed,Object? saisonDebut = freezed,Object? saisonFin = freezed,Object? streakThemePath = freezed,Object? entrepriseName = freezed,Object? lastStreakSeen = freezed,}) {
  return _then(_self.copyWith(
utilisateurId: null == utilisateurId ? _self.utilisateurId : utilisateurId // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,saisonNom: freezed == saisonNom ? _self.saisonNom : saisonNom // ignore: cast_nullable_to_non_nullable
as String?,saisonDebut: freezed == saisonDebut ? _self.saisonDebut : saisonDebut // ignore: cast_nullable_to_non_nullable
as DateTime?,saisonFin: freezed == saisonFin ? _self.saisonFin : saisonFin // ignore: cast_nullable_to_non_nullable
as DateTime?,streakThemePath: freezed == streakThemePath ? _self.streakThemePath : streakThemePath // ignore: cast_nullable_to_non_nullable
as String?,entrepriseName: freezed == entrepriseName ? _self.entrepriseName : entrepriseName // ignore: cast_nullable_to_non_nullable
as String?,lastStreakSeen: freezed == lastStreakSeen ? _self.lastStreakSeen : lastStreakSeen // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakModel].
extension StreakModelPatterns on StreakModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakModel value)  $default,){
final _that = this;
switch (_that) {
case _StreakModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakModel value)?  $default,){
final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'utilisateur_id')  String utilisateurId, @JsonKey(name: 'effective_streak')  int currentStreak, @JsonKey(name: 'last_updated')  DateTime? lastUpdated, @JsonKey(name: 'saison_nom')  String? saisonNom, @JsonKey(name: 'saison_debut')  DateTime? saisonDebut, @JsonKey(name: 'saison_fin')  DateTime? saisonFin, @JsonKey(name: 'streak_theme_path')  String? streakThemePath, @JsonKey(name: 'entreprise_name')  String? entrepriseName, @JsonKey(name: 'last_streak_seen')  int? lastStreakSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
return $default(_that.utilisateurId,_that.currentStreak,_that.lastUpdated,_that.saisonNom,_that.saisonDebut,_that.saisonFin,_that.streakThemePath,_that.entrepriseName,_that.lastStreakSeen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'utilisateur_id')  String utilisateurId, @JsonKey(name: 'effective_streak')  int currentStreak, @JsonKey(name: 'last_updated')  DateTime? lastUpdated, @JsonKey(name: 'saison_nom')  String? saisonNom, @JsonKey(name: 'saison_debut')  DateTime? saisonDebut, @JsonKey(name: 'saison_fin')  DateTime? saisonFin, @JsonKey(name: 'streak_theme_path')  String? streakThemePath, @JsonKey(name: 'entreprise_name')  String? entrepriseName, @JsonKey(name: 'last_streak_seen')  int? lastStreakSeen)  $default,) {final _that = this;
switch (_that) {
case _StreakModel():
return $default(_that.utilisateurId,_that.currentStreak,_that.lastUpdated,_that.saisonNom,_that.saisonDebut,_that.saisonFin,_that.streakThemePath,_that.entrepriseName,_that.lastStreakSeen);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'utilisateur_id')  String utilisateurId, @JsonKey(name: 'effective_streak')  int currentStreak, @JsonKey(name: 'last_updated')  DateTime? lastUpdated, @JsonKey(name: 'saison_nom')  String? saisonNom, @JsonKey(name: 'saison_debut')  DateTime? saisonDebut, @JsonKey(name: 'saison_fin')  DateTime? saisonFin, @JsonKey(name: 'streak_theme_path')  String? streakThemePath, @JsonKey(name: 'entreprise_name')  String? entrepriseName, @JsonKey(name: 'last_streak_seen')  int? lastStreakSeen)?  $default,) {final _that = this;
switch (_that) {
case _StreakModel() when $default != null:
return $default(_that.utilisateurId,_that.currentStreak,_that.lastUpdated,_that.saisonNom,_that.saisonDebut,_that.saisonFin,_that.streakThemePath,_that.entrepriseName,_that.lastStreakSeen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreakModel extends StreakModel {
  const _StreakModel({@JsonKey(name: 'utilisateur_id') required this.utilisateurId, @JsonKey(name: 'effective_streak') required this.currentStreak, @JsonKey(name: 'last_updated') required this.lastUpdated, @JsonKey(name: 'saison_nom') this.saisonNom, @JsonKey(name: 'saison_debut') this.saisonDebut, @JsonKey(name: 'saison_fin') this.saisonFin, @JsonKey(name: 'streak_theme_path') this.streakThemePath, @JsonKey(name: 'entreprise_name') this.entrepriseName, @JsonKey(name: 'last_streak_seen') this.lastStreakSeen}): super._();
  factory _StreakModel.fromJson(Map<String, dynamic> json) => _$StreakModelFromJson(json);

@override@JsonKey(name: 'utilisateur_id') final  String utilisateurId;
@override@JsonKey(name: 'effective_streak') final  int currentStreak;
@override@JsonKey(name: 'last_updated') final  DateTime? lastUpdated;
@override@JsonKey(name: 'saison_nom') final  String? saisonNom;
@override@JsonKey(name: 'saison_debut') final  DateTime? saisonDebut;
@override@JsonKey(name: 'saison_fin') final  DateTime? saisonFin;
@override@JsonKey(name: 'streak_theme_path') final  String? streakThemePath;
@override@JsonKey(name: 'entreprise_name') final  String? entrepriseName;
@override@JsonKey(name: 'last_streak_seen') final  int? lastStreakSeen;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakModelCopyWith<_StreakModel> get copyWith => __$StreakModelCopyWithImpl<_StreakModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreakModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakModel&&(identical(other.utilisateurId, utilisateurId) || other.utilisateurId == utilisateurId)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.saisonNom, saisonNom) || other.saisonNom == saisonNom)&&(identical(other.saisonDebut, saisonDebut) || other.saisonDebut == saisonDebut)&&(identical(other.saisonFin, saisonFin) || other.saisonFin == saisonFin)&&(identical(other.streakThemePath, streakThemePath) || other.streakThemePath == streakThemePath)&&(identical(other.entrepriseName, entrepriseName) || other.entrepriseName == entrepriseName)&&(identical(other.lastStreakSeen, lastStreakSeen) || other.lastStreakSeen == lastStreakSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,utilisateurId,currentStreak,lastUpdated,saisonNom,saisonDebut,saisonFin,streakThemePath,entrepriseName,lastStreakSeen);

@override
String toString() {
  return 'StreakModel(utilisateurId: $utilisateurId, currentStreak: $currentStreak, lastUpdated: $lastUpdated, saisonNom: $saisonNom, saisonDebut: $saisonDebut, saisonFin: $saisonFin, streakThemePath: $streakThemePath, entrepriseName: $entrepriseName, lastStreakSeen: $lastStreakSeen)';
}


}

/// @nodoc
abstract mixin class _$StreakModelCopyWith<$Res> implements $StreakModelCopyWith<$Res> {
  factory _$StreakModelCopyWith(_StreakModel value, $Res Function(_StreakModel) _then) = __$StreakModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'utilisateur_id') String utilisateurId,@JsonKey(name: 'effective_streak') int currentStreak,@JsonKey(name: 'last_updated') DateTime? lastUpdated,@JsonKey(name: 'saison_nom') String? saisonNom,@JsonKey(name: 'saison_debut') DateTime? saisonDebut,@JsonKey(name: 'saison_fin') DateTime? saisonFin,@JsonKey(name: 'streak_theme_path') String? streakThemePath,@JsonKey(name: 'entreprise_name') String? entrepriseName,@JsonKey(name: 'last_streak_seen') int? lastStreakSeen
});




}
/// @nodoc
class __$StreakModelCopyWithImpl<$Res>
    implements _$StreakModelCopyWith<$Res> {
  __$StreakModelCopyWithImpl(this._self, this._then);

  final _StreakModel _self;
  final $Res Function(_StreakModel) _then;

/// Create a copy of StreakModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? utilisateurId = null,Object? currentStreak = null,Object? lastUpdated = freezed,Object? saisonNom = freezed,Object? saisonDebut = freezed,Object? saisonFin = freezed,Object? streakThemePath = freezed,Object? entrepriseName = freezed,Object? lastStreakSeen = freezed,}) {
  return _then(_StreakModel(
utilisateurId: null == utilisateurId ? _self.utilisateurId : utilisateurId // ignore: cast_nullable_to_non_nullable
as String,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,saisonNom: freezed == saisonNom ? _self.saisonNom : saisonNom // ignore: cast_nullable_to_non_nullable
as String?,saisonDebut: freezed == saisonDebut ? _self.saisonDebut : saisonDebut // ignore: cast_nullable_to_non_nullable
as DateTime?,saisonFin: freezed == saisonFin ? _self.saisonFin : saisonFin // ignore: cast_nullable_to_non_nullable
as DateTime?,streakThemePath: freezed == streakThemePath ? _self.streakThemePath : streakThemePath // ignore: cast_nullable_to_non_nullable
as String?,entrepriseName: freezed == entrepriseName ? _self.entrepriseName : entrepriseName // ignore: cast_nullable_to_non_nullable
as String?,lastStreakSeen: freezed == lastStreakSeen ? _self.lastStreakSeen : lastStreakSeen // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
