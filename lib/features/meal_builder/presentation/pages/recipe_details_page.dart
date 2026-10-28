import 'package:flutter/material.dart';
import 'package:nutri_buddy/features/meal_builder/domain/entities/meal_recipe.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({required this.recipe, super.key});

  final MealRecipe recipe;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tarif ayrıntıları')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(recipe.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(recipe.description),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Chip(label: Text('${recipe.caloriesKcal} kcal')),
              Chip(label: Text('${recipe.proteinG.round()} g protein')),
              Chip(label: Text('${recipe.carbsG.round()} g karbonhidrat')),
              Chip(label: Text('${recipe.fatG.round()} g yağ')),
              Chip(label: Text('${recipe.prepMinutes} dk')),
            ],
          ),
          const SizedBox(height: 14),
          Text('Malzemeler', style: Theme.of(context).textTheme.titleLarge),
          for (final item in recipe.ingredients)
            ListTile(
              dense: true,
              leading: const Icon(Icons.check_box_outline_blank, size: 19),
              title: Text(item.name),
              subtitle: Text(
                '${item.quantity} • ${item.grams.round()} g (tahmini)',
              ),
            ),
          const SizedBox(height: 10),
          Text('Hazırlanışı', style: Theme.of(context).textTheme.titleLarge),
          for (var i = 0; i < recipe.steps.length; i++)
            ListTile(
              leading: CircleAvatar(radius: 15, child: Text('${i + 1}')),
              title: Text(recipe.steps[i]),
            ),
          const SizedBox(height: 12),
          Text(recipe.caution, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          const Text(
            'Bu tarif ve besin değerleri AI tahminidir. Alerjenler, '
            'içerik etiketleri ve çapraz bulaşma ayrıca kontrol edilmelidir. '
            'Tıbbi diyet tavsiyesi değildir.',
          ),
        ],
      ),
    ),
  );
}
