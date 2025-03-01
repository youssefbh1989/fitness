
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NutritionCategoriesScreen extends StatelessWidget {
  const NutritionCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Breakfast',
        'icon': Icons.breakfast_dining,
        'color': Colors.orange,
        'count': 18,
      },
      {
        'name': 'Lunch',
        'icon': Icons.lunch_dining,
        'color': Colors.green,
        'count': 24,
      },
      {
        'name': 'Dinner',
        'icon': Icons.dinner_dining,
        'color': Colors.blue,
        'count': 20,
      },
      {
        'name': 'Snacks',
        'icon': Icons.cookie,
        'color': Colors.purple,
        'count': 12,
      },
      {
        'name': 'Smoothies',
        'icon': Icons.local_drink,
        'color': Colors.pink,
        'count': 8,
      },
      {
        'name': 'High Protein',
        'icon': Icons.fitness_center,
        'color': Colors.red,
        'count': 15,
      },
      {
        'name': 'Low Carb',
        'icon': Icons.grain,
        'color': Colors.teal,
        'count': 10,
      },
      {
        'name': 'Vegetarian',
        'icon': Icons.eco,
        'color': Colors.green.shade700,
        'count': 14,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            context,
            category['name'] as String,
            category['icon'] as IconData,
            category['color'] as Color,
            category['count'] as int,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
    int count,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/nutrition-list',
          arguments: name,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const Spacer(),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count meals',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
