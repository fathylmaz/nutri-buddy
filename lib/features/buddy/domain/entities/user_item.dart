import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_item.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class UserItem with _$UserItem {
  const factory UserItem({
    required String id,
    required String userId,
    required String itemId,
    required DateTime acquiredAt,
    @Default(false) bool equipped,
  }) = _UserItem;
}
