// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'foundation_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoundationStatus {

 int get currentStage; int get totalStages; bool get cloudConfigured;
/// Create a copy of FoundationStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoundationStatusCopyWith<FoundationStatus> get copyWith => _$FoundationStatusCopyWithImpl<FoundationStatus>(this as FoundationStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoundationStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoundationStatus&&(identical(other.currentStage, _this.currentStage) || other.currentStage == _this.currentStage)&&(identical(other.totalStages, _this.totalStages) || other.totalStages == _this.totalStages)&&(identical(other.cloudConfigured, _this.cloudConfigured) || other.cloudConfigured == _this.cloudConfigured));
}


@override
int get hashCode {
  final _this = this as FoundationStatus;
  return Object.hash(runtimeType,_this.currentStage,_this.totalStages,_this.cloudConfigured);
}

@override
String toString() {
  final _this = this as FoundationStatus;
  return 'FoundationStatus(currentStage: ${_this.currentStage}, totalStages: ${_this.totalStages}, cloudConfigured: ${_this.cloudConfigured})';
}


}

/// @nodoc
abstract mixin class $FoundationStatusCopyWith<$Res>  {
  factory $FoundationStatusCopyWith(FoundationStatus value, $Res Function(FoundationStatus) _then) = _$FoundationStatusCopyWithImpl;
@useResult
$Res call({
 int currentStage, int totalStages, bool cloudConfigured
});




}
/// @nodoc
class _$FoundationStatusCopyWithImpl<$Res>
    implements $FoundationStatusCopyWith<$Res> {
  _$FoundationStatusCopyWithImpl(this._self, this._then);

  final FoundationStatus _self;
  final $Res Function(FoundationStatus) _then;

/// Create a copy of FoundationStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStage = null,Object? totalStages = null,Object? cloudConfigured = null,}) {
  return _then(FoundationStatus(
currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as int,totalStages: null == totalStages ? _self.totalStages : totalStages // ignore: cast_nullable_to_non_nullable
as int,cloudConfigured: null == cloudConfigured ? _self.cloudConfigured : cloudConfigured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FoundationStatus].
extension FoundationStatusPatterns on FoundationStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoundationStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoundationStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoundationStatus value)  $default,){
final _that = this;
switch (_that) {
case _FoundationStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoundationStatus value)?  $default,){
final _that = this;
switch (_that) {
case _FoundationStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStage,  int totalStages,  bool cloudConfigured)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoundationStatus() when $default != null:
return $default(_that.currentStage,_that.totalStages,_that.cloudConfigured);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStage,  int totalStages,  bool cloudConfigured)  $default,) {final _that = this;
switch (_that) {
case _FoundationStatus():
return $default(_that.currentStage,_that.totalStages,_that.cloudConfigured);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStage,  int totalStages,  bool cloudConfigured)?  $default,) {final _that = this;
switch (_that) {
case _FoundationStatus() when $default != null:
return $default(_that.currentStage,_that.totalStages,_that.cloudConfigured);case _:
  return null;

}
}

}

/// @nodoc


class _FoundationStatus implements FoundationStatus {
  const _FoundationStatus({this.currentStage = 3, this.totalStages = 9, required this.cloudConfigured});
  

@override@JsonKey() final  int currentStage;
@override@JsonKey() final  int totalStages;
@override final  bool cloudConfigured;

/// Create a copy of FoundationStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoundationStatusCopyWith<_FoundationStatus> get copyWith => __$FoundationStatusCopyWithImpl<_FoundationStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoundationStatus&&(identical(other.currentStage, currentStage) || other.currentStage == currentStage)&&(identical(other.totalStages, totalStages) || other.totalStages == totalStages)&&(identical(other.cloudConfigured, cloudConfigured) || other.cloudConfigured == cloudConfigured));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentStage,totalStages,cloudConfigured);
}

@override
String toString() {
    return 'FoundationStatus(currentStage: $currentStage, totalStages: $totalStages, cloudConfigured: $cloudConfigured)';
}


}

/// @nodoc
abstract mixin class _$FoundationStatusCopyWith<$Res> implements $FoundationStatusCopyWith<$Res> {
  factory _$FoundationStatusCopyWith(_FoundationStatus value, $Res Function(_FoundationStatus) _then) = __$FoundationStatusCopyWithImpl;
@override @useResult
$Res call({
 int currentStage, int totalStages, bool cloudConfigured
});




}
/// @nodoc
class __$FoundationStatusCopyWithImpl<$Res>
    implements _$FoundationStatusCopyWith<$Res> {
  __$FoundationStatusCopyWithImpl(this._self, this._then);

  final _FoundationStatus _self;
  final $Res Function(_FoundationStatus) _then;

/// Create a copy of FoundationStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStage = null,Object? totalStages = null,Object? cloudConfigured = null,}) {
  return _then(_FoundationStatus(
currentStage: null == currentStage ? _self.currentStage : currentStage // ignore: cast_nullable_to_non_nullable
as int,totalStages: null == totalStages ? _self.totalStages : totalStages // ignore: cast_nullable_to_non_nullable
as int,cloudConfigured: null == cloudConfigured ? _self.cloudConfigured : cloudConfigured // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
