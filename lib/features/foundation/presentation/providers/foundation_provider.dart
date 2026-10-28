import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/features/foundation/domain/entities/foundation_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foundation_provider.g.dart';

/// Generated Riverpod provider; validates the code-gen toolchain in Stage 1.
@riverpod
FoundationStatus foundationStatus(Ref ref) =>
    FoundationStatus(cloudConfigured: AppConfig.cloudConfigured);
