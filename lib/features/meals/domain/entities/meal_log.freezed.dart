// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealLog {

 String get id; String get userId; DateTime get loggedAt; String get name; String get mealType; String get source; int get caloriesKcal; double get proteinG; double get carbsG; double get fatG; double get fiberG; bool get isEstimate; VisionMealAnalysis? get visionAnalysis;/// JSON snapshot of an accepted AI recipe; null for other meal sources.
 String? get recipeDetailsJson; bool get isDeleted; DateTime get updatedAt;
/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLogCopyWith<MealLog> get copyWith => _$MealLogCopyWithImpl<MealLog>(this as MealLog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MealLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.loggedAt, _this.loggedAt) || other.loggedAt == _this.loggedAt)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.mealType, _this.mealType) || other.mealType == _this.mealType)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.caloriesKcal, _this.caloriesKcal) || other.caloriesKcal == _this.caloriesKcal)&&(identical(other.proteinG, _this.proteinG) || other.proteinG == _this.proteinG)&&(identical(other.carbsG, _this.carbsG) || other.carbsG == _this.carbsG)&&(identical(other.fatG, _this.fatG) || other.fatG == _this.fatG)&&(identical(other.fiberG, _this.fiberG) || other.fiberG == _this.fiberG)&&(identical(other.isEstimate, _this.isEstimate) || other.isEstimate == _this.isEstimate)&&(identical(other.visionAnalysis, _this.visionAnalysis) || other.visionAnalysis == _this.visionAnalysis)&&(identical(other.recipeDetailsJson, _this.recipeDetailsJson) || other.recipeDetailsJson == _this.recipeDetailsJson)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as MealLog;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.loggedAt,_this.name,_this.mealType,_this.source,_this.caloriesKcal,_this.proteinG,_this.carbsG,_this.fatG,_this.fiberG,_this.isEstimate,_this.visionAnalysis,_this.recipeDetailsJson,_this.isDeleted,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MealLog;
  return 'MealLog(id: ${_this.id}, userId: ${_this.userId}, loggedAt: ${_this.loggedAt}, name: ${_this.name}, mealType: ${_this.mealType}, source: ${_this.source}, caloriesKcal: ${_this.caloriesKcal}, proteinG: ${_this.proteinG}, carbsG: ${_this.carbsG}, fatG: ${_this.fatG}, fiberG: ${_this.fiberG}, isEstimate: ${_this.isEstimate}, visionAnalysis: ${_this.visionAnalysis}, recipeDetailsJson: ${_this.recipeDetailsJson}, isDeleted: ${_this.isDeleted}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MealLogCopyWith<$Res>  {
  factory $MealLogCopyWith(MealLog value, $Res Function(MealLog) _then) = _$MealLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime loggedAt, String name, String mealType, String source, int caloriesKcal, double proteinG, double carbsG, double fatG, double fiberG, bool isEstimate, VisionMealAnalysis? visionAnalysis, String? recipeDetailsJson, bool isDeleted, DateTime updatedAt
});




}
/// @nodoc
class _$MealLogCopyWithImpl<$Res>
    implements $MealLogCopyWith<$Res> {
  _$MealLogCopyWithImpl(this._self, this._then);

  final MealLog _self;
  final $Res Function(MealLog) _then;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? loggedAt = null,Object? name = null,Object? mealType = null,Object? source = null,Object? caloriesKcal = null,Object? proteinG = null,Object? carbsG = null,Object? fatG = null,Object? fiberG = null,Object? isEstimate = null,Object? visionAnalysis = freezed,Object? recipeDetailsJson = freezed,Object? isDeleted = null,Object? updatedAt = null,}) {
  return _then(MealLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,caloriesKcal: null == caloriesKcal ? _self.caloriesKcal : caloriesKcal // ignore: cast_nullable_to_non_nullable
as int,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double,fiberG: null == fiberG ? _self.fiberG : fiberG // ignore: cast_nullable_to_non_nullable
as double,isEstimate: null == isEstimate ? _self.isEstimate : isEstimate // ignore: cast_nullable_to_non_nullable
as bool,visionAnalysis: freezed == visionAnalysis ? _self.visionAnalysis : visionAnalysis // ignore: cast_nullable_to_non_nullable
as VisionMealAnalysis?,recipeDetailsJson: freezed == recipeDetailsJson ? _self.recipeDetailsJson : recipeDetailsJson // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MealLog].
extension MealLogPatterns on MealLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealLog value)  $default,){
final _that = this;
switch (_that) {
case _MealLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealLog value)?  $default,){
final _that = this;
switch (_that) {
case _MealLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime loggedAt,  String name,  String mealType,  String source,  int caloriesKcal,  double proteinG,  double carbsG,  double fatG,  double fiberG,  bool isEstimate,  VisionMealAnalysis? visionAnalysis,  String? recipeDetailsJson,  bool isDeleted,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealLog() when $default != null:
return $default(_that.id,_that.userId,_that.loggedAt,_that.name,_that.mealType,_that.source,_that.caloriesKcal,_that.proteinG,_that.carbsG,_that.fatG,_that.fiberG,_that.isEstimate,_that.visionAnalysis,_that.recipeDetailsJson,_that.isDeleted,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime loggedAt,  String name,  String mealType,  String source,  int caloriesKcal,  double proteinG,  double carbsG,  double fatG,  double fiberG,  bool isEstimate,  VisionMealAnalysis? visionAnalysis,  String? recipeDetailsJson,  bool isDeleted,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MealLog():
return $default(_that.id,_that.userId,_that.loggedAt,_that.name,_that.mealType,_that.source,_that.caloriesKcal,_that.proteinG,_that.carbsG,_that.fatG,_that.fiberG,_that.isEstimate,_that.visionAnalysis,_that.recipeDetailsJson,_that.isDeleted,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime loggedAt,  String name,  String mealType,  String source,  int caloriesKcal,  double proteinG,  double carbsG,  double fatG,  double fiberG,  bool isEstimate,  VisionMealAnalysis? visionAnalysis,  String? recipeDetailsJson,  bool isDeleted,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MealLog() when $default != null:
return $default(_that.id,_that.userId,_that.loggedAt,_that.name,_that.mealType,_that.source,_that.caloriesKcal,_that.proteinG,_that.carbsG,_that.fatG,_that.fiberG,_that.isEstimate,_that.visionAnalysis,_that.recipeDetailsJson,_that.isDeleted,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MealLog implements MealLog {
  const _MealLog({required this.id, required this.userId, required this.loggedAt, required this.name, this.mealType = 'other', this.source = 'manual', this.caloriesKcal = 0, this.proteinG = 0, this.carbsG = 0, this.fatG = 0, this.fiberG = 0, this.isEstimate = true, this.visionAnalysis, this.recipeDetailsJson, this.isDeleted = false, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override final  DateTime loggedAt;
@override final  String name;
@override@JsonKey() final  String mealType;
@override@JsonKey() final  String source;
@override@JsonKey() final  int caloriesKcal;
@override@JsonKey() final  double proteinG;
@override@JsonKey() final  double carbsG;
@override@JsonKey() final  double fatG;
@override@JsonKey() final  double fiberG;
@override@JsonKey() final  bool isEstimate;
@override final  VisionMealAnalysis? visionAnalysis;
/// JSON snapshot of an accepted AI recipe; null for other meal sources.
@override final  String? recipeDetailsJson;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime updatedAt;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealLogCopyWith<_MealLog> get copyWith => __$MealLogCopyWithImpl<_MealLog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.mealType, mealType) || other.mealType == mealType)&&(identical(other.source, source) || other.source == source)&&(identical(other.caloriesKcal, caloriesKcal) || other.caloriesKcal == caloriesKcal)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.fiberG, fiberG) || other.fiberG == fiberG)&&(identical(other.isEstimate, isEstimate) || other.isEstimate == isEstimate)&&(identical(other.visionAnalysis, visionAnalysis) || other.visionAnalysis == visionAnalysis)&&(identical(other.recipeDetailsJson, recipeDetailsJson) || other.recipeDetailsJson == recipeDetailsJson)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,loggedAt,name,mealType,source,caloriesKcal,proteinG,carbsG,fatG,fiberG,isEstimate,visionAnalysis,recipeDetailsJson,isDeleted,updatedAt);
}

@override
String toString() {
    return 'MealLog(id: $id, userId: $userId, loggedAt: $loggedAt, name: $name, mealType: $mealType, source: $source, caloriesKcal: $caloriesKcal, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, fiberG: $fiberG, isEstimate: $isEstimate, visionAnalysis: $visionAnalysis, recipeDetailsJson: $recipeDetailsJson, isDeleted: $isDeleted, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MealLogCopyWith<$Res> implements $MealLogCopyWith<$Res> {
  factory _$MealLogCopyWith(_MealLog value, $Res Function(_MealLog) _then) = __$MealLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime loggedAt, String name, String mealType, String source, int caloriesKcal, double proteinG, double carbsG, double fatG, double fiberG, bool isEstimate, VisionMealAnalysis? visionAnalysis, String? recipeDetailsJson, bool isDeleted, DateTime updatedAt
});




}
/// @nodoc
class __$MealLogCopyWithImpl<$Res>
    implements _$MealLogCopyWith<$Res> {
  __$MealLogCopyWithImpl(this._self, this._then);

  final _MealLog _self;
  final $Res Function(_MealLog) _then;

/// Create a copy of MealLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? loggedAt = null,Object? name = null,Object? mealType = null,Object? source = null,Object? caloriesKcal = null,Object? proteinG = null,Object? carbsG = null,Object? fatG = null,Object? fiberG = null,Object? isEstimate = null,Object? visionAnalysis = freezed,Object? recipeDetailsJson = freezed,Object? isDeleted = null,Object? updatedAt = null,}) {
  return _then(_MealLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mealType: null == mealType ? _self.mealType : mealType // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,caloriesKcal: null == caloriesKcal ? _self.caloriesKcal : caloriesKcal // ignore: cast_nullable_to_non_nullable
as int,proteinG: null == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double,carbsG: null == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double,fatG: null == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double,fiberG: null == fiberG ? _self.fiberG : fiberG // ignore: cast_nullable_to_non_nullable
as double,isEstimate: null == isEstimate ? _self.isEstimate : isEstimate // ignore: cast_nullable_to_non_nullable
as bool,visionAnalysis: freezed == visionAnalysis ? _self.visionAnalysis : visionAnalysis // ignore: cast_nullable_to_non_nullable
as VisionMealAnalysis?,recipeDetailsJson: freezed == recipeDetailsJson ? _self.recipeDetailsJson : recipeDetailsJson // ignore: cast_nullable_to_non_nullable
as String?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
