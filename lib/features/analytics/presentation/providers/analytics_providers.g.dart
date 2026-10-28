// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weightRepository)
final weightRepositoryProvider = WeightRepositoryProvider._();

final class WeightRepositoryProvider
    extends
        $FunctionalProvider<
          WeightRepository,
          WeightRepository,
          WeightRepository
        >
    with $Provider<WeightRepository> {
  WeightRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeightRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WeightRepository create(Ref ref) {
    return weightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeightRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeightRepository>(value),
    );
  }
}

String _$weightRepositoryHash() => r'3b3604312b726085c5566eb649aab564a57b4c8b';

@ProviderFor(pendingWeightCount)
final pendingWeightCountProvider = PendingWeightCountFamily._();

final class PendingWeightCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  PendingWeightCountProvider._({
    required PendingWeightCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingWeightCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingWeightCountHash();

  @override
  String toString() {
    return r'pendingWeightCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return pendingWeightCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingWeightCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingWeightCountHash() =>
    r'd2193b863e73687125b072a53da69d268f733aae';

final class PendingWeightCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  PendingWeightCountFamily._()
    : super(
        retry: null,
        name: r'pendingWeightCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PendingWeightCountProvider call(String userId) =>
      PendingWeightCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'pendingWeightCountProvider';
}

@ProviderFor(weightCloudSync)
final weightCloudSyncProvider = WeightCloudSyncProvider._();

final class WeightCloudSyncProvider
    extends
        $FunctionalProvider<
          WeightCloudSyncService?,
          WeightCloudSyncService?,
          WeightCloudSyncService?
        >
    with $Provider<WeightCloudSyncService?> {
  WeightCloudSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightCloudSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightCloudSyncHash();

  @$internal
  @override
  $ProviderElement<WeightCloudSyncService?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeightCloudSyncService? create(Ref ref) {
    return weightCloudSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeightCloudSyncService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeightCloudSyncService?>(value),
    );
  }
}

String _$weightCloudSyncHash() => r'1d6aef08b251cc7f82eea6e159c5785cfc31e18f';

@ProviderFor(analyticsSnapshot)
final analyticsSnapshotProvider = AnalyticsSnapshotFamily._();

final class AnalyticsSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalyticsSnapshot>,
          AnalyticsSnapshot,
          FutureOr<AnalyticsSnapshot>
        >
    with
        $FutureModifier<AnalyticsSnapshot>,
        $FutureProvider<AnalyticsSnapshot> {
  AnalyticsSnapshotProvider._({
    required AnalyticsSnapshotFamily super.from,
    required (String, int, DateTime, int, int, int, int) super.argument,
  }) : super(
         retry: null,
         name: r'analyticsSnapshotProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsSnapshotHash();

  @override
  String toString() {
    return r'analyticsSnapshotProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AnalyticsSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalyticsSnapshot> create(Ref ref) {
    final argument =
        this.argument as (String, int, DateTime, int, int, int, int);
    return analyticsSnapshot(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
      argument.$5,
      argument.$6,
      argument.$7,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsSnapshotProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsSnapshotHash() => r'fbcc6fa169525248637bdc0ba672c3ed56c2b718';

final class AnalyticsSnapshotFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AnalyticsSnapshot>,
          (String, int, DateTime, int, int, int, int)
        > {
  AnalyticsSnapshotFamily._()
    : super(
        retry: null,
        name: r'analyticsSnapshotProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalyticsSnapshotProvider call(
    String userId,
    int periodDays,
    DateTime today,
    int dailyCalories,
    int proteinG,
    int carbsG,
    int fatG,
  ) => AnalyticsSnapshotProvider._(
    argument: (
      userId,
      periodDays,
      today,
      dailyCalories,
      proteinG,
      carbsG,
      fatG,
    ),
    from: this,
  );

  @override
  String toString() => r'analyticsSnapshotProvider';
}
