// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_bilan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DetailBilanModel {

 int get id; double get transport; double get alimentation; double get logement; double get divers;@JsonKey(name: 'services_societaux') double get servicesSocietaux;
/// Create a copy of DetailBilanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailBilanModelCopyWith<DetailBilanModel> get copyWith => _$DetailBilanModelCopyWithImpl<DetailBilanModel>(this as DetailBilanModel, _$identity);

  /// Serializes this DetailBilanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailBilanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transport, transport) || other.transport == transport)&&(identical(other.alimentation, alimentation) || other.alimentation == alimentation)&&(identical(other.logement, logement) || other.logement == logement)&&(identical(other.divers, divers) || other.divers == divers)&&(identical(other.servicesSocietaux, servicesSocietaux) || other.servicesSocietaux == servicesSocietaux));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transport,alimentation,logement,divers,servicesSocietaux);

@override
String toString() {
  return 'DetailBilanModel(id: $id, transport: $transport, alimentation: $alimentation, logement: $logement, divers: $divers, servicesSocietaux: $servicesSocietaux)';
}


}

/// @nodoc
abstract mixin class $DetailBilanModelCopyWith<$Res>  {
  factory $DetailBilanModelCopyWith(DetailBilanModel value, $Res Function(DetailBilanModel) _then) = _$DetailBilanModelCopyWithImpl;
@useResult
$Res call({
 int id, double transport, double alimentation, double logement, double divers,@JsonKey(name: 'services_societaux') double servicesSocietaux
});




}
/// @nodoc
class _$DetailBilanModelCopyWithImpl<$Res>
    implements $DetailBilanModelCopyWith<$Res> {
  _$DetailBilanModelCopyWithImpl(this._self, this._then);

  final DetailBilanModel _self;
  final $Res Function(DetailBilanModel) _then;

/// Create a copy of DetailBilanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transport = null,Object? alimentation = null,Object? logement = null,Object? divers = null,Object? servicesSocietaux = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,transport: null == transport ? _self.transport : transport // ignore: cast_nullable_to_non_nullable
as double,alimentation: null == alimentation ? _self.alimentation : alimentation // ignore: cast_nullable_to_non_nullable
as double,logement: null == logement ? _self.logement : logement // ignore: cast_nullable_to_non_nullable
as double,divers: null == divers ? _self.divers : divers // ignore: cast_nullable_to_non_nullable
as double,servicesSocietaux: null == servicesSocietaux ? _self.servicesSocietaux : servicesSocietaux // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DetailBilanModel].
extension DetailBilanModelPatterns on DetailBilanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailBilanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailBilanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailBilanModel value)  $default,){
final _that = this;
switch (_that) {
case _DetailBilanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailBilanModel value)?  $default,){
final _that = this;
switch (_that) {
case _DetailBilanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  double transport,  double alimentation,  double logement,  double divers, @JsonKey(name: 'services_societaux')  double servicesSocietaux)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailBilanModel() when $default != null:
return $default(_that.id,_that.transport,_that.alimentation,_that.logement,_that.divers,_that.servicesSocietaux);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  double transport,  double alimentation,  double logement,  double divers, @JsonKey(name: 'services_societaux')  double servicesSocietaux)  $default,) {final _that = this;
switch (_that) {
case _DetailBilanModel():
return $default(_that.id,_that.transport,_that.alimentation,_that.logement,_that.divers,_that.servicesSocietaux);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  double transport,  double alimentation,  double logement,  double divers, @JsonKey(name: 'services_societaux')  double servicesSocietaux)?  $default,) {final _that = this;
switch (_that) {
case _DetailBilanModel() when $default != null:
return $default(_that.id,_that.transport,_that.alimentation,_that.logement,_that.divers,_that.servicesSocietaux);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DetailBilanModel extends DetailBilanModel {
  const _DetailBilanModel({this.id = 0, this.transport = 0.0, this.alimentation = 0.0, this.logement = 0.0, this.divers = 0.0, @JsonKey(name: 'services_societaux') this.servicesSocietaux = 0.0}): super._();
  factory _DetailBilanModel.fromJson(Map<String, dynamic> json) => _$DetailBilanModelFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  double transport;
@override@JsonKey() final  double alimentation;
@override@JsonKey() final  double logement;
@override@JsonKey() final  double divers;
@override@JsonKey(name: 'services_societaux') final  double servicesSocietaux;

/// Create a copy of DetailBilanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailBilanModelCopyWith<_DetailBilanModel> get copyWith => __$DetailBilanModelCopyWithImpl<_DetailBilanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DetailBilanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailBilanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transport, transport) || other.transport == transport)&&(identical(other.alimentation, alimentation) || other.alimentation == alimentation)&&(identical(other.logement, logement) || other.logement == logement)&&(identical(other.divers, divers) || other.divers == divers)&&(identical(other.servicesSocietaux, servicesSocietaux) || other.servicesSocietaux == servicesSocietaux));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transport,alimentation,logement,divers,servicesSocietaux);

@override
String toString() {
  return 'DetailBilanModel(id: $id, transport: $transport, alimentation: $alimentation, logement: $logement, divers: $divers, servicesSocietaux: $servicesSocietaux)';
}


}

/// @nodoc
abstract mixin class _$DetailBilanModelCopyWith<$Res> implements $DetailBilanModelCopyWith<$Res> {
  factory _$DetailBilanModelCopyWith(_DetailBilanModel value, $Res Function(_DetailBilanModel) _then) = __$DetailBilanModelCopyWithImpl;
@override @useResult
$Res call({
 int id, double transport, double alimentation, double logement, double divers,@JsonKey(name: 'services_societaux') double servicesSocietaux
});




}
/// @nodoc
class __$DetailBilanModelCopyWithImpl<$Res>
    implements _$DetailBilanModelCopyWith<$Res> {
  __$DetailBilanModelCopyWithImpl(this._self, this._then);

  final _DetailBilanModel _self;
  final $Res Function(_DetailBilanModel) _then;

/// Create a copy of DetailBilanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transport = null,Object? alimentation = null,Object? logement = null,Object? divers = null,Object? servicesSocietaux = null,}) {
  return _then(_DetailBilanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,transport: null == transport ? _self.transport : transport // ignore: cast_nullable_to_non_nullable
as double,alimentation: null == alimentation ? _self.alimentation : alimentation // ignore: cast_nullable_to_non_nullable
as double,logement: null == logement ? _self.logement : logement // ignore: cast_nullable_to_non_nullable
as double,divers: null == divers ? _self.divers : divers // ignore: cast_nullable_to_non_nullable
as double,servicesSocietaux: null == servicesSocietaux ? _self.servicesSocietaux : servicesSocietaux // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
