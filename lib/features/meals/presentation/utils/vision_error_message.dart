import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps *known* server error codes to safe, actionable UI messages.
/// Never displays raw function response bodies, bearer tokens, or API keys.
String visionErrorMessage(Object error) {
  if (error is TimeoutException) {
    return 'Analiz zaman aşımına uğradı. Bağlantıyı kontrol edip sonra tekrar dene.';
  }
  if (error is FormatException) {
    return 'Analiz verisi geçersiz: ${error.message}';
  }
  if (error is StateError) {
    return 'Oturum gerekli. Çıkış yapıp tekrar giriş yapmayı dene.';
  }
  if (error is FunctionsFetchException) {
    return 'Edge Function sunucusuna erişilemedi (bağlantı hatası). '
        'Emülatör internetini kontrol et.';
  }
  if (error is FunctionException) {
    final status = error.status;
    final code = _safeCode(error.details);
    final prefix =
        'Fotoğraf analizi başarısız (HTTP $status'
        '${code == null ? '' : ', $code'}). ';
    if (code == 'server_not_configured') {
      return '${prefix}Supabase Secrets içinde GEMINI_API_KEY bulunmuyor.';
    }
    if (code == 'quota_unavailable') {
      return '${prefix}Adım 5 SQL migration ve reserve_vision_request fonksiyonunu kontrol et.';
    }
    if (code == 'daily_quota_exceeded') {
      return '${prefix}NutriBuddy günlük 10 analiz kotası doldu.';
    }
    if (code == 'provider_quota_exceeded') {
      return '${prefix}Gemini API ücretsiz kotası veya anlık limiti dolmuş olabilir.';
    }
    if (code == 'invalid_image' || status == 413) {
      return '${prefix}JPEG/PNG/WEBP ve en fazla 5 MB boyutunda fotoğraf seç.';
    }
    if (code == 'food_not_recognized') {
      return '${prefix}Fotoğrafta yemek tanınamadı.';
    }
    if (code == 'ai_request_failed') {
      return '${prefix}Gemini isteği reddetti. Supabase fonksiyon kayıtlarını kontrol et.';
    }
    if (code == 'invalid_ai_result' || code == 'analysis_unavailable') {
      return '${prefix}Gemini beklenen analiz JSON verisini üretemedi.';
    }
    if (code == 'ai_unavailable') {
      return '${prefix}Gemini isteği zaman aşımı veya ağ hatasıyla sonuçlandı.';
    }
    if (status == 401 || status == 403) {
      return '${prefix}Oturum veya fonksiyon JWT doğrulamasını kontrol et.';
    }
    if (status == 404) {
      return '${prefix}Supabase analyze-meal fonksiyonu bulunamadı veya dağıtılmadı.';
    }
    if (status == 429) {
      return '${prefix}AI analiz kullanım sınırı aşıldı.';
    }
    return '${prefix}Supabase Edge Functions > analyze-meal > Invocations ve Logs bölümünü kontrol et.';
  }
  return 'Fotoğraf analizi tamamlanamadı. '
      'Supabase Edge Functions > analyze-meal > Invocations bölümünü kontrol et.';
}

const _knownCodes = {
  'server_not_configured',
  'quota_unavailable',
  'daily_quota_exceeded',
  'provider_quota_exceeded',
  'invalid_image',
  'food_not_recognized',
  'ai_request_failed',
  'invalid_ai_result',
  'analysis_unavailable',
  'ai_unavailable',
  'invalid_json',
  'payload_too_large',
  'method_not_allowed',
};

String? _safeCode(dynamic details) {
  Object? payload = details;
  if (payload is String) {
    try {
      payload = jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }
  if (payload is! Map) return null;
  final value = payload['error'];
  return value is String && _knownCodes.contains(value) ? value : null;
}
