// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaterEntry {

 String get id; String get userId; int get amountMl; DateTime get recordedAt; DateTime get updatedAt; bool get isDeleted;
/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterEntryCopyWith<WaterEntry> get copyWith => _$WaterEntryCopyWithImpl<WaterEntry>(this as WaterEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WaterEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.amountMl, _this.amountMl) || other.amountMl == _this.amountMl)&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted));
}


@override
int get hashCode {
  final _this = this as WaterEntry;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.amountMl,_this.recordedAt,_this.updatedAt,_this.isDeleted);
}

@override
String toString() {
  final _this = this as WaterEntry;
  return 'WaterEntry(id: ${_this.id}, userId: ${_this.userId}, amountMl: ${_this.amountMl}, recordedAt: ${_this.recordedAt}, updatedAt: ${_this.updatedAt}, isDeleted: ${_this.isDeleted})';
}


}

/// @nodoc
abstract mixin class $WaterEntryCopyWith<$Res>  {
  factory $WaterEntryCopyWith(WaterEntry value, $Res Function(WaterEntry) _then) = _$WaterEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int amountMl, DateTime recordedAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class _$WaterEntryCopyWithImpl<$Res>
    implements $WaterEntryCopyWith<$Res> {
  _$WaterEntryCopyWithImpl(this._self, this._then);

  final WaterEntry _self;
  final $Res Function(WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? amountMl = null,Object? recordedAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(WaterEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterEntry].
extension WaterEntryPatterns on WaterEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterEntry value)  $default,){
final _that = this;
switch (_that) {
case _WaterEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int amountMl,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.id,_that.userId,_that.amountMl,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int amountMl,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _WaterEntry():
return $default(_that.id,_that.userId,_that.amountMl,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int amountMl,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _WaterEntry() when $default != null:
return $default(_that.id,_that.userId,_that.amountMl,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc


class _WaterEntry implements WaterEntry {
  const _WaterEntry({required this.id, required this.userId, required this.amountMl, required this.recordedAt, required this.updatedAt, this.isDeleted = false});
  

@override final  String id;
@override final  String userId;
@override final  int amountMl;
@override final  DateTime recordedAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterEntryCopyWith<_WaterEntry> get copyWith => __$WaterEntryCopyWithImpl<_WaterEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amountMl, amountMl) || other.amountMl == amountMl)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,amountMl,recordedAt,updatedAt,isDeleted);
}

@override
String toString() {
    return 'WaterEntry(id: $id, userId: $userId, amountMl: $amountMl, recordedAt: $recordedAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$WaterEntryCopyWith<$Res> implements $WaterEntryCopyWith<$Res> {
  factory _$WaterEntryCopyWith(_WaterEntry value, $Res Function(_WaterEntry) _then) = __$WaterEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int amountMl, DateTime recordedAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class __$WaterEntryCopyWithImpl<$Res>
    implements _$WaterEntryCopyWith<$Res> {
  __$WaterEntryCopyWithImpl(this._self, this._then);

  final _WaterEntry _self;
  final $Res Function(_WaterEntry) _then;

/// Create a copy of WaterEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? amountMl = null,Object? recordedAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_WaterEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,amountMl: null == amountMl ? _self.amountMl : amountMl // ignore: cast_nullable_to_non_nullable
as int,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
