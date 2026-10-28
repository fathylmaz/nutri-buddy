// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserItem {

 String get id; String get userId; String get itemId; DateTime get acquiredAt; bool get equipped;
/// Create a copy of UserItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserItemCopyWith<UserItem> get copyWith => _$UserItemCopyWithImpl<UserItem>(this as UserItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.acquiredAt, _this.acquiredAt) || other.acquiredAt == _this.acquiredAt)&&(identical(other.equipped, _this.equipped) || other.equipped == _this.equipped));
}


@override
int get hashCode {
  final _this = this as UserItem;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.itemId,_this.acquiredAt,_this.equipped);
}

@override
String toString() {
  final _this = this as UserItem;
  return 'UserItem(id: ${_this.id}, userId: ${_this.userId}, itemId: ${_this.itemId}, acquiredAt: ${_this.acquiredAt}, equipped: ${_this.equipped})';
}


}

/// @nodoc
abstract mixin class $UserItemCopyWith<$Res>  {
  factory $UserItemCopyWith(UserItem value, $Res Function(UserItem) _then) = _$UserItemCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String itemId, DateTime acquiredAt, bool equipped
});




}
/// @nodoc
class _$UserItemCopyWithImpl<$Res>
    implements $UserItemCopyWith<$Res> {
  _$UserItemCopyWithImpl(this._self, this._then);

  final UserItem _self;
  final $Res Function(UserItem) _then;

/// Create a copy of UserItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? acquiredAt = null,Object? equipped = null,}) {
  return _then(UserItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,acquiredAt: null == acquiredAt ? _self.acquiredAt : acquiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserItem].
extension UserItemPatterns on UserItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserItem value)  $default,){
final _that = this;
switch (_that) {
case _UserItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserItem value)?  $default,){
final _that = this;
switch (_that) {
case _UserItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String itemId,  DateTime acquiredAt,  bool equipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserItem() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.acquiredAt,_that.equipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String itemId,  DateTime acquiredAt,  bool equipped)  $default,) {final _that = this;
switch (_that) {
case _UserItem():
return $default(_that.id,_that.userId,_that.itemId,_that.acquiredAt,_that.equipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String itemId,  DateTime acquiredAt,  bool equipped)?  $default,) {final _that = this;
switch (_that) {
case _UserItem() when $default != null:
return $default(_that.id,_that.userId,_that.itemId,_that.acquiredAt,_that.equipped);case _:
  return null;

}
}

}

/// @nodoc


class _UserItem implements UserItem {
  const _UserItem({required this.id, required this.userId, required this.itemId, required this.acquiredAt, this.equipped = false});
  

@override final  String id;
@override final  String userId;
@override final  String itemId;
@override final  DateTime acquiredAt;
@override@JsonKey() final  bool equipped;

/// Create a copy of UserItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserItemCopyWith<_UserItem> get copyWith => __$UserItemCopyWithImpl<_UserItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.acquiredAt, acquiredAt) || other.acquiredAt == acquiredAt)&&(identical(other.equipped, equipped) || other.equipped == equipped));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,itemId,acquiredAt,equipped);
}

@override
String toString() {
    return 'UserItem(id: $id, userId: $userId, itemId: $itemId, acquiredAt: $acquiredAt, equipped: $equipped)';
}


}

/// @nodoc
abstract mixin class _$UserItemCopyWith<$Res> implements $UserItemCopyWith<$Res> {
  factory _$UserItemCopyWith(_UserItem value, $Res Function(_UserItem) _then) = __$UserItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String itemId, DateTime acquiredAt, bool equipped
});




}
/// @nodoc
class __$UserItemCopyWithImpl<$Res>
    implements _$UserItemCopyWith<$Res> {
  __$UserItemCopyWithImpl(this._self, this._then);

  final _UserItem _self;
  final $Res Function(_UserItem) _then;

/// Create a copy of UserItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemId = null,Object? acquiredAt = null,Object? equipped = null,}) {
  return _then(_UserItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,acquiredAt: null == acquiredAt ? _self.acquiredAt : acquiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
