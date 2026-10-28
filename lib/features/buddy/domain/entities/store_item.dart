import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_item.freezed.dart';

/// Pure domain entity: infrastructure-independent and immutable.
@freezed
abstract class StoreItem with _$StoreItem {
  const factory StoreItem({
    required String id,
    required String sku,
    required String name,
    required String slot,
    required String assetKey,
    required int goldPrice,
    @Default(true) bool active,
  }) = _StoreItem;
}
