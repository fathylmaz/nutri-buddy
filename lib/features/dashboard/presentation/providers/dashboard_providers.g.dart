// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterRepository)
final waterRepositoryProvider = WaterRepositoryProvider._();

final class WaterRepositoryProvider
    extends
        $FunctionalProvider<WaterRepository, WaterRepository, WaterRepository>
    with $Provider<WaterRepository> {
  WaterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterRepositoryHash();

  @$internal
  @override
  $ProviderElement<WaterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WaterRepository create(Ref ref) {
    return waterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterRepository>(value),
    );
  }
}

String _$waterRepositoryHash() => r'b97509f197eef1ff797fa90dbe696bca331039b5';

@ProviderFor(waterCloudSync)
final waterCloudSyncProvider = WaterCloudSyncProvider._();

final class WaterCloudSyncProvider
    extends
        $FunctionalProvider<
          WaterCloudSyncService?,
          WaterCloudSyncService?,
          WaterCloudSyncService?
        >
    with $Provider<WaterCloudSyncService?> {
  WaterCloudSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterCloudSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterCloudSyncHash();

  @$internal
  @override
  $ProviderElement<WaterCloudSyncService?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WaterCloudSyncService? create(Ref ref) {
    return waterCloudSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterCloudSyncService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterCloudSyncService?>(value),
    );
  }
}

String _$waterCloudSyncHash() => r'0bbbe10393c220303ac6ed1ae0a607dcb935d373';

@ProviderFor(waterDay)
final waterDayProvider = WaterDayFamily._();

final class WaterDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterDaySummary>,
          WaterDaySummary,
          Stream<WaterDaySummary>
        >
    with $FutureModifier<WaterDaySummary>, $StreamProvider<WaterDaySummary> {
  WaterDayProvider._({
    required WaterDayFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'waterDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$waterDayHash();

  @override
  String toString() {
    return r'waterDayProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<WaterDaySummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WaterDaySummary> create(Ref ref) {
    final argument = this.argument as (String, DateTime);
    return waterDay(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$waterDayHash() => r'ef2e5bcb939f61fbf84d28d65e06b5cfa246ad2f';

final class WaterDayFamily extends $Family
    with
        $FunctionalFamilyOverride<Stream<WaterDaySummary>, (String, DateTime)> {
  WaterDayFamily._()
    : super(
        retry: null,
        name: r'waterDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WaterDayProvider call(String userId, DateTime day) =>
      WaterDayProvider._(argument: (userId, day), from: this);

  @override
  String toString() => r'waterDayProvider';
}

@ProviderFor(pendingWaterCount)
final pendingWaterCountProvider = PendingWaterCountFamily._();

final class PendingWaterCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  PendingWaterCountProvider._({
    required PendingWaterCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingWaterCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingWaterCountHash();

  @override
  String toString() {
    return r'pendingWaterCountProvider'
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
    return pendingWaterCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingWaterCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingWaterCountHash() => r'168302889d34a312a2a49e0bf9791058ac7f25c0';

final class PendingWaterCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  PendingWaterCountFamily._()
    : super(
        retry: null,
        name: r'pendingWaterCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PendingWaterCountProvider call(String userId) =>
      PendingWaterCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'pendingWaterCountProvider';
}

@ProviderFor(dailyNutrition)
final dailyNutritionProvider = DailyNutritionFamily._();

final class DailyNutritionProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyNutritionSummary>,
          DailyNutritionSummary,
          FutureOr<DailyNutritionSummary>
        >
    with
        $FutureModifier<DailyNutritionSummary>,
        $FutureProvider<DailyNutritionSummary> {
  DailyNutritionProvider._({
    required DailyNutritionFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'dailyNutritionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyNutritionHash();

  @override
  String toString() {
    return r'dailyNutritionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<DailyNutritionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyNutritionSummary> create(Ref ref) {
    final argument = this.argument as (String, DateTime);
    return dailyNutrition(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyNutritionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyNutritionHash() => r'07a20700979e64138c446bad6abe5be42222ab99';

final class DailyNutritionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<DailyNutritionSummary>,
          (String, DateTime)
        > {
  DailyNutritionFamily._()
    : super(
        retry: null,
        name: r'dailyNutritionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyNutritionProvider call(String userId, DateTime day) =>
      DailyNutritionProvider._(argument: (userId, day), from: this);

  @override
  String toString() => r'dailyNutritionProvider';
}
