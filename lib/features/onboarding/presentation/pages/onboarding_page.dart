import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/account_providers.dart';
import 'package:nutri_buddy/features/auth/presentation/providers/auth_providers.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/repositories/profile_service.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';
import 'package:nutri_buddy/features/onboarding/presentation/providers/profile_providers.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({
    required this.userId,
    this.initialProfile,
    this.onCancel,
    super.key,
  });
  final String userId;
  final UserProfile? initialProfile;
  final VoidCallback? onCancel;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late final TextEditingController _target;
  late final TextEditingController _allergies;
  late final TextEditingController _conditions;
  DateTime? _birth;
  String? _sex;
  String _goal = 'maintain';
  String _activity = 'moderate';
  bool _sensitiveConsent = false;
  int _step = 0;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _name = TextEditingController(text: p?.displayName ?? '');
    _height = TextEditingController(text: p?.heightCm?.toString() ?? '');
    _weight = TextEditingController(text: p?.weightKg?.toString() ?? '');
    _target = TextEditingController(text: p?.targetWeightKg?.toString() ?? '');
    _allergies = TextEditingController(text: p?.allergies.join(', ') ?? '');
    _conditions = TextEditingController(
      text: p?.chronicConditions.join(', ') ?? '',
    );
    _birth = p?.birthDate;
    _sex = p?.sexForCalculation;
    _goal = p?.goal ?? 'maintain';
    _activity = p?.activityLevel ?? 'moderate';
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _height,
      _weight,
      _target,
      _allergies,
      _conditions,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  static double? _number(String input) =>
      double.tryParse(input.trim().replaceAll(',', '.'));

  String? _requiredNumber(String? raw, double min, double max) {
    final number = _number(raw ?? '');
    return number == null || !number.isFinite || number < min || number > max
        ? '$min ile $max arasında bir değer gir.'
        : null;
  }

  List<String> _split(String value) => value
      .split(',')
      .map((x) => x.trim())
      .where((x) => x.isNotEmpty)
      .take(20)
      .toSet()
      .toList();

  Future<void> _chooseBirth() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 110),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      initialDate: _birth ?? DateTime(now.year - 25),
      helpText: 'Doğum tarihi',
    );
    if (selected != null) setState(() => _birth = selected);
  }

  Future<void> _next() async {
    setState(() => _error = null);
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _step = 0;
        _error = 'Ölçümleri kontrol et.';
      });
      return;
    }
    if (_birth == null || _sex == null) {
      setState(() {
        _step = 0;
        _error = 'Doğum tarihi ve hesaplama katsayısı gerekli.';
      });
      return;
    }
    if ((_allergies.text.trim().isNotEmpty ||
            _conditions.text.trim().isNotEmpty) &&
        !_sensitiveConsent) {
      setState(
        () => _error = 'Hassas bilgileri kaydetmek için onay ver ya da alanları boş bırak.',
      );
      return;
    }
    final profile = UserProfile(
      id: widget.userId,
      displayName: _name.text.trim().isEmpty ? null : _name.text.trim(),
      sexForCalculation: _sex,
      birthDate: _birth,
      heightCm: _number(_height.text),
      weightKg: _number(_weight.text),
      targetWeightKg: _number(_target.text),
      goal: _goal,
      activityLevel: _activity,
      allergies: _split(_allergies.text),
      chronicConditions: _split(_conditions.text),
      timezone:
          widget.initialProfile?.timezone ??
          'UTC', // IANA timezone picker is future work.
      updatedAt: DateTime.now().toUtc(),
    );
    try {
      NutritionCalculator.calculate(profile);
    } on FormatException catch (error) {
      setState(() => _error = error.message);
      return;
    }
    setState(() => _saving = true);
    try {
      final result = await ref.read(profileServiceProvider).save(profile);
      if (!mounted) return;
      if (result == ProfileSaveResult.savedLocallyOnly) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bilgilerin cihazda kaydedildi, ancak buluta gönderilemedi. Bağlantı geldiğinde "Bulut eşitlemesini dene" seçeneğini kullan.',
            ),
          ),
        );
      }
      ref.invalidate(profilePendingProvider(widget.userId));
      ref.invalidate(userProfileProvider(widget.userId));
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Profil kaydedilemedi. Bilgilerini kontrol edip yeniden dene.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _signOut() async {
    final pending = await ref.read(localPendingCountProvider)(widget.userId);
    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yapılsın mı?'),
        content: Text(
          pending > 0
              ? 'Eşitlenmemiş $pending kayıt cihazda korunacak.'
              : 'Oturum kapanacak. Yerel kayıtlar silinmeyecek.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış yap'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);

    try {
      await signOutPreservingLocalData(ref);

      if (mounted) {
        ref.invalidate(authUserIdProvider);
      }

      if (navigator.mounted) {
        navigator.popUntil((route) => route.isFirst);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Çıkış işlemi tamamlanamadı.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Kişisel hedeflerin'),
      actions: [
        if (widget.onCancel != null)
          TextButton(onPressed: widget.onCancel, child: const Text('Vazgeç'))
        else
          IconButton(
            onPressed: _signOut,
            tooltip: 'Çıkış yap',
            icon: const Icon(Icons.logout),
          ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: Stepper(
              currentStep: _step,
              onStepTapped: (step) => setState(() => _step = step),
              onStepCancel: _step == 0 ? null : () => setState(() => _step--),
              onStepContinue: _saving ? null : _next,
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    FilledButton(
                      onPressed: _saving ? null : details.onStepContinue,
                      child: Text(
                        _saving
                            ? 'Kaydediliyor...'
                            : _step == 2
                            ? 'Hedeflerimi oluştur'
                            : 'Devam et',
                      ),
                    ),
                    if (_step > 0)
                      TextButton(
                        onPressed: _saving ? null : details.onStepCancel,
                        child: const Text('Geri'),
                      ),
                  ],
                ),
              ),
              steps: [
                Step(
                  title: const Text('Temel bilgiler'),
                  isActive: _step >= 0,
                  state: _step > 0 ? StepState.complete : StepState.indexed,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _field(_name, 'Nasıl hitap edelim?', mandatory: false),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _chooseBirth,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          _birth == null
                              ? 'Doğum tarihini seç'
                              : 'Doğum: ${_birth!.day}.${_birth!.month}.${_birth!.year}',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _sex,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'BMR hesaplama katsayısı',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'female',
                            child: Text('Kadın katsayısı'),
                          ),
                          DropdownMenuItem(
                            value: 'male',
                            child: Text('Erkek katsayısı'),
                          ),
                        ],
                        onChanged: (value) => setState(() => _sex = value),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Mifflin-St Jeor yalnızca iki katsayı kullanır; bu alan cinsiyet kimliğini temsil etmez.',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      _field(
                        _height,
                        'Boy (cm)',
                        validator: (v) => _requiredNumber(v, 100, 250),
                      ),
                      const SizedBox(height: 12),
                      _field(
                        _weight,
                        'Güncel kilo (kg)',
                        validator: (v) => _requiredNumber(v, 25, 350),
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Hedef ve hareket'),
                  isActive: _step >= 1,
                  state: _step > 1 ? StepState.complete : StepState.indexed,
                  content: Column(
                    children: [
                      _field(
                        _target,
                        'Hedef kilo (kg)',
                        validator: (v) => _requiredNumber(v, 25, 350),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _goal,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Hedefin',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'lose',
                            child: Text('Kontrollü kilo kaybı'),
                          ),
                          DropdownMenuItem(
                            value: 'gain',
                            child: Text('Kas / kilo kazanımı'),
                          ),
                          DropdownMenuItem(
                            value: 'recomposition',
                            child: Text('Vücut kompozisyonu'),
                          ),
                          DropdownMenuItem(
                            value: 'maintain',
                            child: Text('Kilomu korumak'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _goal = v ?? 'maintain'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _activity,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Aktivite seviyesi',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'sedentary',
                            child: Text('Hareketsiz'),
                          ),
                          DropdownMenuItem(
                            value: 'light',
                            child: Text('Az hareketli'),
                          ),
                          DropdownMenuItem(
                            value: 'moderate',
                            child: Text('Orta aktif'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Aktif'),
                          ),
                          DropdownMenuItem(
                            value: 'very_active',
                            child: Text('Çok aktif'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _activity = v ?? 'moderate'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Agresif kalori kısıtlaması otomatik olarak sunulmaz. Hedefler tahminidir.',
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('İsteğe bağlı sağlık bilgileri'),
                  isActive: _step >= 2,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Alerji ve kronik durumları vermek zorunda değilsin. Virgülle ayırabilirsin.',
                      ),
                      const SizedBox(height: 12),
                      _field(
                        _allergies,
                        'Alerjiler (isteğe bağlı)',
                        mandatory: false,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        _conditions,
                        'Kronik durumlar (isteğe bağlı)',
                        mandatory: false,
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Girdiğim hassas bilgilerin cihazda ve Supabase profilimde saklanmasını kabul ediyorum.',
                        ),
                        value: _sensitiveConsent,
                        onChanged: (v) =>
                            setState(() => _sensitiveConsent = v ?? false),
                      ),
                      const Text(
                        'Bu prototipte yerel Isar verisi şifrelenmiyor. Gerçek tıbbi verileri girmeden önce güvenlik iyileştirmeleri gerekir.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: _error == null
        ? null
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
  );

  static String? _requiredText(String? value) =>
      value == null || value.trim().isEmpty ? 'Gerekli alan.' : null;

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    bool mandatory = true,
  }) => TextFormField(
    controller: controller,
    keyboardType: validator == null
        ? TextInputType.text
        : const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: validator ?? (mandatory ? _requiredText : null),
  );
}
