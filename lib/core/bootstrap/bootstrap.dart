import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/app/nutri_buddy_app.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/core/database/local_database.dart';
import 'package:nutri_buddy/core/database/local_database_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.validate();

  // The local database is opened even when there is no network or session.
  final isar = await LocalDatabase.open();

  // Stage 2 registers the cloud client; authentication is Stage 3.
  if (AppConfig.cloudConfigured) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [localDatabaseProvider.overrideWithValue(isar)],
      child: const NutriBuddyApp(),
    ),
  );
}
