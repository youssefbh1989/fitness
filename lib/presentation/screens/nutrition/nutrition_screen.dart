
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/size_config.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateTime _selectedDate = DateTime.now();
  
  // Sample nutrition data - in a real app this would come from a bloc/provider
  final Map<String, List<Map<String, dynamic>>> _meals = {
    'Breakfast': [
      {'name': 'Oatmeal with Berries', 'calories': 320, 'protein': 12, 'carbs': 56, 'fat': 6},
      {'name': 'Greek Yogurt', 'calories': 150, 'protein': 15, 'carbs': 8, 'fat': 4},
    ],
    'Lunch': [
      {'name': 'Grilled Chicken Salad', 'calories': 380, 'protein': 35, 'carbs': 20, 'fat': 15},
    ],
    'Dinner': [
      {'name': 'Salmon with Vegetables', 'calories': 420, 'protein': 38, 'carbs': 24, 'fat': 18},
    ],
    'Snacks': [
      {'name': 'Apple', 'calories': 95, 'protein': 0.5, 'carbs': 25, 'fat': 0.3},
      {'name': 'Almonds (1oz)', 'calories': 170, 'protein': 6, 'carbs': 6, 'fat': 14},
    ],
  };
  
  // Water tracking data
  int _waterGlasses = 4;
  final int _waterGoal = 8;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Meal Tracker'),
            Tab(text: 'Water Intake'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMealTracker(),
          _buildWaterTracker(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealTracker() {
    // Calculate total nutrition for the day
    int totalCalories = 0;
    double totalProtein = 0, totalCarbs = 0, totalFat = 0;
    
    _meals.forEach((mealType, foods) {
      for (var food in foods) {
        totalCalories += food['calories'] as int;
        totalProtein += food['protein'] as double;
        totalCarbs += food['carbs'] as double;
        totalFat += food['fat'] as double;
      }
    });
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          _buildNutritionSummary(totalCalories, totalProtein, totalCarbs, totalFat),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          ..._meals.entries.map((entry) => _buildMealSection(entry.key, entry.value)).toList(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              // Previous day logic
            },
          ),
          Text(
            DateFormat('EEEE, MMMM d').format(_selectedDate),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              // Next day logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary(int calories, double protein, double carbs, double fat) {
    // Daily goals - in a real app these would be user settings
    final int calorieGoal = 2200;
    final double proteinGoal = 120;
    final double carbsGoal = 250;
    final double fatGoal = 70;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$calories / $calorieGoal kcal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          LinearProgressIndicator(
            value: calories / calorieGoal,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutrientItem(name: 'Protein', value: protein, goal: proteinGoal, color: Colors.amber),
              _buildNutrientItem(name: 'Carbs', value: carbs, goal: carbsGoal, color: Colors.green),
              _buildNutrientItem(name: 'Fat', value: fat, goal: fatGoal, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientItem({
    required String name, 
    required double value, 
    required double goal,
    required Color color
  }) {
    return Column(
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.005),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value / goal,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeWidth: 6,
              ),
              Text(
                '${value.toInt()}g',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.005),
        Text(
          '${goal.toInt()}g',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(String mealType, List<Map<String, dynamic>> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _showAddFoodDialog(mealType),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        ...foods.map((food) => _buildFoodItem(food, mealType)).toList(),
        const Divider(),
      ],
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food, String mealType) {
    return Dismissible(
      key: Key('${food['name']}_${DateTime.now().millisecondsSinceEpoch}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _meals[mealType]!.remove(food);
        });
      },
      child: ListTile(
        title: Text(food['name']),
        subtitle: Text('${food['calories']} kcal'),
        trailing: Text(
          'P: ${food['protein']}g | C: ${food['carbs']}g | F: ${food['fat']}g',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildWaterTracker() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Daily Water Intake',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _waterGlasses / _waterGoal,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 15,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$_waterGlasses',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of $_waterGoal glasses',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildWaterButton(icon: Icons.remove, onPressed: () {
                    setState(() {
                      if (_waterGlasses > 0) _waterGlasses--;
                    });
                  }),
                  const SizedBox(width: 30),
                  _buildWaterButton(icon: Icons.add, onPressed: () {
                    setState(() {
                      if (_waterGlasses < _waterGoal * 2) _waterGlasses++;
                    });
                  }),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                'Recommendation: 8 glasses (2L) daily',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Text(
            'Staying hydrated helps improve energy levels, brain function, and physical performance.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterButton({required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.blue,
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddFoodDialog('Breakfast');
              },
              child: const Text('Breakfast'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddFoodDialog('Lunch');
              },
              child: const Text('Lunch'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddFoodDialog('Dinner');
              },
              child: const Text('Dinner'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddFoodDialog('Snacks');
              },
              child: const Text('Snack'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddFoodDialog(String mealType) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController carbsController = TextEditingController();
    final TextEditingController fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Food to $mealType'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                ),
              ),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories (kcal)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proteinController,
                decoration: const InputDecoration(
                  labelText: 'Protein (g)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: carbsController,
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: fatController,
                decoration: const InputDecoration(
                  labelText: 'Fat (g)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && caloriesController.text.isNotEmpty) {
                setState(() {
                  _meals[mealType]!.add({
                    'name': nameController.text,
                    'calories': int.tryParse(caloriesController.text) ?? 0,
                    'protein': double.tryParse(proteinController.text) ?? 0,
                    'carbs': double.tryParse(carbsController.text) ?? 0,
                    'fat': double.tryParse(fatController.text) ?? 0,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
