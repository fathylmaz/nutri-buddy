import 'package:nutri_buddy/features/ai_dietitian/domain/dietitian_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseDietitianRepository implements DietitianRepository {
  const SupabaseDietitianRepository(this._client);

  final SupabaseClient _client;

  void _requireUser() {
    if (_client.auth.currentUser == null ||
        _client.auth.currentSession == null) {
      throw StateError('AI diyetisyen için yeniden giriş yapmalısın.');
    }
  }

  @override
  Future<List<DietitianConversation>> conversations() async {
    _requireUser();
    final userId = _client.auth.currentUser!.id;
    final rows = await _client
        .from('dietitian_conversations')
        .select('id,title,created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(40);
    return rows.map((row) => DietitianConversation.fromJson(row)).toList();
  }

  @override
  Future<List<DietitianMessage>> messages(String conversationId) async {
    _requireUser();
    final rows = await _client
        .from('dietitian_messages')
        .select('role,content,sources')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .limit(100);
    return rows.map((row) => DietitianMessage.fromJson(row)).toList();
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _requireUser();
    await _client
        .from('dietitian_conversations')
        .delete()
        .eq('id', conversationId)
        .eq('user_id', _client.auth.currentUser!.id);
  }

  @override
  Future<DietitianReply> ask({
    required String conversationId,
    required String question,
    required bool consent,
    DietitianDailyContext? dailyContext,
  }) async {
    _requireUser();
    if (!consent) {
      throw StateError('Onay vermeden soru gönderilemez.');
    }
    if (question.trim().length < 3 || question.trim().length > 900) {
      throw const FormatException('Soru uzunluğu 3–900 karakter olmalı.');
    }
    final reply = await _client.functions
        .invoke(
          'dietitian-chat',
          body: {
            'conversation_id': conversationId,
            'question': question.trim(),
            'consent': true,
            'share_daily': dailyContext != null,
            if (dailyContext != null) 'daily_context': dailyContext.toJson(),
          },
        )
        .timeout(const Duration(seconds: 65));
    if (reply.status != 200 || reply.data is! Map) {
      throw StateError(
        'AI diyetisyen yanıt veremedi (HTTP ${reply.status}). '
        'Edge Functions → dietitian-chat → Logs bölümünü kontrol et.',
      );
    }
    return DietitianReply.fromJson(
      Map<String, dynamic>.from(reply.data as Map),
    );
  }
}
