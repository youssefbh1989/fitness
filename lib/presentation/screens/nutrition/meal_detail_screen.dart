
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Meal Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1547592180-85f173990554?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grilled Chicken Salad',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '12:30 PM',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '420 calories',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildNutritionInfo(context),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildIngredientsList(context),
                  const SizedBox(height: 24),
                  Text(
                    'Preparation Steps',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPreparationSteps(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem(context, 'Protein', '32g'),
          _buildNutritionItem(context, 'Carbs', '45g'),
          _buildNutritionItem(context, 'Fat', '12g'),
          _buildNutritionItem(context, 'Fiber', '8g'),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(BuildContext context) {
    final ingredients = [
      '2 chicken breasts',
      '2 cups mixed greens',
      '1/2 cup cherry tomatoes',
      '1/4 cup sliced cucumber',
      '1/4 cup sliced red onion',
      '1/4 cup feta cheese',
      '2 tbsp olive oil',
      '1 tbsp lemon juice',
      'Salt and pepper to taste',
    ];

    return Column(
      children: ingredients.map((ingredient) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.fiber_manual_record,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(ingredient),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreparationSteps(BuildContext context) {
    final steps = [
      'Season chicken breasts with salt and pepper.',
      'Grill chicken for 6-7 minutes per side or until fully cooked.',
      'Let chicken rest for 5 minutes, then slice into strips.',
      'In a large bowl, combine mixed greens, tomatoes, cucumber, and red onion.',
      'In a small bowl, whisk together olive oil, lemon juice, salt, and pepper.',
      'Add sliced chicken to the salad, drizzle with dressing, and sprinkle with feta cheese.',
      'Serve immediately and enjoy!',
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(step),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
