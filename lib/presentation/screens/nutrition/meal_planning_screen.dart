
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/meal.dart';
import '../../widgets/meal_card.dart';
import '../../blocs/nutrition/nutrition_bloc.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({Key? key}) : super(key: key);

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  String _selectedDay = 'Monday';
  
  @override
  void initState() {
    super.initState();
    context.read<NutritionBloc>().add(FetchMealPlanEvent(day: _selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddMealDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelectorBar(),
          Expanded(
            child: BlocBuilder<NutritionBloc, NutritionState>(
              builder: (context, state) {
                if (state is NutritionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MealPlanLoaded) {
                  if (state.meals.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildMealList(state.meals);
                } else if (state is NutritionError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGenerateMealPlanDialog(),
        child: const Icon(Icons.auto_awesome),
        tooltip: 'Generate Meal Plan',
      ),
    );
  }

  Widget _buildDaySelectorBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final day = _days[index];
          final isSelected = day == _selectedDay;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
              });
              context.read<NutritionBloc>().add(FetchMealPlanEvent(day: day));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  day.substring(0, 3),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealList(List<Meal> meals) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: MealCard(
            meal: meal,
            onTap: () => _showMealDetailsDialog(meal),
            onDelete: () {
              context.read<NutritionBloc>().add(
                DeleteMealEvent(mealId: meal.id, day: _selectedDay),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No meals planned for $_selectedDay',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add a Meal'),
            onPressed: () => _showAddMealDialog(),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final timeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
                value: 'Breakfast',
                items: const [
                  DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                  DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  DropdownMenuItem(value: 'Snack', child: Text('Snack')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Meal Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 8:00 AM)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  caloriesController.text.isNotEmpty &&
                  timeController.text.isNotEmpty) {
                final meal = Meal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  calories: int.tryParse(caloriesController.text) ?? 0,
                  type: 'Breakfast', // Default
                  time: timeController.text,
                  day: _selectedDay,
                  imageUrl: 'assets/images/meal_placeholder.jpg',
                  ingredients: [],
                  macros: {
                    'protein': 20,
                    'carbs': 30,
                    'fat': 10,
                  },
                );

                context.read<NutritionBloc>().add(
                  AddMealEvent(meal: meal, day: _selectedDay),
                );
                
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMealDetailsDialog(Meal meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meal.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meal.imageUrl.isNotEmpty)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: meal.imageUrl.startsWith('assets/')
                          ? AssetImage(meal.imageUrl) as ImageProvider
                          : NetworkImage(meal.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Time: ${meal.time}', style: Theme.of(context).textTheme.bodyLarge),
              Text('Calories: ${meal.calories}', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Text('Macronutrients:', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMacroNutrient('Protein', meal.macros['protein'] ?? 0, Colors.red),
                  _buildMacroNutrient('Carbs', meal.macros['carbs'] ?? 0, Colors.green),
                  _buildMacroNutrient('Fat', meal.macros['fat'] ?? 0, Colors.blue),
                ],
              ),
              const SizedBox(height: 16),
              if (meal.ingredients.isNotEmpty) ...[
                Text('Ingredients:', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...meal.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record, size: 8),
                      const SizedBox(width: 8),
                      Text(ingredient),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editMeal(meal);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroNutrient(String name, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color.withOpacity(0.2),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text('$name: ${value}g', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
  
  void _editMeal(Meal meal) {
    // Edit meal implementation
    // This would be similar to add meal dialog but pre-populated
  }
  
  void _showGenerateMealPlanDialog() {
    final caloriesController = TextEditingController(text: '2000');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Meal Plan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Generate a balanced meal plan based on your daily calorie target',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Daily Calories Target',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Diet Preference',
                  border: OutlineInputBorder(),
                ),
                value: 'Balanced',
                items: const [
                  DropdownMenuItem(value: 'Balanced', child: Text('Balanced')),
                  DropdownMenuItem(value: 'High Protein', child: Text('High Protein')),
                  DropdownMenuItem(value: 'Low Carb', child: Text('Low Carb')),
                  DropdownMenuItem(value: 'Vegetarian', child: Text('Vegetarian')),
                  DropdownMenuItem(value: 'Vegan', child: Text('Vegan')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final calories = int.tryParse(caloriesController.text) ?? 2000;
              
              context.read<NutritionBloc>().add(
                GenerateMealPlanEvent(
                  day: _selectedDay, 
                  calories: calories,
                  dietType: 'Balanced',
                ),
              );
              
              Navigator.pop(context);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generating your meal plan...'),
                    ],
                  ),
                ),
              );
              
              // Close loading dialog after 2 seconds (in real app, this would be after API response)
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
              });
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}
