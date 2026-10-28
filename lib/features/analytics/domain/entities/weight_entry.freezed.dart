// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeightEntry {

 String get id; String get userId; double get weightKg; DateTime get recordedAt; DateTime get updatedAt; bool get isDeleted;
/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightEntryCopyWith<WeightEntry> get copyWith => _$WeightEntryCopyWithImpl<WeightEntry>(this as WeightEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeightEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted));
}


@override
int get hashCode {
  final _this = this as WeightEntry;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.weightKg,_this.recordedAt,_this.updatedAt,_this.isDeleted);
}

@override
String toString() {
  final _this = this as WeightEntry;
  return 'WeightEntry(id: ${_this.id}, userId: ${_this.userId}, weightKg: ${_this.weightKg}, recordedAt: ${_this.recordedAt}, updatedAt: ${_this.updatedAt}, isDeleted: ${_this.isDeleted})';
}


}

/// @nodoc
abstract mixin class $WeightEntryCopyWith<$Res>  {
  factory $WeightEntryCopyWith(WeightEntry value, $Res Function(WeightEntry) _then) = _$WeightEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, double weightKg, DateTime recordedAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class _$WeightEntryCopyWithImpl<$Res>
    implements $WeightEntryCopyWith<$Res> {
  _$WeightEntryCopyWithImpl(this._self, this._then);

  final WeightEntry _self;
  final $Res Function(WeightEntry) _then;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? weightKg = null,Object? recordedAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(WeightEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightEntry].
extension WeightEntryPatterns on WeightEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightEntry value)  $default,){
final _that = this;
switch (_that) {
case _WeightEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WeightEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  double weightKg,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightEntry() when $default != null:
return $default(_that.id,_that.userId,_that.weightKg,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  double weightKg,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _WeightEntry():
return $default(_that.id,_that.userId,_that.weightKg,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  double weightKg,  DateTime recordedAt,  DateTime updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _WeightEntry() when $default != null:
return $default(_that.id,_that.userId,_that.weightKg,_that.recordedAt,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc


class _WeightEntry implements WeightEntry {
  const _WeightEntry({required this.id, required this.userId, required this.weightKg, required this.recordedAt, required this.updatedAt, this.isDeleted = false});
  

@override final  String id;
@override final  String userId;
@override final  double weightKg;
@override final  DateTime recordedAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightEntryCopyWith<_WeightEntry> get copyWith => __$WeightEntryCopyWithImpl<_WeightEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,weightKg,recordedAt,updatedAt,isDeleted);
}

@override
String toString() {
    return 'WeightEntry(id: $id, userId: $userId, weightKg: $weightKg, recordedAt: $recordedAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$WeightEntryCopyWith<$Res> implements $WeightEntryCopyWith<$Res> {
  factory _$WeightEntryCopyWith(_WeightEntry value, $Res Function(_WeightEntry) _then) = __$WeightEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, double weightKg, DateTime recordedAt, DateTime updatedAt, bool isDeleted
});




}
/// @nodoc
class __$WeightEntryCopyWithImpl<$Res>
    implements _$WeightEntryCopyWith<$Res> {
  __$WeightEntryCopyWithImpl(this._self, this._then);

  final _WeightEntry _self;
  final $Res Function(_WeightEntry) _then;

/// Create a copy of WeightEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? weightKg = null,Object? recordedAt = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_WeightEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
