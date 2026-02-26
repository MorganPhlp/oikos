// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utilisateurs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Utilisateurs {

 String get id; String get email; String get pseudo;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'code_communaute') String get codeCommunaute;@JsonKey(name: 'entreprise_id') String get entrepriseId; RoleUtilisateur get role;@JsonKey(name: 'etat_compte') EtatCompte get etatCompte;@JsonKey(name: 'est_compte_valide') bool get estCompteValide;@JsonKey(name: 'impact_score_xp') int get impactScoreXp;@JsonKey(name: 'a_accepte_cgu') bool get aAccepteCgu;@JsonKey(name: 'a_complete_bilan') bool get hasCompletedBilan;// Ce champ n'existe pas dans ta table SQL 'utilisateur'.
// S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
 int get objectif;
/// Create a copy of Utilisateurs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UtilisateursCopyWith<Utilisateurs> get copyWith => _$UtilisateursCopyWithImpl<Utilisateurs>(this as Utilisateurs, _$identity);

  /// Serializes this Utilisateurs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Utilisateurs&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.pseudo, pseudo) || other.pseudo == pseudo)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.codeCommunaute, codeCommunaute) || other.codeCommunaute == codeCommunaute)&&(identical(other.entrepriseId, entrepriseId) || other.entrepriseId == entrepriseId)&&(identical(other.role, role) || other.role == role)&&(identical(other.etatCompte, etatCompte) || other.etatCompte == etatCompte)&&(identical(other.estCompteValide, estCompteValide) || other.estCompteValide == estCompteValide)&&(identical(other.impactScoreXp, impactScoreXp) || other.impactScoreXp == impactScoreXp)&&(identical(other.aAccepteCgu, aAccepteCgu) || other.aAccepteCgu == aAccepteCgu)&&(identical(other.hasCompletedBilan, hasCompletedBilan) || other.hasCompletedBilan == hasCompletedBilan)&&(identical(other.objectif, objectif) || other.objectif == objectif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,pseudo,avatarUrl,codeCommunaute,entrepriseId,role,etatCompte,estCompteValide,impactScoreXp,aAccepteCgu,hasCompletedBilan,objectif);

@override
String toString() {
  return 'Utilisateurs(id: $id, email: $email, pseudo: $pseudo, avatarUrl: $avatarUrl, codeCommunaute: $codeCommunaute, entrepriseId: $entrepriseId, role: $role, etatCompte: $etatCompte, estCompteValide: $estCompteValide, impactScoreXp: $impactScoreXp, aAccepteCgu: $aAccepteCgu, hasCompletedBilan: $hasCompletedBilan, objectif: $objectif)';
}


}

/// @nodoc
abstract mixin class $UtilisateursCopyWith<$Res>  {
  factory $UtilisateursCopyWith(Utilisateurs value, $Res Function(Utilisateurs) _then) = _$UtilisateursCopyWithImpl;
@useResult
$Res call({
 String id, String email, String pseudo,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'code_communaute') String codeCommunaute,@JsonKey(name: 'entreprise_id') String entrepriseId, RoleUtilisateur role,@JsonKey(name: 'etat_compte') EtatCompte etatCompte,@JsonKey(name: 'est_compte_valide') bool estCompteValide,@JsonKey(name: 'impact_score_xp') int impactScoreXp,@JsonKey(name: 'a_accepte_cgu') bool aAccepteCgu,@JsonKey(name: 'a_complete_bilan') bool hasCompletedBilan, int objectif
});




}
/// @nodoc
class _$UtilisateursCopyWithImpl<$Res>
    implements $UtilisateursCopyWith<$Res> {
  _$UtilisateursCopyWithImpl(this._self, this._then);

  final Utilisateurs _self;
  final $Res Function(Utilisateurs) _then;

/// Create a copy of Utilisateurs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? pseudo = null,Object? avatarUrl = freezed,Object? codeCommunaute = null,Object? entrepriseId = null,Object? role = null,Object? etatCompte = null,Object? estCompteValide = null,Object? impactScoreXp = null,Object? aAccepteCgu = null,Object? hasCompletedBilan = null,Object? objectif = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pseudo: null == pseudo ? _self.pseudo : pseudo // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,codeCommunaute: null == codeCommunaute ? _self.codeCommunaute : codeCommunaute // ignore: cast_nullable_to_non_nullable
as String,entrepriseId: null == entrepriseId ? _self.entrepriseId : entrepriseId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleUtilisateur,etatCompte: null == etatCompte ? _self.etatCompte : etatCompte // ignore: cast_nullable_to_non_nullable
as EtatCompte,estCompteValide: null == estCompteValide ? _self.estCompteValide : estCompteValide // ignore: cast_nullable_to_non_nullable
as bool,impactScoreXp: null == impactScoreXp ? _self.impactScoreXp : impactScoreXp // ignore: cast_nullable_to_non_nullable
as int,aAccepteCgu: null == aAccepteCgu ? _self.aAccepteCgu : aAccepteCgu // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedBilan: null == hasCompletedBilan ? _self.hasCompletedBilan : hasCompletedBilan // ignore: cast_nullable_to_non_nullable
as bool,objectif: null == objectif ? _self.objectif : objectif // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Utilisateurs].
extension UtilisateursPatterns on Utilisateurs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Utilisateurs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Utilisateurs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Utilisateurs value)  $default,){
final _that = this;
switch (_that) {
case _Utilisateurs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Utilisateurs value)?  $default,){
final _that = this;
switch (_that) {
case _Utilisateurs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String pseudo, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'code_communaute')  String codeCommunaute, @JsonKey(name: 'entreprise_id')  String entrepriseId,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'a_complete_bilan')  bool hasCompletedBilan,  int objectif)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Utilisateurs() when $default != null:
return $default(_that.id,_that.email,_that.pseudo,_that.avatarUrl,_that.codeCommunaute,_that.entrepriseId,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.aAccepteCgu,_that.hasCompletedBilan,_that.objectif);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String pseudo, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'code_communaute')  String codeCommunaute, @JsonKey(name: 'entreprise_id')  String entrepriseId,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'a_complete_bilan')  bool hasCompletedBilan,  int objectif)  $default,) {final _that = this;
switch (_that) {
case _Utilisateurs():
return $default(_that.id,_that.email,_that.pseudo,_that.avatarUrl,_that.codeCommunaute,_that.entrepriseId,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.aAccepteCgu,_that.hasCompletedBilan,_that.objectif);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String pseudo, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'code_communaute')  String codeCommunaute, @JsonKey(name: 'entreprise_id')  String entrepriseId,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'a_complete_bilan')  bool hasCompletedBilan,  int objectif)?  $default,) {final _that = this;
switch (_that) {
case _Utilisateurs() when $default != null:
return $default(_that.id,_that.email,_that.pseudo,_that.avatarUrl,_that.codeCommunaute,_that.entrepriseId,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.aAccepteCgu,_that.hasCompletedBilan,_that.objectif);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Utilisateurs implements Utilisateurs {
  const _Utilisateurs({this.id = '', this.email = '', this.pseudo = '', @JsonKey(name: 'avatar_url') this.avatarUrl = '', @JsonKey(name: 'code_communaute') this.codeCommunaute = '', @JsonKey(name: 'entreprise_id') this.entrepriseId = '', this.role = RoleUtilisateur.utilisateur, @JsonKey(name: 'etat_compte') this.etatCompte = EtatCompte.actif, @JsonKey(name: 'est_compte_valide') this.estCompteValide = true, @JsonKey(name: 'impact_score_xp') this.impactScoreXp = 0, @JsonKey(name: 'a_accepte_cgu') this.aAccepteCgu = false, @JsonKey(name: 'a_complete_bilan') this.hasCompletedBilan = false, this.objectif = -10});
  factory _Utilisateurs.fromJson(Map<String, dynamic> json) => _$UtilisateursFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String email;
@override@JsonKey() final  String pseudo;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'code_communaute') final  String codeCommunaute;
@override@JsonKey(name: 'entreprise_id') final  String entrepriseId;
@override@JsonKey() final  RoleUtilisateur role;
@override@JsonKey(name: 'etat_compte') final  EtatCompte etatCompte;
@override@JsonKey(name: 'est_compte_valide') final  bool estCompteValide;
@override@JsonKey(name: 'impact_score_xp') final  int impactScoreXp;
@override@JsonKey(name: 'a_accepte_cgu') final  bool aAccepteCgu;
@override@JsonKey(name: 'a_complete_bilan') final  bool hasCompletedBilan;
// Ce champ n'existe pas dans ta table SQL 'utilisateur'.
// S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
@override@JsonKey() final  int objectif;

/// Create a copy of Utilisateurs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UtilisateursCopyWith<_Utilisateurs> get copyWith => __$UtilisateursCopyWithImpl<_Utilisateurs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UtilisateursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Utilisateurs&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.pseudo, pseudo) || other.pseudo == pseudo)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.codeCommunaute, codeCommunaute) || other.codeCommunaute == codeCommunaute)&&(identical(other.entrepriseId, entrepriseId) || other.entrepriseId == entrepriseId)&&(identical(other.role, role) || other.role == role)&&(identical(other.etatCompte, etatCompte) || other.etatCompte == etatCompte)&&(identical(other.estCompteValide, estCompteValide) || other.estCompteValide == estCompteValide)&&(identical(other.impactScoreXp, impactScoreXp) || other.impactScoreXp == impactScoreXp)&&(identical(other.aAccepteCgu, aAccepteCgu) || other.aAccepteCgu == aAccepteCgu)&&(identical(other.hasCompletedBilan, hasCompletedBilan) || other.hasCompletedBilan == hasCompletedBilan)&&(identical(other.objectif, objectif) || other.objectif == objectif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,pseudo,avatarUrl,codeCommunaute,entrepriseId,role,etatCompte,estCompteValide,impactScoreXp,aAccepteCgu,hasCompletedBilan,objectif);

@override
String toString() {
  return 'Utilisateurs(id: $id, email: $email, pseudo: $pseudo, avatarUrl: $avatarUrl, codeCommunaute: $codeCommunaute, entrepriseId: $entrepriseId, role: $role, etatCompte: $etatCompte, estCompteValide: $estCompteValide, impactScoreXp: $impactScoreXp, aAccepteCgu: $aAccepteCgu, hasCompletedBilan: $hasCompletedBilan, objectif: $objectif)';
}


}

/// @nodoc
abstract mixin class _$UtilisateursCopyWith<$Res> implements $UtilisateursCopyWith<$Res> {
  factory _$UtilisateursCopyWith(_Utilisateurs value, $Res Function(_Utilisateurs) _then) = __$UtilisateursCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String pseudo,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'code_communaute') String codeCommunaute,@JsonKey(name: 'entreprise_id') String entrepriseId, RoleUtilisateur role,@JsonKey(name: 'etat_compte') EtatCompte etatCompte,@JsonKey(name: 'est_compte_valide') bool estCompteValide,@JsonKey(name: 'impact_score_xp') int impactScoreXp,@JsonKey(name: 'a_accepte_cgu') bool aAccepteCgu,@JsonKey(name: 'a_complete_bilan') bool hasCompletedBilan, int objectif
});




}
/// @nodoc
class __$UtilisateursCopyWithImpl<$Res>
    implements _$UtilisateursCopyWith<$Res> {
  __$UtilisateursCopyWithImpl(this._self, this._then);

  final _Utilisateurs _self;
  final $Res Function(_Utilisateurs) _then;

/// Create a copy of Utilisateurs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? pseudo = null,Object? avatarUrl = freezed,Object? codeCommunaute = null,Object? entrepriseId = null,Object? role = null,Object? etatCompte = null,Object? estCompteValide = null,Object? impactScoreXp = null,Object? aAccepteCgu = null,Object? hasCompletedBilan = null,Object? objectif = null,}) {
  return _then(_Utilisateurs(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pseudo: null == pseudo ? _self.pseudo : pseudo // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,codeCommunaute: null == codeCommunaute ? _self.codeCommunaute : codeCommunaute // ignore: cast_nullable_to_non_nullable
as String,entrepriseId: null == entrepriseId ? _self.entrepriseId : entrepriseId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleUtilisateur,etatCompte: null == etatCompte ? _self.etatCompte : etatCompte // ignore: cast_nullable_to_non_nullable
as EtatCompte,estCompteValide: null == estCompteValide ? _self.estCompteValide : estCompteValide // ignore: cast_nullable_to_non_nullable
as bool,impactScoreXp: null == impactScoreXp ? _self.impactScoreXp : impactScoreXp // ignore: cast_nullable_to_non_nullable
as int,aAccepteCgu: null == aAccepteCgu ? _self.aAccepteCgu : aAccepteCgu // ignore: cast_nullable_to_non_nullable
as bool,hasCompletedBilan: null == hasCompletedBilan ? _self.hasCompletedBilan : hasCompletedBilan // ignore: cast_nullable_to_non_nullable
as bool,objectif: null == objectif ? _self.objectif : objectif // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
