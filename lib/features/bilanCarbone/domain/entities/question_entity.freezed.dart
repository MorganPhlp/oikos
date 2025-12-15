// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionBilanEntity {

 int get id;// C'est ce que Publicodes utilise pour identifier la variable.
 String get slug; String get question;// Mapping vers la colonne SQL
// Vérifiez si votre colonne s'appelle "categorieEmpreinte" ou "categorieempreinte"
@JsonKey(name: 'categorie_empreinte') String get categorieEmpreinte;// L'icône (emoji ou chemin)
 String? get icone;// Utilisation de l'Enum pour la sécurité
// unknownEnumValue: évite le crash si la DB a une valeur inconnue
@JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre) TypeWidget get typeWidget;@JsonKey(name: 'config_json') Map<String, dynamic> get config;@JsonKey(name: 'ordre_affichage') int get ordre;
/// Create a copy of QuestionBilanEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionBilanEntityCopyWith<QuestionBilanEntity> get copyWith => _$QuestionBilanEntityCopyWithImpl<QuestionBilanEntity>(this as QuestionBilanEntity, _$identity);

  /// Serializes this QuestionBilanEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionBilanEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.question, question) || other.question == question)&&(identical(other.categorieEmpreinte, categorieEmpreinte) || other.categorieEmpreinte == categorieEmpreinte)&&(identical(other.icone, icone) || other.icone == icone)&&(identical(other.typeWidget, typeWidget) || other.typeWidget == typeWidget)&&const DeepCollectionEquality().equals(other.config, config)&&(identical(other.ordre, ordre) || other.ordre == ordre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,question,categorieEmpreinte,icone,typeWidget,const DeepCollectionEquality().hash(config),ordre);

@override
String toString() {
  return 'QuestionBilanEntity(id: $id, slug: $slug, question: $question, categorieEmpreinte: $categorieEmpreinte, icone: $icone, typeWidget: $typeWidget, config: $config, ordre: $ordre)';
}


}

/// @nodoc
abstract mixin class $QuestionBilanEntityCopyWith<$Res>  {
  factory $QuestionBilanEntityCopyWith(QuestionBilanEntity value, $Res Function(QuestionBilanEntity) _then) = _$QuestionBilanEntityCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String question,@JsonKey(name: 'categorie_empreinte') String categorieEmpreinte, String? icone,@JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre) TypeWidget typeWidget,@JsonKey(name: 'config_json') Map<String, dynamic> config,@JsonKey(name: 'ordre_affichage') int ordre
});




}
/// @nodoc
class _$QuestionBilanEntityCopyWithImpl<$Res>
    implements $QuestionBilanEntityCopyWith<$Res> {
  _$QuestionBilanEntityCopyWithImpl(this._self, this._then);

  final QuestionBilanEntity _self;
  final $Res Function(QuestionBilanEntity) _then;

/// Create a copy of QuestionBilanEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? question = null,Object? categorieEmpreinte = null,Object? icone = freezed,Object? typeWidget = null,Object? config = null,Object? ordre = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,categorieEmpreinte: null == categorieEmpreinte ? _self.categorieEmpreinte : categorieEmpreinte // ignore: cast_nullable_to_non_nullable
as String,icone: freezed == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String?,typeWidget: null == typeWidget ? _self.typeWidget : typeWidget // ignore: cast_nullable_to_non_nullable
as TypeWidget,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ordre: null == ordre ? _self.ordre : ordre // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionBilanEntity].
extension QuestionBilanEntityPatterns on QuestionBilanEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionBilanEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionBilanEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionBilanEntity value)  $default,){
final _that = this;
switch (_that) {
case _QuestionBilanEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionBilanEntity value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionBilanEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String question, @JsonKey(name: 'categorie_empreinte')  String categorieEmpreinte,  String? icone, @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre)  TypeWidget typeWidget, @JsonKey(name: 'config_json')  Map<String, dynamic> config, @JsonKey(name: 'ordre_affichage')  int ordre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionBilanEntity() when $default != null:
return $default(_that.id,_that.slug,_that.question,_that.categorieEmpreinte,_that.icone,_that.typeWidget,_that.config,_that.ordre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String question, @JsonKey(name: 'categorie_empreinte')  String categorieEmpreinte,  String? icone, @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre)  TypeWidget typeWidget, @JsonKey(name: 'config_json')  Map<String, dynamic> config, @JsonKey(name: 'ordre_affichage')  int ordre)  $default,) {final _that = this;
switch (_that) {
case _QuestionBilanEntity():
return $default(_that.id,_that.slug,_that.question,_that.categorieEmpreinte,_that.icone,_that.typeWidget,_that.config,_that.ordre);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String question, @JsonKey(name: 'categorie_empreinte')  String categorieEmpreinte,  String? icone, @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre)  TypeWidget typeWidget, @JsonKey(name: 'config_json')  Map<String, dynamic> config, @JsonKey(name: 'ordre_affichage')  int ordre)?  $default,) {final _that = this;
switch (_that) {
case _QuestionBilanEntity() when $default != null:
return $default(_that.id,_that.slug,_that.question,_that.categorieEmpreinte,_that.icone,_that.typeWidget,_that.config,_that.ordre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionBilanEntity extends QuestionBilanEntity {
  const _QuestionBilanEntity({this.id = 0, this.slug = '', this.question = '', @JsonKey(name: 'categorie_empreinte') this.categorieEmpreinte = '', this.icone = '', @JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre) this.typeWidget = TypeWidget.nombre, @JsonKey(name: 'config_json') final  Map<String, dynamic> config = const {}, @JsonKey(name: 'ordre_affichage') this.ordre = 0}): _config = config,super._();
  factory _QuestionBilanEntity.fromJson(Map<String, dynamic> json) => _$QuestionBilanEntityFromJson(json);

@override@JsonKey() final  int id;
// C'est ce que Publicodes utilise pour identifier la variable.
@override@JsonKey() final  String slug;
@override@JsonKey() final  String question;
// Mapping vers la colonne SQL
// Vérifiez si votre colonne s'appelle "categorieEmpreinte" ou "categorieempreinte"
@override@JsonKey(name: 'categorie_empreinte') final  String categorieEmpreinte;
// L'icône (emoji ou chemin)
@override@JsonKey() final  String? icone;
// Utilisation de l'Enum pour la sécurité
// unknownEnumValue: évite le crash si la DB a une valeur inconnue
@override@JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre) final  TypeWidget typeWidget;
 final  Map<String, dynamic> _config;
@override@JsonKey(name: 'config_json') Map<String, dynamic> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

@override@JsonKey(name: 'ordre_affichage') final  int ordre;

/// Create a copy of QuestionBilanEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionBilanEntityCopyWith<_QuestionBilanEntity> get copyWith => __$QuestionBilanEntityCopyWithImpl<_QuestionBilanEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionBilanEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionBilanEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.question, question) || other.question == question)&&(identical(other.categorieEmpreinte, categorieEmpreinte) || other.categorieEmpreinte == categorieEmpreinte)&&(identical(other.icone, icone) || other.icone == icone)&&(identical(other.typeWidget, typeWidget) || other.typeWidget == typeWidget)&&const DeepCollectionEquality().equals(other._config, _config)&&(identical(other.ordre, ordre) || other.ordre == ordre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,question,categorieEmpreinte,icone,typeWidget,const DeepCollectionEquality().hash(_config),ordre);

@override
String toString() {
  return 'QuestionBilanEntity(id: $id, slug: $slug, question: $question, categorieEmpreinte: $categorieEmpreinte, icone: $icone, typeWidget: $typeWidget, config: $config, ordre: $ordre)';
}


}

/// @nodoc
abstract mixin class _$QuestionBilanEntityCopyWith<$Res> implements $QuestionBilanEntityCopyWith<$Res> {
  factory _$QuestionBilanEntityCopyWith(_QuestionBilanEntity value, $Res Function(_QuestionBilanEntity) _then) = __$QuestionBilanEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String question,@JsonKey(name: 'categorie_empreinte') String categorieEmpreinte, String? icone,@JsonKey(name: 'type_widget', unknownEnumValue: TypeWidget.nombre) TypeWidget typeWidget,@JsonKey(name: 'config_json') Map<String, dynamic> config,@JsonKey(name: 'ordre_affichage') int ordre
});




}
/// @nodoc
class __$QuestionBilanEntityCopyWithImpl<$Res>
    implements _$QuestionBilanEntityCopyWith<$Res> {
  __$QuestionBilanEntityCopyWithImpl(this._self, this._then);

  final _QuestionBilanEntity _self;
  final $Res Function(_QuestionBilanEntity) _then;

/// Create a copy of QuestionBilanEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? question = null,Object? categorieEmpreinte = null,Object? icone = freezed,Object? typeWidget = null,Object? config = null,Object? ordre = null,}) {
  return _then(_QuestionBilanEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,categorieEmpreinte: null == categorieEmpreinte ? _self.categorieEmpreinte : categorieEmpreinte // ignore: cast_nullable_to_non_nullable
as String,icone: freezed == icone ? _self.icone : icone // ignore: cast_nullable_to_non_nullable
as String?,typeWidget: null == typeWidget ? _self.typeWidget : typeWidget // ignore: cast_nullable_to_non_nullable
as TypeWidget,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,ordre: null == ordre ? _self.ordre : ordre // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
