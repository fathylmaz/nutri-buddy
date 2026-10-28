// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealCloudSync)
final mealCloudSyncProvider = MealCloudSyncProvider._();

final class MealCloudSyncProvider
    extends
        $FunctionalProvider<
          MealCloudSyncService?,
          MealCloudSyncService?,
          MealCloudSyncService?
        >
    with $Provider<MealCloudSyncService?> {
  MealCloudSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealCloudSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealCloudSyncHash();

  @$internal
  @override
  $ProviderElement<MealCloudSyncService?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealCloudSyncService? create(Ref ref) {
    return mealCloudSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealCloudSyncService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealCloudSyncService?>(value),
    );
  }
}

String _$mealCloudSyncHash() => r'd6cf02c453024d761a6ddce4a6333bcc9c777557';

@ProviderFor(pendingMealCount)
final pendingMealCountProvider = PendingMealCountFamily._();

final class PendingMealCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  PendingMealCountProvider._({
    required PendingMealCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingMealCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingMealCountHash();

  @override
  String toString() {
    return r'pendingMealCountProvider'
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
    return pendingMealCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingMealCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingMealCountHash() => r'c68623122a79cedd61ffdadbf31540c11c01ac38';

final class PendingMealCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  PendingMealCountFamily._()
    : super(
        retry: null,
        name: r'pendingMealCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PendingMealCountProvider call(String userId) =>
      PendingMealCountProvider._(argument: userId, from: this);

  @override
  String toString() => r'pendingMealCountProvider';
}

@ProviderFor(dailyMeals)
final dailyMealsProvider = DailyMealsFamily._();

final class DailyMealsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealLog>>,
          List<MealLog>,
          FutureOr<List<MealLog>>
        >
    with $FutureModifier<List<MealLog>>, $FutureProvider<List<MealLog>> {
  DailyMealsProvider._({
    required DailyMealsFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'dailyMealsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyMealsHash();

  @override
  String toString() {
    return r'dailyMealsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<MealLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MealLog>> create(Ref ref) {
    final argument = this.argument as (String, DateTime);
    return dailyMeals(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyMealsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyMealsHash() => r'704de8afc0d3c107bbf578ed3cf97a58e6671f50';

final class DailyMealsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<MealLog>>, (String, DateTime)> {
  DailyMealsFamily._()
    : super(
        retry: null,
        name: r'dailyMealsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyMealsProvider call(String userId, DateTime day) =>
      DailyMealsProvider._(argument: (userId, day), from: this);

  @override
  String toString() => r'dailyMealsProvider';
}
