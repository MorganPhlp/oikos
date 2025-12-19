// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utilisateur_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UtilisateurEntity {

 String get id; String get email; String get pseudo; String get avatar; RoleUtilisateur get role;@JsonKey(name: 'etat_compte') EtatCompte get etatCompte;@JsonKey(name: 'est_compte_valide') bool get estCompteValide;@JsonKey(name: 'impact_score_xp') int get impactScoreXp;@JsonKey(name: 'co2_economise_total') double get co2EconomiseTotal;@JsonKey(name: 'a_accepte_cgu') bool get aAccepteCgu;@JsonKey(name: 'communaute_nom') String get communauteNom;// Ce champ n'existe pas dans ta table SQL 'utilisateur'. 
// S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
 int get objectif;
/// Create a copy of UtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UtilisateurEntityCopyWith<UtilisateurEntity> get copyWith => _$UtilisateurEntityCopyWithImpl<UtilisateurEntity>(this as UtilisateurEntity, _$identity);

  /// Serializes this UtilisateurEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UtilisateurEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.pseudo, pseudo) || other.pseudo == pseudo)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role)&&(identical(other.etatCompte, etatCompte) || other.etatCompte == etatCompte)&&(identical(other.estCompteValide, estCompteValide) || other.estCompteValide == estCompteValide)&&(identical(other.impactScoreXp, impactScoreXp) || other.impactScoreXp == impactScoreXp)&&(identical(other.co2EconomiseTotal, co2EconomiseTotal) || other.co2EconomiseTotal == co2EconomiseTotal)&&(identical(other.aAccepteCgu, aAccepteCgu) || other.aAccepteCgu == aAccepteCgu)&&(identical(other.communauteNom, communauteNom) || other.communauteNom == communauteNom)&&(identical(other.objectif, objectif) || other.objectif == objectif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,pseudo,avatar,role,etatCompte,estCompteValide,impactScoreXp,co2EconomiseTotal,aAccepteCgu,communauteNom,objectif);

@override
String toString() {
  return 'UtilisateurEntity(id: $id, email: $email, pseudo: $pseudo, avatar: $avatar, role: $role, etatCompte: $etatCompte, estCompteValide: $estCompteValide, impactScoreXp: $impactScoreXp, co2EconomiseTotal: $co2EconomiseTotal, aAccepteCgu: $aAccepteCgu, communauteNom: $communauteNom, objectif: $objectif)';
}


}

/// @nodoc
abstract mixin class $UtilisateurEntityCopyWith<$Res>  {
  factory $UtilisateurEntityCopyWith(UtilisateurEntity value, $Res Function(UtilisateurEntity) _then) = _$UtilisateurEntityCopyWithImpl;
@useResult
$Res call({
 String id, String email, String pseudo, String avatar, RoleUtilisateur role,@JsonKey(name: 'etat_compte') EtatCompte etatCompte,@JsonKey(name: 'est_compte_valide') bool estCompteValide,@JsonKey(name: 'impact_score_xp') int impactScoreXp,@JsonKey(name: 'co2_economise_total') double co2EconomiseTotal,@JsonKey(name: 'a_accepte_cgu') bool aAccepteCgu,@JsonKey(name: 'communaute_nom') String communauteNom, int objectif
});




}
/// @nodoc
class _$UtilisateurEntityCopyWithImpl<$Res>
    implements $UtilisateurEntityCopyWith<$Res> {
  _$UtilisateurEntityCopyWithImpl(this._self, this._then);

  final UtilisateurEntity _self;
  final $Res Function(UtilisateurEntity) _then;

/// Create a copy of UtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? pseudo = null,Object? avatar = null,Object? role = null,Object? etatCompte = null,Object? estCompteValide = null,Object? impactScoreXp = null,Object? co2EconomiseTotal = null,Object? aAccepteCgu = null,Object? communauteNom = null,Object? objectif = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pseudo: null == pseudo ? _self.pseudo : pseudo // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleUtilisateur,etatCompte: null == etatCompte ? _self.etatCompte : etatCompte // ignore: cast_nullable_to_non_nullable
as EtatCompte,estCompteValide: null == estCompteValide ? _self.estCompteValide : estCompteValide // ignore: cast_nullable_to_non_nullable
as bool,impactScoreXp: null == impactScoreXp ? _self.impactScoreXp : impactScoreXp // ignore: cast_nullable_to_non_nullable
as int,co2EconomiseTotal: null == co2EconomiseTotal ? _self.co2EconomiseTotal : co2EconomiseTotal // ignore: cast_nullable_to_non_nullable
as double,aAccepteCgu: null == aAccepteCgu ? _self.aAccepteCgu : aAccepteCgu // ignore: cast_nullable_to_non_nullable
as bool,communauteNom: null == communauteNom ? _self.communauteNom : communauteNom // ignore: cast_nullable_to_non_nullable
as String,objectif: null == objectif ? _self.objectif : objectif // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UtilisateurEntity].
extension UtilisateurEntityPatterns on UtilisateurEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UtilisateurEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UtilisateurEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UtilisateurEntity value)  $default,){
final _that = this;
switch (_that) {
case _UtilisateurEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UtilisateurEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UtilisateurEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String pseudo,  String avatar,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'co2_economise_total')  double co2EconomiseTotal, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'communaute_nom')  String communauteNom,  int objectif)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UtilisateurEntity() when $default != null:
return $default(_that.id,_that.email,_that.pseudo,_that.avatar,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.co2EconomiseTotal,_that.aAccepteCgu,_that.communauteNom,_that.objectif);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String pseudo,  String avatar,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'co2_economise_total')  double co2EconomiseTotal, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'communaute_nom')  String communauteNom,  int objectif)  $default,) {final _that = this;
switch (_that) {
case _UtilisateurEntity():
return $default(_that.id,_that.email,_that.pseudo,_that.avatar,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.co2EconomiseTotal,_that.aAccepteCgu,_that.communauteNom,_that.objectif);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String pseudo,  String avatar,  RoleUtilisateur role, @JsonKey(name: 'etat_compte')  EtatCompte etatCompte, @JsonKey(name: 'est_compte_valide')  bool estCompteValide, @JsonKey(name: 'impact_score_xp')  int impactScoreXp, @JsonKey(name: 'co2_economise_total')  double co2EconomiseTotal, @JsonKey(name: 'a_accepte_cgu')  bool aAccepteCgu, @JsonKey(name: 'communaute_nom')  String communauteNom,  int objectif)?  $default,) {final _that = this;
switch (_that) {
case _UtilisateurEntity() when $default != null:
return $default(_that.id,_that.email,_that.pseudo,_that.avatar,_that.role,_that.etatCompte,_that.estCompteValide,_that.impactScoreXp,_that.co2EconomiseTotal,_that.aAccepteCgu,_that.communauteNom,_that.objectif);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UtilisateurEntity implements UtilisateurEntity {
  const _UtilisateurEntity({this.id = '', this.email = '', this.pseudo = '', this.avatar = '', this.role = RoleUtilisateur.utilisateur, @JsonKey(name: 'etat_compte') this.etatCompte = EtatCompte.actif, @JsonKey(name: 'est_compte_valide') this.estCompteValide = true, @JsonKey(name: 'impact_score_xp') this.impactScoreXp = 0, @JsonKey(name: 'co2_economise_total') this.co2EconomiseTotal = 0.0, @JsonKey(name: 'a_accepte_cgu') this.aAccepteCgu = false, @JsonKey(name: 'communaute_nom') this.communauteNom = '', this.objectif = -10});
  factory _UtilisateurEntity.fromJson(Map<String, dynamic> json) => _$UtilisateurEntityFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String email;
@override@JsonKey() final  String pseudo;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  RoleUtilisateur role;
@override@JsonKey(name: 'etat_compte') final  EtatCompte etatCompte;
@override@JsonKey(name: 'est_compte_valide') final  bool estCompteValide;
@override@JsonKey(name: 'impact_score_xp') final  int impactScoreXp;
@override@JsonKey(name: 'co2_economise_total') final  double co2EconomiseTotal;
@override@JsonKey(name: 'a_accepte_cgu') final  bool aAccepteCgu;
@override@JsonKey(name: 'communaute_nom') final  String communauteNom;
// Ce champ n'existe pas dans ta table SQL 'utilisateur'. 
// S'il vient d'une jointure ou d'un calcul, garde-le, sinon il sera ignoré par Supabase.
@override@JsonKey() final  int objectif;

/// Create a copy of UtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UtilisateurEntityCopyWith<_UtilisateurEntity> get copyWith => __$UtilisateurEntityCopyWithImpl<_UtilisateurEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UtilisateurEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UtilisateurEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.pseudo, pseudo) || other.pseudo == pseudo)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.role, role) || other.role == role)&&(identical(other.etatCompte, etatCompte) || other.etatCompte == etatCompte)&&(identical(other.estCompteValide, estCompteValide) || other.estCompteValide == estCompteValide)&&(identical(other.impactScoreXp, impactScoreXp) || other.impactScoreXp == impactScoreXp)&&(identical(other.co2EconomiseTotal, co2EconomiseTotal) || other.co2EconomiseTotal == co2EconomiseTotal)&&(identical(other.aAccepteCgu, aAccepteCgu) || other.aAccepteCgu == aAccepteCgu)&&(identical(other.communauteNom, communauteNom) || other.communauteNom == communauteNom)&&(identical(other.objectif, objectif) || other.objectif == objectif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,pseudo,avatar,role,etatCompte,estCompteValide,impactScoreXp,co2EconomiseTotal,aAccepteCgu,communauteNom,objectif);

@override
String toString() {
  return 'UtilisateurEntity(id: $id, email: $email, pseudo: $pseudo, avatar: $avatar, role: $role, etatCompte: $etatCompte, estCompteValide: $estCompteValide, impactScoreXp: $impactScoreXp, co2EconomiseTotal: $co2EconomiseTotal, aAccepteCgu: $aAccepteCgu, communauteNom: $communauteNom, objectif: $objectif)';
}


}

/// @nodoc
abstract mixin class _$UtilisateurEntityCopyWith<$Res> implements $UtilisateurEntityCopyWith<$Res> {
  factory _$UtilisateurEntityCopyWith(_UtilisateurEntity value, $Res Function(_UtilisateurEntity) _then) = __$UtilisateurEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String pseudo, String avatar, RoleUtilisateur role,@JsonKey(name: 'etat_compte') EtatCompte etatCompte,@JsonKey(name: 'est_compte_valide') bool estCompteValide,@JsonKey(name: 'impact_score_xp') int impactScoreXp,@JsonKey(name: 'co2_economise_total') double co2EconomiseTotal,@JsonKey(name: 'a_accepte_cgu') bool aAccepteCgu,@JsonKey(name: 'communaute_nom') String communauteNom, int objectif
});




}
/// @nodoc
class __$UtilisateurEntityCopyWithImpl<$Res>
    implements _$UtilisateurEntityCopyWith<$Res> {
  __$UtilisateurEntityCopyWithImpl(this._self, this._then);

  final _UtilisateurEntity _self;
  final $Res Function(_UtilisateurEntity) _then;

/// Create a copy of UtilisateurEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? pseudo = null,Object? avatar = null,Object? role = null,Object? etatCompte = null,Object? estCompteValide = null,Object? impactScoreXp = null,Object? co2EconomiseTotal = null,Object? aAccepteCgu = null,Object? communauteNom = null,Object? objectif = null,}) {
  return _then(_UtilisateurEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,pseudo: null == pseudo ? _self.pseudo : pseudo // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleUtilisateur,etatCompte: null == etatCompte ? _self.etatCompte : etatCompte // ignore: cast_nullable_to_non_nullable
as EtatCompte,estCompteValide: null == estCompteValide ? _self.estCompteValide : estCompteValide // ignore: cast_nullable_to_non_nullable
as bool,impactScoreXp: null == impactScoreXp ? _self.impactScoreXp : impactScoreXp // ignore: cast_nullable_to_non_nullable
as int,co2EconomiseTotal: null == co2EconomiseTotal ? _self.co2EconomiseTotal : co2EconomiseTotal // ignore: cast_nullable_to_non_nullable
as double,aAccepteCgu: null == aAccepteCgu ? _self.aAccepteCgu : aAccepteCgu // ignore: cast_nullable_to_non_nullable
as bool,communauteNom: null == communauteNom ? _self.communauteNom : communauteNom // ignore: cast_nullable_to_non_nullable
as String,objectif: null == objectif ? _self.objectif : objectif // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
