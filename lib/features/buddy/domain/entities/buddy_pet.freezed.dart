// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'buddy_pet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BuddyPet {

 String get id; String get userId; String get mood; int get xp; int get gold; int get level; int get streakDays; DateTime get updatedAt;
/// Create a copy of BuddyPet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuddyPetCopyWith<BuddyPet> get copyWith => _$BuddyPetCopyWithImpl<BuddyPet>(this as BuddyPet, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BuddyPet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuddyPet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.mood, _this.mood) || other.mood == _this.mood)&&(identical(other.xp, _this.xp) || other.xp == _this.xp)&&(identical(other.gold, _this.gold) || other.gold == _this.gold)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as BuddyPet;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.mood,_this.xp,_this.gold,_this.level,_this.streakDays,_this.updatedAt);
}

@override
String toString() {
  final _this = this as BuddyPet;
  return 'BuddyPet(id: ${_this.id}, userId: ${_this.userId}, mood: ${_this.mood}, xp: ${_this.xp}, gold: ${_this.gold}, level: ${_this.level}, streakDays: ${_this.streakDays}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $BuddyPetCopyWith<$Res>  {
  factory $BuddyPetCopyWith(BuddyPet value, $Res Function(BuddyPet) _then) = _$BuddyPetCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String mood, int xp, int gold, int level, int streakDays, DateTime updatedAt
});




}
/// @nodoc
class _$BuddyPetCopyWithImpl<$Res>
    implements $BuddyPetCopyWith<$Res> {
  _$BuddyPetCopyWithImpl(this._self, this._then);

  final BuddyPet _self;
  final $Res Function(BuddyPet) _then;

/// Create a copy of BuddyPet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? xp = null,Object? gold = null,Object? level = null,Object? streakDays = null,Object? updatedAt = null,}) {
  return _then(BuddyPet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BuddyPet].
extension BuddyPetPatterns on BuddyPet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuddyPet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuddyPet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuddyPet value)  $default,){
final _that = this;
switch (_that) {
case _BuddyPet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuddyPet value)?  $default,){
final _that = this;
switch (_that) {
case _BuddyPet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String mood,  int xp,  int gold,  int level,  int streakDays,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuddyPet() when $default != null:
return $default(_that.id,_that.userId,_that.mood,_that.xp,_that.gold,_that.level,_that.streakDays,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String mood,  int xp,  int gold,  int level,  int streakDays,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BuddyPet():
return $default(_that.id,_that.userId,_that.mood,_that.xp,_that.gold,_that.level,_that.streakDays,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String mood,  int xp,  int gold,  int level,  int streakDays,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BuddyPet() when $default != null:
return $default(_that.id,_that.userId,_that.mood,_that.xp,_that.gold,_that.level,_that.streakDays,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BuddyPet implements BuddyPet {
  const _BuddyPet({required this.id, required this.userId, this.mood = 'neutral', this.xp = 0, this.gold = 0, this.level = 1, this.streakDays = 0, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override@JsonKey() final  String mood;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int gold;
@override@JsonKey() final  int level;
@override@JsonKey() final  int streakDays;
@override final  DateTime updatedAt;

/// Create a copy of BuddyPet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuddyPetCopyWith<_BuddyPet> get copyWith => __$BuddyPetCopyWithImpl<_BuddyPet>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuddyPet&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.gold, gold) || other.gold == gold)&&(identical(other.level, level) || other.level == level)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,mood,xp,gold,level,streakDays,updatedAt);
}

@override
String toString() {
    return 'BuddyPet(id: $id, userId: $userId, mood: $mood, xp: $xp, gold: $gold, level: $level, streakDays: $streakDays, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BuddyPetCopyWith<$Res> implements $BuddyPetCopyWith<$Res> {
  factory _$BuddyPetCopyWith(_BuddyPet value, $Res Function(_BuddyPet) _then) = __$BuddyPetCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String mood, int xp, int gold, int level, int streakDays, DateTime updatedAt
});




}
/// @nodoc
class __$BuddyPetCopyWithImpl<$Res>
    implements _$BuddyPetCopyWith<$Res> {
  __$BuddyPetCopyWithImpl(this._self, this._then);

  final _BuddyPet _self;
  final $Res Function(_BuddyPet) _then;

/// Create a copy of BuddyPet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? mood = null,Object? xp = null,Object? gold = null,Object? level = null,Object? streakDays = null,Object? updatedAt = null,}) {
  return _then(_BuddyPet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,gold: null == gold ? _self.gold : gold // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
