import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_buddy/features/meals/presentation/utils/vision_error_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Missing Gemini secret gives precise non-sensitive instruction', () {
    final text = visionErrorMessage(
      FunctionsHttpException(
        status: 503,
        details: {'error': 'server_not_configured'},
      ),
    );
    expect(text, contains('GEMINI_API_KEY'));
    expect(text, contains('HTTP 503'));
  });

  test('Quota reservation errors point to migration', () {
    final text = visionErrorMessage(
      FunctionsHttpException(
        status: 503,
        details: '{"error":"quota_unavailable"}',
      ),
    );
    expect(text, contains('reserve_vision_request'));
  });

  test('Untrusted error bodies are not shown in the UI', () {
    final text = visionErrorMessage(
      FunctionsHttpException(
        status: 502,
        details: {'error': 'arbitrary dangerous response', 'token': 'SECRET'},
      ),
    );
    expect(text, contains('HTTP 502'));
    expect(text, isNot(contains('SECRET')));
    expect(text, isNot(contains('arbitrary dangerous response')));
  });

  test('Timeout and network failures have distinct messages', () {
    expect(
      visionErrorMessage(TimeoutException('Test timeout')),
      contains('zaman aşımına'),
    );
    expect(
      visionErrorMessage(FunctionsFetchException()),
      contains('erişilemedi'),
    );
  });
}
