// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localUserRepository)
final localUserRepositoryProvider = LocalUserRepositoryProvider._();

final class LocalUserRepositoryProvider
    extends
        $FunctionalProvider<
          IsarUserRepository,
          IsarUserRepository,
          IsarUserRepository
        >
    with $Provider<IsarUserRepository> {
  LocalUserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localUserRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localUserRepositoryHash();

  @$internal
  @override
  $ProviderElement<IsarUserRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IsarUserRepository create(Ref ref) {
    return localUserRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IsarUserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IsarUserRepository>(value),
    );
  }
}

String _$localUserRepositoryHash() =>
    r'3cff1ee2230a3cbb7a751b4972e9d4fe0e8ce192';

@ProviderFor(profileService)
final profileServiceProvider = ProfileServiceProvider._();

final class ProfileServiceProvider
    extends $FunctionalProvider<ProfileService, ProfileService, ProfileService>
    with $Provider<ProfileService> {
  ProfileServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileServiceHash();

  @$internal
  @override
  $ProviderElement<ProfileService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileService create(Ref ref) {
    return profileService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileService>(value),
    );
  }
}

String _$profileServiceHash() => r'0c25dcc55dad307ad86507ee2a707dcec06c7d4b';

@ProviderFor(userProfile)
final userProfileProvider = UserProfileFamily._();

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfile?>,
          UserProfile?,
          FutureOr<UserProfile?>
        >
    with $FutureModifier<UserProfile?>, $FutureProvider<UserProfile?> {
  UserProfileProvider._({
    required UserProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @override
  String toString() {
    return r'userProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfile?> create(Ref ref) {
    final argument = this.argument as String;
    return userProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileHash() => r'8fe886f63985a5ba9d286b1a47722693e873e164';

final class UserProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserProfile?>, String> {
  UserProfileFamily._()
    : super(
        retry: null,
        name: r'userProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileProvider call(String userId) =>
      UserProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileProvider';
}

@ProviderFor(profilePending)
final profilePendingProvider = ProfilePendingFamily._();

final class ProfilePendingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  ProfilePendingProvider._({
    required ProfilePendingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profilePendingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profilePendingHash();

  @override
  String toString() {
    return r'profilePendingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return profilePending(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfilePendingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profilePendingHash() => r'0f632748ae58713f275180f550a69cbb0d91afe1';

final class ProfilePendingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  ProfilePendingFamily._()
    : super(
        retry: null,
        name: r'profilePendingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfilePendingProvider call(String userId) =>
      ProfilePendingProvider._(argument: userId, from: this);

  @override
  String toString() => r'profilePendingProvider';
}
