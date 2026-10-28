import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutri_buddy/features/meals/domain/entities/meal_log.dart';
import 'package:nutri_buddy/features/meals/domain/entities/vision_meal_analysis.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/meal_repository_provider.dart';
import 'package:nutri_buddy/features/meals/presentation/providers/vision_analysis_provider.dart';
import 'package:nutri_buddy/features/meals/presentation/utils/vision_error_message.dart';

/// Manual meal logging works entirely offline. AI analysis is opt-in and online.
/// Photo bytes exist in memory only during this page's lifetime.
class MealLoggerPage extends ConsumerStatefulWidget {
  const MealLoggerPage({required this.userId, super.key});

  final String userId;

  @override
  ConsumerState<MealLoggerPage> createState() => _MealLoggerPageState();
}

class _MealLoggerPageState extends ConsumerState<MealLoggerPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _calories = TextEditingController(text: '0');
  final _protein = TextEditingController(text: '0');
  final _carbs = TextEditingController(text: '0');
  final _fat = TextEditingController(text: '0');
  final _fiber = TextEditingController(text: '0');
  final _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imageMime;
  VisionMealAnalysis? _analysis;
  String _mealType = 'other';
  bool _consent = false;
  bool _busy = false;
  String? _notice;
  double _portionFactor = 1;

  @override
  void initState() {
    super.initState();
    // Android may evict the activity while the system image picker is open.
    // Restore a lost photo, but NEVER submit it without renewed consent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_recoverLostSelection());
      }
    });
  }

  Future<void> _recoverLostSelection() async {
    try {
      final lost = await _picker.retrieveLostData();
      if (lost.isEmpty || lost.files == null || lost.files!.isEmpty) {
        return;
      }
      await _loadImage(lost.files!.first);
    } catch (_) {
      // Photo selection remains optional: manual logging is always available.
    }
  }

  @override
  void dispose() {
    for (final ctrl in [_name, _calories, _protein, _carbs, _fat, _fiber]) {
      ctrl.dispose();
    }
    super.dispose();
  }

  String? _detectMime(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xff &&
        bytes[1] == 0xd8 &&
        bytes[2] == 0xff) {
      return 'image/jpeg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4e &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
      return 'image/webp';
    }
    return null;
  }

  Future<void> _loadImage(XFile selected) async {
    final bytes = await selected.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw const FormatException('Fotoğraf en fazla 5 MB olabilir.');
    }
    final mime = _detectMime(bytes);
    if (mime == null) {
      throw const FormatException('JPEG, PNG veya WEBP fotoğraf seç.');
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _imageBytes = bytes;
      _imageMime = mime;
      _consent = false;
      _analysis = null;
      _portionFactor = 1;
      _notice = 'Fotoğraf hazır. AI analizi için iznini onayla.';
    });
  }

  Future<void> _choose(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 78,
      );
      if (file != null) {
        await _loadImage(file);
      }
    } on FormatException catch (error) {
      if (mounted) {
        setState(() => _notice = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _notice =
              'Fotoğraf seçilemedi. Galeriden başka bir fotoğraf dene.',
        );
      }
    }
  }

  void _applyEstimate(double factor) {
    final value = _analysis;
    if (value == null) {
      return;
    }
    _calories.text = (value.caloriesKcal * factor).round().toString();
    _protein.text = (value.proteinG * factor).toStringAsFixed(1);
    _carbs.text = (value.carbsG * factor).toStringAsFixed(1);
    _fat.text = (value.fatG * factor).toStringAsFixed(1);
    _fiber.text = (value.fiberG * factor).toStringAsFixed(1);
  }

  Future<void> _analyze() async {
    if (_busy || !_consent || _imageBytes == null || _imageMime == null) {
      return;
    }
    final repository = ref.read(visionAnalysisRepositoryProvider);
    if (repository == null) {
      setState(
        () =>
            _notice = 'AI hizmeti yapılandırılmadı. Manuel kayıt yapabilirsin.',
      );
      return;
    }
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final result = await repository.analyze(
        imageBytes: _imageBytes!,
        mimeType: _imageMime!,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _analysis = result;
        _portionFactor = 1;
        _name.text = result.name;
        _notice = 'AI tahmini hazır. Miktarları kontrol edip düzelt.';
        _applyEstimate(1);
      });
    } catch (error) {
      if (mounted) {
        setState(() => _notice = visionErrorMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  static String _uuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  double? _parseDouble(TextEditingController field) =>
      double.tryParse(field.text.trim().replaceAll(',', '.'));

  String? _check(
    TextEditingController ctrl, {
    double max = 2000,
    bool integer = false,
  }) {
    final number = _parseDouble(ctrl);
    if (number == null ||
        !number.isFinite ||
        number < 0 ||
        number > max ||
        (integer && number != number.roundToDouble())) {
      return '0–${max.toInt()} arası geçerli sayı gir';
    }
    return null;
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) {
      return;
    }
    final calories = _parseDouble(_calories)!;
    if (calories <= 0) {
      setState(() => _notice = 'Öğün kalorisini sıfırdan büyük gir.');
      return;
    }
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final now = DateTime.now().toUtc();
      await ref
          .read(mealLogRepositoryProvider)
          .saveLocally(
            MealLog(
              id: _uuid(),
              userId: widget.userId,
              name: _name.text.trim(),
              loggedAt: now,
              updatedAt: now,
              mealType: _mealType,
              source: _analysis == null ? 'manual' : 'vision',
              caloriesKcal: calories.round(),
              proteinG: _parseDouble(_protein)!,
              carbsG: _parseDouble(_carbs)!,
              fatG: _parseDouble(_fat)!,
              fiberG: _parseDouble(_fiber)!,
              isEstimate: _analysis != null,
              visionAnalysis: _analysis?.scaled(_portionFactor),
            ),
          );
      _imageBytes = null;
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _notice = 'Öğün yerel veritabanına kaydedilemedi.');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Widget _nutritionField(
    String label,
    TextEditingController controller, {
    double max = 2000,
    bool integer = false,
  }) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: (_) => _check(controller, max: max, integer: integer),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Öğün günlüğü')),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                'Fotoğrafla veya manuel öğün ekle',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Fotoğraftan kalori ve vitaminler kesin ölçülemez. '
                'AI çıktısı tahmindir; tükettiğin porsiyonu mutlaka düzelt.',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _choose(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Fotoğraf çek'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _choose(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Galeriden seç'),
                    ),
                  ),
                ],
              ),
              if (_imageBytes != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    _imageBytes!,
                    height: 175,
                    fit: BoxFit.cover,
                  ),
                ),
                CheckboxListTile(
                  value: _consent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Fotoğrafımı AI analizine göndermeyi kabul ediyorum.',
                  ),
                  subtitle: const Text(
                    'Görsel Supabase Edge Function üzerinden Gemini’ye gönderilir; fotoğraf uygulamada kalıcı saklanmaz.',
                  ),
                  onChanged: _busy
                      ? null
                      : (v) => setState(() => _consent = v ?? false),
                ),
                FilledButton.icon(
                  key: const Key('analyze-meal'),
                  onPressed: _busy || !_consent ? null : _analyze,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('Fotoğrafı analiz et'),
                ),
              ],
              if (_busy)
                const Padding(
                  padding: EdgeInsets.all(14),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_notice != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _notice!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              if (_analysis != null) ...[
                const SizedBox(height: 14),
                Text(
                  'Tespit edilen besinler (tahmini)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final food in _analysis!.foods)
                  ListTile(
                    dense: true,
                    title: Text(food.name),
                    subtitle: Text(
                      '${food.grams.toStringAsFixed(0)} g · ${food.caloriesKcal} kcal',
                    ),
                  ),
                const SizedBox(height: 6),
                Text('Porsiyon çarpanı: ${_portionFactor.toStringAsFixed(2)}x'),
                Slider(
                  value: _portionFactor,
                  min: 0.5,
                  max: 3,
                  divisions: 10,
                  label: '${_portionFactor.toStringAsFixed(2)}x',
                  onChanged: _busy
                      ? null
                      : (value) => setState(() {
                          _portionFactor = value;
                          _applyEstimate(value);
                        }),
                ),
                Text(
                  'AI porsiyon tahmini: ${_analysis!.portionGrams.toStringAsFixed(0)} g',
                ),
                const SizedBox(height: 8),
                Text(
                  'Vitamin C: ${_displayVitamin(_scaledVitamin(_analysis!.vitaminCMg), 'mg')} · '
                  'A: ${_displayVitamin(_scaledVitamin(_analysis!.vitaminAMcg), 'µg')}',
                ),
                Text(
                  'Vitamin D: ${_displayVitamin(_scaledVitamin(_analysis!.vitaminDMcg), 'µg')} · '
                  'B12: ${_displayVitamin(_scaledVitamin(_analysis!.vitaminB12Mcg), 'µg')}',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_analysis!.caution),
                ),
              ],
              const SizedBox(height: 18),
              TextFormField(
                key: const Key('meal-name'),
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Öğün adı',
                  border: OutlineInputBorder(),
                ),
                maxLength: 200,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Öğün adı gir'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _mealType,
                decoration: const InputDecoration(
                  labelText: 'Öğün türü',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'breakfast', child: Text('Kahvaltı')),
                  DropdownMenuItem(value: 'lunch', child: Text('Öğle')),
                  DropdownMenuItem(value: 'dinner', child: Text('Akşam')),
                  DropdownMenuItem(value: 'snack', child: Text('Ara öğün')),
                  DropdownMenuItem(value: 'other', child: Text('Diğer')),
                ],
                onChanged: (v) => setState(() => _mealType = v ?? 'other'),
              ),
              const SizedBox(height: 12),
              _nutritionField(
                'Kalori (kcal)',
                _calories,
                max: 20000,
                integer: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _nutritionField('Protein (g)', _protein)),
                  const SizedBox(width: 8),
                  Expanded(child: _nutritionField('Karb. (g)', _carbs)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _nutritionField('Yağ (g)', _fat)),
                  const SizedBox(width: 8),
                  Expanded(child: _nutritionField('Lif (g)', _fiber)),
                ],
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                key: const Key('save-meal'),
                onPressed: _busy ? null : _save,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Öğünü kaydet'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Kaydetme önce Isar’a yapılır. Bulut eşitlemesi başarısız olursa kayıt cihazında korunur.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  double? _scaledVitamin(double? value) =>
      value == null ? null : value * _portionFactor;

  static String _displayVitamin(double? n, String unit) =>
      n == null ? 'bilinmiyor' : '${n.toStringAsFixed(1)} $unit (tahmini)';
}
