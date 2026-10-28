import 'package:freezed_annotation/freezed_annotation.dart';

part 'foundation_status.freezed.dart';

@freezed
abstract class FoundationStatus with _$FoundationStatus {
  const factory FoundationStatus({
    @Default(3) int currentStage,
    @Default(9) int totalStages,
    required bool cloudConfigured,
  }) = _FoundationStatus;
}
