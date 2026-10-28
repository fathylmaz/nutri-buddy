import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/core/config/app_config.dart';
import 'package:nutri_buddy/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;
  String? _notice;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final auth = ref.read(authRepositoryProvider);
      if (_register) {
        final result = await auth.register(
          email: _email.text,
          password: _password.text,
        );
        if (result == RegisterResult.emailConfirmationRequired && mounted) {
          setState(
            () => _notice = 'Hesap oluşturuldu. E-postandaki doğrulama bağlantısını aç, ardından giriş yap.',
          );
        }
      } else {
        await auth.signIn(email: _email.text, password: _password.text);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _notice = 'İşlem tamamlanamadı: ${_readable(error)}');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _readable(Object error) {
    final message = error.toString();
    // Never log credentials or display raw payloads containing tokens.
    if (message.contains('Invalid login credentials')) {
      return 'E-posta veya şifre hatalı.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Önce e-posta adresini doğrula.';
    }
    return 'Bağlantını, e-postanı ve Supabase Auth ayarlarını kontrol et.';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Icon(Icons.spa_rounded, size: 64, color: color.primary),
                    const SizedBox(height: 16),
                    Text(
                      'NutriBuddy',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hedeflerine uygun, bilimsel temelli beslenme yolculuğu',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Giriş yap')),
                        ButtonSegment(value: true, label: Text('Kayıt ol')),
                      ],
                      selected: {_register},
                      onSelectionChanged: _busy
                          ? null
                          : (values) => setState(() {
                              _register = values.first;
                              _notice = null;
                            }),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'E-posta',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Geçerli bir e-posta gir.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      autofillHints: [
                        _register
                            ? AutofillHints.newPassword
                            : AutofillHints.password,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 8
                          ? 'En az 8 karakter kullan.'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    if (_notice != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(_notice!),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    FilledButton.icon(
                      onPressed: _busy || !AppConfig.cloudConfigured
                          ? null
                          : _submit,
                      icon: _busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_forward),
                      label: Text(_register ? 'Hesap oluştur' : 'Giriş yap'),
                    ),
                    const SizedBox(height: 20),
                    if (!AppConfig.cloudConfigured)
                      const Text(
                        'Supabase bilgileri eksik. Uygulamayı --dart-define-from-file=.env.dev.json ile başlat.',
                        textAlign: TextAlign.center,
                      ),
                    const Text(
                      'Veriler hassastır. Gerçek sağlık verilerini üretim ortamında kullanmadan önce güvenlik ve izin süreçleri tamamlanmalıdır.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
