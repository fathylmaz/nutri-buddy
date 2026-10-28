import 'package:flutter/material.dart';
import 'package:nutri_buddy/app/app_router.dart';
import 'package:nutri_buddy/core/theme/app_theme.dart';

class NutriBuddyApp extends StatelessWidget {
  const NutriBuddyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'NutriBuddy',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    routerConfig: AppRouter.router,
  );
}
