// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foundation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Generated Riverpod provider; validates the code-gen toolchain in Stage 1.

@ProviderFor(foundationStatus)
final foundationStatusProvider = FoundationStatusProvider._();

/// Generated Riverpod provider; validates the code-gen toolchain in Stage 1.

final class FoundationStatusProvider
    extends
        $FunctionalProvider<
          FoundationStatus,
          FoundationStatus,
          FoundationStatus
        >
    with $Provider<FoundationStatus> {
  /// Generated Riverpod provider; validates the code-gen toolchain in Stage 1.
  FoundationStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foundationStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foundationStatusHash();

  @$internal
  @override
  $ProviderElement<FoundationStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FoundationStatus create(Ref ref) {
    return foundationStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoundationStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoundationStatus>(value),
    );
  }
}

String _$foundationStatusHash() => r'e123ec8a953058b641c1a0d5a7612e5d989c4870';
