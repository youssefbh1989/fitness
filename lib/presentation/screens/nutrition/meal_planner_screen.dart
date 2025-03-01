
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/nutrition/nutrition_bloc.dart';
import '../../blocs/nutrition/nutrition_state.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/meal_plan_card.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({Key? key}) : super(key: key);

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Meal Planner',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: _days.map((day) => Tab(text: day)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _days.map((day) => _buildDayPlan(day)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-meal-plan');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDayPlan(String day) {
    return BlocBuilder<NutritionBloc, NutritionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // For now, we'll show dummy data
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMealSection('Breakfast', [
                {'name': 'Oatmeal with Berries', 'calories': '320', 'time': '08:00 AM'},
                {'name': 'Greek Yogurt with Honey', 'calories': '240', 'time': '08:30 AM'},
              ]),
              const SizedBox(height: 20),
              _buildMealSection('Lunch', [
                {'name': 'Grilled Chicken Salad', 'calories': '420', 'time': '12:30 PM'},
                {'name': 'Quinoa Bowl', 'calories': '380', 'time': '01:00 PM'},
              ]),
              const SizedBox(height: 20),
              _buildMealSection('Dinner', [
                {'name': 'Salmon with Vegetables', 'calories': '520', 'time': '07:00 PM'},
                {'name': 'Turkey and Avocado Wrap', 'calories': '450', 'time': '07:30 PM'},
              ]),
              const SizedBox(height: 20),
              _buildMealSection('Snacks', [
                {'name': 'Protein Shake', 'calories': '180', 'time': '10:30 AM'},
                {'name': 'Almonds and Fruit', 'calories': '210', 'time': '04:00 PM'},
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealSection(String title, List<Map<String, String>> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...meals.map((meal) => MealPlanCard(
          mealName: meal['name'] ?? '',
          calories: meal['calories'] ?? '',
          time: meal['time'] ?? '',
          onTap: () {
            Navigator.pushNamed(context, '/meal-detail');
          },
        )).toList(),
      ],
    );
  }
}
