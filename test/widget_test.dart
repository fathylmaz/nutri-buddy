import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/app/nutri_buddy_app.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';

void main() {
  testWidgets('unauthenticated startup displays sign-in', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authUserIdProvider.overrideWith((ref) => Stream<String?>.value(null)),
        ],
        child: const NutriBuddyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('NutriBuddy'), findsOneWidget);
    expect(find.text('Giriş yap'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
