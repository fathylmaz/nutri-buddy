// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreItem {

 String get id; String get sku; String get name; String get slot; String get assetKey; int get goldPrice; bool get active;
/// Create a copy of StoreItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreItemCopyWith<StoreItem> get copyWith => _$StoreItemCopyWithImpl<StoreItem>(this as StoreItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StoreItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.assetKey, _this.assetKey) || other.assetKey == _this.assetKey)&&(identical(other.goldPrice, _this.goldPrice) || other.goldPrice == _this.goldPrice)&&(identical(other.active, _this.active) || other.active == _this.active));
}


@override
int get hashCode {
  final _this = this as StoreItem;
  return Object.hash(runtimeType,_this.id,_this.sku,_this.name,_this.slot,_this.assetKey,_this.goldPrice,_this.active);
}

@override
String toString() {
  final _this = this as StoreItem;
  return 'StoreItem(id: ${_this.id}, sku: ${_this.sku}, name: ${_this.name}, slot: ${_this.slot}, assetKey: ${_this.assetKey}, goldPrice: ${_this.goldPrice}, active: ${_this.active})';
}


}

/// @nodoc
abstract mixin class $StoreItemCopyWith<$Res>  {
  factory $StoreItemCopyWith(StoreItem value, $Res Function(StoreItem) _then) = _$StoreItemCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name, String slot, String assetKey, int goldPrice, bool active
});




}
/// @nodoc
class _$StoreItemCopyWithImpl<$Res>
    implements $StoreItemCopyWith<$Res> {
  _$StoreItemCopyWithImpl(this._self, this._then);

  final StoreItem _self;
  final $Res Function(StoreItem) _then;

/// Create a copy of StoreItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? slot = null,Object? assetKey = null,Object? goldPrice = null,Object? active = null,}) {
  return _then(StoreItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,assetKey: null == assetKey ? _self.assetKey : assetKey // ignore: cast_nullable_to_non_nullable
as String,goldPrice: null == goldPrice ? _self.goldPrice : goldPrice // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreItem].
extension StoreItemPatterns on StoreItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreItem value)  $default,){
final _that = this;
switch (_that) {
case _StoreItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreItem value)?  $default,){
final _that = this;
switch (_that) {
case _StoreItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String slot,  String assetKey,  int goldPrice,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreItem() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.slot,_that.assetKey,_that.goldPrice,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  String slot,  String assetKey,  int goldPrice,  bool active)  $default,) {final _that = this;
switch (_that) {
case _StoreItem():
return $default(_that.id,_that.sku,_that.name,_that.slot,_that.assetKey,_that.goldPrice,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name,  String slot,  String assetKey,  int goldPrice,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _StoreItem() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.slot,_that.assetKey,_that.goldPrice,_that.active);case _:
  return null;

}
}

}

/// @nodoc


class _StoreItem implements StoreItem {
  const _StoreItem({required this.id, required this.sku, required this.name, required this.slot, required this.assetKey, required this.goldPrice, this.active = true});
  

@override final  String id;
@override final  String sku;
@override final  String name;
@override final  String slot;
@override final  String assetKey;
@override final  int goldPrice;
@override@JsonKey() final  bool active;

/// Create a copy of StoreItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreItemCopyWith<_StoreItem> get copyWith => __$StoreItemCopyWithImpl<_StoreItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.assetKey, assetKey) || other.assetKey == assetKey)&&(identical(other.goldPrice, goldPrice) || other.goldPrice == goldPrice)&&(identical(other.active, active) || other.active == active));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,sku,name,slot,assetKey,goldPrice,active);
}

@override
String toString() {
    return 'StoreItem(id: $id, sku: $sku, name: $name, slot: $slot, assetKey: $assetKey, goldPrice: $goldPrice, active: $active)';
}


}

/// @nodoc
abstract mixin class _$StoreItemCopyWith<$Res> implements $StoreItemCopyWith<$Res> {
  factory _$StoreItemCopyWith(_StoreItem value, $Res Function(_StoreItem) _then) = __$StoreItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name, String slot, String assetKey, int goldPrice, bool active
});




}
/// @nodoc
class __$StoreItemCopyWithImpl<$Res>
    implements _$StoreItemCopyWith<$Res> {
  __$StoreItemCopyWithImpl(this._self, this._then);

  final _StoreItem _self;
  final $Res Function(_StoreItem) _then;

/// Create a copy of StoreItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? slot = null,Object? assetKey = null,Object? goldPrice = null,Object? active = null,}) {
  return _then(_StoreItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,assetKey: null == assetKey ? _self.assetKey : assetKey // ignore: cast_nullable_to_non_nullable
as String,goldPrice: null == goldPrice ? _self.goldPrice : goldPrice // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
