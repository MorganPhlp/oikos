// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryData {

 String get name; double get percentage; double get co2;@ColorConverter() Color get color;
/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDataCopyWith<CategoryData> get copyWith => _$CategoryDataCopyWithImpl<CategoryData>(this as CategoryData, _$identity);

  /// Serializes this CategoryData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryData&&(identical(other.name, name) || other.name == name)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.co2, co2) || other.co2 == co2)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,percentage,co2,color);

@override
String toString() {
  return 'CategoryData(name: $name, percentage: $percentage, co2: $co2, color: $color)';
}


}

/// @nodoc
abstract mixin class $CategoryDataCopyWith<$Res>  {
  factory $CategoryDataCopyWith(CategoryData value, $Res Function(CategoryData) _then) = _$CategoryDataCopyWithImpl;
@useResult
$Res call({
 String name, double percentage, double co2,@ColorConverter() Color color
});




}
/// @nodoc
class _$CategoryDataCopyWithImpl<$Res>
    implements $CategoryDataCopyWith<$Res> {
  _$CategoryDataCopyWithImpl(this._self, this._then);

  final CategoryData _self;
  final $Res Function(CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? percentage = null,Object? co2 = null,Object? color = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,co2: null == co2 ? _self.co2 : co2 // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryData].
extension CategoryDataPatterns on CategoryData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryData value)  $default,){
final _that = this;
switch (_that) {
case _CategoryData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryData value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double percentage,  double co2, @ColorConverter()  Color color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.name,_that.percentage,_that.co2,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double percentage,  double co2, @ColorConverter()  Color color)  $default,) {final _that = this;
switch (_that) {
case _CategoryData():
return $default(_that.name,_that.percentage,_that.co2,_that.color);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double percentage,  double co2, @ColorConverter()  Color color)?  $default,) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.name,_that.percentage,_that.co2,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryData implements CategoryData {
  const _CategoryData({required this.name, required this.percentage, required this.co2, @ColorConverter() required this.color});
  factory _CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);

@override final  String name;
@override final  double percentage;
@override final  double co2;
@override@ColorConverter() final  Color color;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDataCopyWith<_CategoryData> get copyWith => __$CategoryDataCopyWithImpl<_CategoryData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryData&&(identical(other.name, name) || other.name == name)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.co2, co2) || other.co2 == co2)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,percentage,co2,color);

@override
String toString() {
  return 'CategoryData(name: $name, percentage: $percentage, co2: $co2, color: $color)';
}


}

/// @nodoc
abstract mixin class _$CategoryDataCopyWith<$Res> implements $CategoryDataCopyWith<$Res> {
  factory _$CategoryDataCopyWith(_CategoryData value, $Res Function(_CategoryData) _then) = __$CategoryDataCopyWithImpl;
@override @useResult
$Res call({
 String name, double percentage, double co2,@ColorConverter() Color color
});




}
/// @nodoc
class __$CategoryDataCopyWithImpl<$Res>
    implements _$CategoryDataCopyWith<$Res> {
  __$CategoryDataCopyWithImpl(this._self, this._then);

  final _CategoryData _self;
  final $Res Function(_CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? percentage = null,Object? co2 = null,Object? color = null,}) {
  return _then(_CategoryData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,co2: null == co2 ? _self.co2 : co2 // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
