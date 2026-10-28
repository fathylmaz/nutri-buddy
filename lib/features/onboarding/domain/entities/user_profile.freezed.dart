// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserProfile {

 String get id; String? get displayName; String? get sexForCalculation; DateTime? get birthDate; double? get heightCm; double? get weightKg; double? get targetWeightKg; String? get goal; String? get activityLevel; List<String> get allergies; List<String> get chronicConditions; String get timezone; DateTime get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.sexForCalculation, _this.sexForCalculation) || other.sexForCalculation == _this.sexForCalculation)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.targetWeightKg, _this.targetWeightKg) || other.targetWeightKg == _this.targetWeightKg)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.activityLevel, _this.activityLevel) || other.activityLevel == _this.activityLevel)&&const DeepCollectionEquality().equals(other.allergies, _this.allergies)&&const DeepCollectionEquality().equals(other.chronicConditions, _this.chronicConditions)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.sexForCalculation,_this.birthDate,_this.heightCm,_this.weightKg,_this.targetWeightKg,_this.goal,_this.activityLevel,const DeepCollectionEquality().hash(_this.allergies),const DeepCollectionEquality().hash(_this.chronicConditions),_this.timezone,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, displayName: ${_this.displayName}, sexForCalculation: ${_this.sexForCalculation}, birthDate: ${_this.birthDate}, heightCm: ${_this.heightCm}, weightKg: ${_this.weightKg}, targetWeightKg: ${_this.targetWeightKg}, goal: ${_this.goal}, activityLevel: ${_this.activityLevel}, allergies: ${_this.allergies}, chronicConditions: ${_this.chronicConditions}, timezone: ${_this.timezone}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String? displayName, String? sexForCalculation, DateTime? birthDate, double? heightCm, double? weightKg, double? targetWeightKg, String? goal, String? activityLevel, List<String> allergies, List<String> chronicConditions, String timezone, DateTime updatedAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? sexForCalculation = freezed,Object? birthDate = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? targetWeightKg = freezed,Object? goal = freezed,Object? activityLevel = freezed,Object? allergies = null,Object? chronicConditions = null,Object? timezone = null,Object? updatedAt = null,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,sexForCalculation: freezed == sexForCalculation ? _self.sexForCalculation : sexForCalculation // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,chronicConditions: null == chronicConditions ? _self.chronicConditions : chronicConditions // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayName,  String? sexForCalculation,  DateTime? birthDate,  double? heightCm,  double? weightKg,  double? targetWeightKg,  String? goal,  String? activityLevel,  List<String> allergies,  List<String> chronicConditions,  String timezone,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.sexForCalculation,_that.birthDate,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.goal,_that.activityLevel,_that.allergies,_that.chronicConditions,_that.timezone,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayName,  String? sexForCalculation,  DateTime? birthDate,  double? heightCm,  double? weightKg,  double? targetWeightKg,  String? goal,  String? activityLevel,  List<String> allergies,  List<String> chronicConditions,  String timezone,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.displayName,_that.sexForCalculation,_that.birthDate,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.goal,_that.activityLevel,_that.allergies,_that.chronicConditions,_that.timezone,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayName,  String? sexForCalculation,  DateTime? birthDate,  double? heightCm,  double? weightKg,  double? targetWeightKg,  String? goal,  String? activityLevel,  List<String> allergies,  List<String> chronicConditions,  String timezone,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.displayName,_that.sexForCalculation,_that.birthDate,_that.heightCm,_that.weightKg,_that.targetWeightKg,_that.goal,_that.activityLevel,_that.allergies,_that.chronicConditions,_that.timezone,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, this.displayName, this.sexForCalculation, this.birthDate, this.heightCm, this.weightKg, this.targetWeightKg, this.goal, this.activityLevel,  List<String> allergies = const <String>[],  List<String> chronicConditions = const <String>[], this.timezone = 'UTC', required this.updatedAt}): _allergies = allergies,_chronicConditions = chronicConditions;
  

@override final  String id;
@override final  String? displayName;
@override final  String? sexForCalculation;
@override final  DateTime? birthDate;
@override final  double? heightCm;
@override final  double? weightKg;
@override final  double? targetWeightKg;
@override final  String? goal;
@override final  String? activityLevel;
 final  List<String> _allergies;
@override@JsonKey() List<String> get allergies {
  if (_allergies is EqualUnmodifiableListView) return _allergies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergies);
}

 final  List<String> _chronicConditions;
@override@JsonKey() List<String> get chronicConditions {
  if (_chronicConditions is EqualUnmodifiableListView) return _chronicConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chronicConditions);
}

@override@JsonKey() final  String timezone;
@override final  DateTime updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.sexForCalculation, sexForCalculation) || other.sexForCalculation == sexForCalculation)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.targetWeightKg, targetWeightKg) || other.targetWeightKg == targetWeightKg)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.activityLevel, activityLevel) || other.activityLevel == activityLevel)&&const DeepCollectionEquality().equals(other.allergies, _allergies)&&const DeepCollectionEquality().equals(other.chronicConditions, _chronicConditions)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,sexForCalculation,birthDate,heightCm,weightKg,targetWeightKg,goal,activityLevel,const DeepCollectionEquality().hash(_allergies),const DeepCollectionEquality().hash(_chronicConditions),timezone,updatedAt);
}

@override
String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, sexForCalculation: $sexForCalculation, birthDate: $birthDate, heightCm: $heightCm, weightKg: $weightKg, targetWeightKg: $targetWeightKg, goal: $goal, activityLevel: $activityLevel, allergies: $allergies, chronicConditions: $chronicConditions, timezone: $timezone, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayName, String? sexForCalculation, DateTime? birthDate, double? heightCm, double? weightKg, double? targetWeightKg, String? goal, String? activityLevel, List<String> allergies, List<String> chronicConditions, String timezone, DateTime updatedAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? sexForCalculation = freezed,Object? birthDate = freezed,Object? heightCm = freezed,Object? weightKg = freezed,Object? targetWeightKg = freezed,Object? goal = freezed,Object? activityLevel = freezed,Object? allergies = null,Object? chronicConditions = null,Object? timezone = null,Object? updatedAt = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,sexForCalculation: freezed == sexForCalculation ? _self.sexForCalculation : sexForCalculation // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,targetWeightKg: freezed == targetWeightKg ? _self.targetWeightKg : targetWeightKg // ignore: cast_nullable_to_non_nullable
as double?,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,activityLevel: freezed == activityLevel ? _self.activityLevel : activityLevel // ignore: cast_nullable_to_non_nullable
as String?,allergies: null == allergies ? _self._allergies : allergies // ignore: cast_nullable_to_non_nullable
as List<String>,chronicConditions: null == chronicConditions ? _self._chronicConditions : chronicConditions // ignore: cast_nullable_to_non_nullable
as List<String>,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
