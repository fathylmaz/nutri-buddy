import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutri_buddy/features/dashboard/domain/usecases/daily_nutrition_summary.dart';
import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';
import 'package:nutri_buddy/features/meal_builder/domain/repositories/meal_builder_repository.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/meal_builder_budget.dart';
import 'package:nutri_buddy/features/meal_builder/domain/usecases/recipe_allergen_guard.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/pages/recipe_details_page.dart';
import 'package:nutri_buddy/features/meal_builder/presentation/providers/meal_builder_providers.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/onboarding/domain/entities/user_profile.dart';
import 'package:nutri_buddy/features/onboarding/domain/usecases/nutrition_calculator.dart';

/// Generated recipes remain ephemeral until a user explicitly saves one.
/// Sensitive details are sent to Gemini only after an explicit opt-in.
class MealBuilderPage extends ConsumerStatefulWidget {
  const MealBuilderPage({
    required this.userId,
    required this.profile,
    super.key,
  });

  final String userId;
  final UserProfile profile;

  @override
  ConsumerState<MealBuilderPage> createState() => _MealBuilderPageState();
}

class _MealBuilderPageState extends ConsumerState<MealBuilderPage> {
  final _pantryController = TextEditingController();
  late final TextEditingController _exclusionController;
  String _mealType = 'lunch';
  String _dietStyle = 'any';
  bool _consent = false;
  bool _busy = false;
  bool _saving = false;
  bool _loadingBudget = true;
  String? _message;
  MealBuilderBudget? _budget;
  List<MealRecipe> _recipes = [];
  static final _rng = Random.secure();

  @override
  void initState() {
    super.initState();
    _exclusionController = TextEditingController(
      text: widget.profile.allergies.join(', '),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBudget());
  }

  @override
  void dispose() {
    _pantryController.dispose();
    _exclusionController.dispose();
    super.dispose();
  }

  Future<MealBuilderBudget> _calculateBudget() async {
    final targets = NutritionCalculator.calculate(widget.profile);
    final now = DateTime.now();
    final logs = await ref
        .read(mealLogRepositoryProvider)
        .listForUser(widget.userId);
    final consumed = DailyNutritionSummary.fromLogs(
      userId: widget.userId,
      localDay: DateTime(now.year, now.month, now.day),
      logs: logs,
    );
    return MealBuilderBudget.fromDay(targets: targets, consumed: consumed);
  }

  Future<void> _loadBudget() async {
    try {
      final budget = await _calculateBudget();
      if (mounted) {
        setState(() {
          _budget = budget;
          _loadingBudget = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingBudget = false;
          _message =
              'Günlük hedefler okunamadı. Profil bilgilerini kontrol et.';
        });
      }
    }
  }

  static List<String> _terms(String text) {
    final parts = text
        .split(RegExp(r'[,;\n]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length > 15 || parts.any((x) => x.length > 60)) {
      throw const FormatException(
        'En fazla 15 malzeme gir; her biri 60 karakteri aşmasın.',
      );
    }
    return parts;
  }

  MealBuilderRequest _request(
    MealBuilderBudget budget, {
    required int count,
    List<String> avoid = const [],
  }) => MealBuilderRequest(
    mealType: _mealType,
    budget: budget,
    pantry: _terms(_pantryController.text),
    exclusions: _terms(_exclusionController.text),
    dietStyle: _dietStyle,
    count: count,
    avoidNames: avoid,
  );

  Future<void> _generate({int? replaceIndex}) async {
    if (_busy || _saving) {
      return;
    }
    if (!_consent) {
      setState(() => _message = 'Devam etmek için veri aktarımına izin ver.');
      return;
    }
    final service = ref.read(mealBuilderRepositoryProvider);
    if (service == null) {
      setState(
        () => _message =
            'Supabase yapılandırılmadı. Çevrimdışı tarif üretilemez.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final budget = await _calculateBudget();
      final request = _request(
        budget,
        count: replaceIndex == null ? 3 : 1,
        avoid: replaceIndex == null ? [] : _recipes.map((e) => e.name).toList(),
      );
      final generated = await service.generate(request);
      if (!mounted) {
        return;
      }
      setState(() {
        _budget = budget;
        if (replaceIndex == null) {
          _recipes = generated;
        } else {
          _recipes = List.of(_recipes)..[replaceIndex] = generated.first;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(
          () => _message = error is FormatException || error is StateError
              ? error.toString().replaceFirst(RegExp(r'^.*?: '), '')
              : 'Tarif üretimi başarısız. İnternetini ve build-meals kayıtlarını kontrol et.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  static String _makeUuid() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> _saveRecipe(MealRecipe recipe) async {
    if (_busy || _saving) {
      return;
    }
    final match = RecipeAllergenGuard.firstExplicitMatch(
      recipe,
      _terms(_exclusionController.text),
    );
    if (match != null) {
      setState(() => _message = 'Tarif, dışlanan malzemeyi içeriyor: $match');
      return;
    }
    final approved = await _reviewNutrition(recipe);
    if (approved == null || !mounted) {
      return;
    }
    setState(() {
      _saving = true;
      _message = null;
    });
    try {
      final now = DateTime.now().toUtc();
      await ref
          .read(mealLogRepositoryProvider)
          .saveLocally(
            MealLog(
              id: _makeUuid(),
              userId: widget.userId,
              loggedAt: now,
              updatedAt: now,
              name: recipe.name,
              mealType: _mealType,
              source: 'ai_recipe',
              caloriesKcal: approved.calories,
              proteinG: approved.protein,
              carbsG: approved.carbs,
              fatG: approved.fat,
              fiberG: recipe.fiberG,
              recipeDetailsJson: jsonEncode({
                ...recipe.toJson(),
                'calories_kcal': approved.calories,
                'protein_g': approved.protein,
                'carbs_g': approved.carbs,
                'fat_g': approved.fat,
              }),
            ),
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message = 'Tarif yerel veritabanına kaydedilemedi.');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<_ApprovedMacros?> _reviewNutrition(MealRecipe recipe) =>
      showDialog<_ApprovedMacros>(
        context: context,
        builder: (dialogContext) => _RecipeReviewDialog(recipe: recipe),
      );

  @override
  Widget build(BuildContext context) {
    final budget = _budget;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Dinamik Öğün Oluşturucu')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  'Hedeflerine uygun tarif fikirleri',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kalan günlük hedeflerin ve evdeki malzemelerinle tarif '
                  'önerileri üret. Bu bir tıbbi beslenme planı değildir.',
                ),
                const SizedBox(height: 12),
                if (_loadingBudget)
                  const LinearProgressIndicator()
                else if (budget != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bugün kalan tahmini hedef',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${budget.remainingKcal} kcal · '
                            '${budget.remainingProteinG.round()} g protein · '
                            '${budget.remainingCarbsG.round()} g karb. · '
                            '${budget.remainingFatG.round()} g yağ',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Bu öğün için yaklaşık ${budget.targetFor(_mealType)} kcal',
                            style: theme.textTheme.bodySmall,
                          ),
                          if (budget.remainingKcal == 0)
                            const Text(
                              'Günlük hedef dolmuş. Öneriler zorunlu tüketim tavsiyesi değildir.',
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const Key('builder-meal-type'),
                  initialValue: _mealType,
                  decoration: const InputDecoration(labelText: 'Öğün türü'),
                  items: const [
                    DropdownMenuItem(
                      value: 'breakfast',
                      child: Text('Kahvaltı'),
                    ),
                    DropdownMenuItem(
                      value: 'lunch',
                      child: Text('Öğle yemeği'),
                    ),
                    DropdownMenuItem(
                      value: 'dinner',
                      child: Text('Akşam yemeği'),
                    ),
                    DropdownMenuItem(value: 'snack', child: Text('Ara öğün')),
                  ],
                  onChanged: _busy
                      ? null
                      : (v) {
                          if (v != null) setState(() => _mealType = v);
                        },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _dietStyle,
                  decoration: const InputDecoration(
                    labelText: 'Tercih (isteğe bağlı)',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'any', child: Text('Her tür')),
                    DropdownMenuItem(
                      value: 'vegetarian',
                      child: Text('Vejetaryen'),
                    ),
                    DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                  ],
                  onChanged: _busy
                      ? null
                      : (v) {
                          if (v != null) setState(() => _dietStyle = v);
                        },
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('builder-pantry'),
                  controller: _pantryController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Evde bulunan malzemeler',
                    hintText: 'yumurta, domates, pirinç, yoğurt',
                    helperText:
                        'Virgülle ayır. Boş bırakırsan genel tarif önerilir.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('builder-exclusions'),
                  controller: _exclusionController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alerji / istemediğin malzemeler',
                    helperText:
                        'Profilden gelen alerjileri kontrol et; virgülle ayır.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  key: const Key('builder-consent'),
                  contentPadding: EdgeInsets.zero,
                  value: _consent,
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _consent = v ?? false),
                  title: const Text('Gemini veri aktarımını kabul ediyorum'),
                  subtitle: const Text(
                    'Yalnızca malzemeler, dışlanan içerikler ve '
                    'sayısal kalan besin hedefleri Google Gemini API\'ye gönderilir. '
                    'Ücretsiz katmanda girdiler model geliştirme için işlenebilir. '
                    'Kimlik, kilo, doğum tarihi ve sağlık geçmişi gönderilmez.',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Text(
                  'Alerji eşleşmesi otomatik olarak garanti edilemez. '
                  'Önerilerin içeriklerini, etiketleri ve çapraz bulaşmayı ayrıca doğrula.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  key: const Key('generate-recipes'),
                  onPressed:
                      (_busy || _saving || _loadingBudget || budget == null)
                      ? null
                      : () => _generate(),
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(
                    _busy ? 'Tarifler hazırlanıyor...' : '3 tarif öner',
                  ),
                ),
                if (_busy) const LinearProgressIndicator(),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _message!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 16),
                for (var i = 0; i < _recipes.length; i++) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recipes[i].name,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(_recipes[i].description),
                          const SizedBox(height: 6),
                          Text(
                            '${_recipes[i].caloriesKcal} kcal · '
                            '${_recipes[i].proteinG.round()} g protein · '
                            '${_recipes[i].carbsG.round()} g karb. · '
                            '${_recipes[i].fatG.round()} g yağ',
                          ),
                          Text(
                            '${_recipes[i].prepMinutes} dakika',
                            style: theme.textTheme.bodySmall,
                          ),
                          Wrap(
                            spacing: 4,
                            children: [
                              TextButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .push<void>(
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailsPage(
                                          recipe: _recipes[i],
                                        ),
                                      ),
                                    ),
                                icon: const Icon(Icons.menu_book_outlined),
                                label: const Text('Tarifini gör'),
                              ),
                              OutlinedButton.icon(
                                onPressed: _busy || _saving
                                    ? null
                                    : () => _generate(replaceIndex: i),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Alternatif üret'),
                              ),
                              FilledButton.icon(
                                key: Key('save-recipe-$i'),
                                onPressed: _busy || _saving
                                    ? null
                                    : () => _saveRecipe(_recipes[i]),
                                icon: const Icon(Icons.add),
                                label: const Text('Öğün günlüğüne ekle'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ApprovedMacros {
  const _ApprovedMacros(this.calories, this.protein, this.carbs, this.fat);
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
}

/// Owns the field controllers until Flutter actually disposes the dialog route.
class _RecipeReviewDialog extends StatefulWidget {
  const _RecipeReviewDialog({required this.recipe});

  final MealRecipe recipe;

  @override
  State<_RecipeReviewDialog> createState() => _RecipeReviewDialogState();
}

class _RecipeReviewDialogState extends State<_RecipeReviewDialog> {
  late final TextEditingController _calories;
  late final TextEditingController _protein;
  late final TextEditingController _carbs;
  late final TextEditingController _fat;

  @override
  void initState() {
    super.initState();
    _calories = TextEditingController(text: '${widget.recipe.caloriesKcal}');
    _protein = TextEditingController(text: '${widget.recipe.proteinG}');
    _carbs = TextEditingController(text: '${widget.recipe.carbsG}');
    _fat = TextEditingController(text: '${widget.recipe.fatG}');
  }

  @override
  void dispose() {
    _calories.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  static Widget _numberField(TextEditingController controller, String label) =>
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
      );

  void _submit() {
    final cal = int.tryParse(_calories.text.trim());
    double? parse(TextEditingController controller) =>
        double.tryParse(controller.text.trim().replaceAll(',', '.'));
    final p = parse(_protein);
    final c = parse(_carbs);
    final f = parse(_fat);
    if (cal == null ||
        cal < 0 ||
        cal > 20000 ||
        p == null ||
        !p.isFinite ||
        p < 0 ||
        p > 2000 ||
        c == null ||
        !c.isFinite ||
        c < 0 ||
        c > 2000 ||
        f == null ||
        !f.isFinite ||
        f < 0 ||
        f > 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli kalori ve makro değerleri gir.')),
      );
      return;
    }
    Navigator.pop(context, _ApprovedMacros(cal, p, c, f));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Tarifi kaydetmeden önce kontrol et'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.recipe.name),
          const SizedBox(height: 8),
          const Text(
            'Kalori ve makro değerleri AI tahminidir. Düzenleyebilirsin.',
          ),
          const SizedBox(height: 8),
          _numberField(_calories, 'Kalori (kcal)'),
          _numberField(_protein, 'Protein (g)'),
          _numberField(_carbs, 'Karbonhidrat (g)'),
          _numberField(_fat, 'Yağ (g)'),
          const SizedBox(height: 8),
          const Text('Malzemeleri ve alerjenleri etiketlerden ayrıca doğrula.'),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      FilledButton(
        key: const Key('confirm-ai-recipe'),
        onPressed: _submit,
        child: const Text('Onayla ve kaydet'),
      ),
    ],
  );
}
