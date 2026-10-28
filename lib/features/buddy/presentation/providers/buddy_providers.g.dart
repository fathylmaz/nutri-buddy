// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(buddyLocalRepository)
final buddyLocalRepositoryProvider = BuddyLocalRepositoryProvider._();

final class BuddyLocalRepositoryProvider
    extends
        $FunctionalProvider<
          IsarPetRepository,
          IsarPetRepository,
          IsarPetRepository
        >
    with $Provider<IsarPetRepository> {
  BuddyLocalRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buddyLocalRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buddyLocalRepositoryHash();

  @$internal
  @override
  $ProviderElement<IsarPetRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IsarPetRepository create(Ref ref) {
    return buddyLocalRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IsarPetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IsarPetRepository>(value),
    );
  }
}

String _$buddyLocalRepositoryHash() =>
    r'0a404c152732b85dd03bf587a9bf309d263d3386';

@ProviderFor(buddyCloudService)
final buddyCloudServiceProvider = BuddyCloudServiceProvider._();

final class BuddyCloudServiceProvider
    extends
        $FunctionalProvider<
          BuddyCloudService?,
          BuddyCloudService?,
          BuddyCloudService?
        >
    with $Provider<BuddyCloudService?> {
  BuddyCloudServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'buddyCloudServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$buddyCloudServiceHash();

  @$internal
  @override
  $ProviderElement<BuddyCloudService?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BuddyCloudService? create(Ref ref) {
    return buddyCloudService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BuddyCloudService? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BuddyCloudService?>(value),
    );
  }
}

String _$buddyCloudServiceHash() => r'61cab6f507d45d4baae04051c10ee3260bc1ad5f';

@ProviderFor(buddyPet)
final buddyPetProvider = BuddyPetFamily._();

final class BuddyPetProvider
    extends
        $FunctionalProvider<AsyncValue<BuddyPet?>, BuddyPet?, Stream<BuddyPet?>>
    with $FutureModifier<BuddyPet?>, $StreamProvider<BuddyPet?> {
  BuddyPetProvider._({
    required BuddyPetFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'buddyPetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$buddyPetHash();

  @override
  String toString() {
    return r'buddyPetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<BuddyPet?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<BuddyPet?> create(Ref ref) {
    final argument = this.argument as String;
    return buddyPet(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BuddyPetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$buddyPetHash() => r'72f1502115a669413b94c873cc387113d90c287f';

final class BuddyPetFamily extends $Family
    with $FunctionalFamilyOverride<Stream<BuddyPet?>, String> {
  BuddyPetFamily._()
    : super(
        retry: null,
        name: r'buddyPetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BuddyPetProvider call(String userId) =>
      BuddyPetProvider._(argument: userId, from: this);

  @override
  String toString() => r'buddyPetProvider';
}
