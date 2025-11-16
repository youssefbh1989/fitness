import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/nutrition/nutrition_bloc.dart';
import '../../blocs/nutrition/nutrition_state.dart';
import '../../widgets/macro_nutrient_card.dart';
import '../../widgets/loading_widget.dart';

class NutritionTrackingScreen extends StatelessWidget {
  const NutritionTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to nutrition history
            },
          ),
        ],
      ),
      body: BlocBuilder<NutritionBloc, NutritionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDailyGoalCard(context),
                const SizedBox(height: 24),
                Text(
                  'Macronutrients',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: MacroNutrientCard(
                        label: 'Protein',
                        current: 85.5,
                        goal: 120,
                        color: Colors.blue,
                        icon: Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MacroNutrientCard(
                        label: 'Carbs',
                        current: 180,
                        goal: 250,
                        color: Colors.green,
                        icon: Icons.grain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MacroNutrientCard(
                  label: 'Fat',
                  current: 45,
                  goal: 70,
                  color: Colors.orange,
                  icon: Icons.water_drop,
                ),
                const SizedBox(height: 24),
                _buildMealsSummary(context),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-meal');
        },
        child: const Icon(Icons.add),
        tooltip: 'Log Meal',
      ),
    );
  }

  Widget _buildDailyGoalCard(BuildContext context) {
    const caloriesConsumed = 1650;
    const caloriesGoal = 2200;
    final percentage = caloriesConsumed / caloriesGoal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Calories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$caloriesConsumed / $caloriesGoal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(caloriesGoal - caloriesConsumed)} calories remaining',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Meals',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildMealSummaryItem(context, 'Breakfast', 420, Icons.wb_sunny),
        _buildMealSummaryItem(context, 'Lunch', 680, Icons.wb_cloudy),
        _buildMealSummaryItem(context, 'Dinner', 550, Icons.nightlight_round),
        _buildMealSummaryItem(context, 'Snacks', 200, Icons.cookie),
      ],
    );
  }

  Widget _buildMealSummaryItem(BuildContext context, String meal, int calories, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(meal),
        trailing: Text(
          '$calories cal',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Navigate to meal details
        },
      ),
    );
  }
}