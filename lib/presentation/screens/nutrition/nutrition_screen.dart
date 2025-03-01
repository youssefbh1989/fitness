
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _waterIntake = 0;
  final int _waterGoal = 8;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Nutrition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Meals'),
            Tab(text: 'Water'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealDialog();
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyTab(),
          _buildMealsTab(),
          _buildWaterTab(),
        ],
      ),
    );
  }

  Widget _buildDailyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCaloriesSummary(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildMacronutrients(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildTodaysMeals(),
        ],
      ),
    );
  }

  Widget _buildCaloriesSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCalorieItem(title: 'Goal', value: '2,000', color: Colors.blue),
          _buildCalorieItem(title: 'Food', value: '1,456', color: Colors.green),
          _buildCalorieItem(title: 'Exercise', value: '350', color: Colors.orange),
          _buildCalorieItem(title: 'Remaining', value: '894', color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Widget _buildCalorieItem({required String title, required String value, required Color color}) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildMacronutrients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrients',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMacroItem(
                title: 'Protein',
                value: '85g',
                goal: '120g',
                progress: 0.7,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMacroItem(
                title: 'Carbs',
                value: '180g',
                goal: '250g',
                progress: 0.72,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildMacroItem(
                title: 'Fat',
                value: '45g',
                goal: '65g',
                progress: 0.69,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroItem({
    required String title,
    required String value,
    required String goal,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                goal,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Meals',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 12),
        _buildMealCard(
          title: 'Breakfast',
          time: '8:00 AM',
          calories: 450,
          items: ['Greek Yogurt', 'Oatmeal with Fruits', 'Coffee'],
        ),
        SizedBox(height: 12),
        _buildMealCard(
          title: 'Lunch',
          time: '1:00 PM',
          calories: 650,
          items: ['Grilled Chicken Salad', 'Whole Grain Bread', 'Apple'],
        ),
        SizedBox(height: 12),
        _buildMealCard(
          title: 'Snack',
          time: '4:00 PM',
          calories: 180,
          items: ['Protein Bar', 'Mixed Nuts'],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 12),
              Text(
                'Add Dinner',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard({
    required String title,
    required String time,
    required int calories,
    required List<String> items,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(item),
                  ],
                ),
              )),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$calories calories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealsTab() {
    List<String> mealCategories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    
    return ListView.builder(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      itemCount: mealCategories.length,
      itemBuilder: (context, index) {
        return _buildMealCategoryCard(mealCategories[index]);
      },
    );
  }

  Widget _buildMealCategoryCard(String category) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suggested Meals',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(
                'Favorites',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                4,
                (index) => Container(
                  margin: EdgeInsets.only(right: 12),
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/nutrition_${index + 1}.jpg',
                          height: 100,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              width: 140,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image_not_supported, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        getMealSuggestion(category, index),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${150 + (index * 50)} calories',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              _showAddMealDialog();
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('Add $category'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getMealSuggestion(String category, int index) {
    if (category == 'Breakfast') {
      List<String> suggestions = [
        'Greek Yogurt with Honey',
        'Avocado Toast with Eggs',
        'Oatmeal with Berries',
        'Protein Smoothie Bowl'
      ];
      return suggestions[index];
    } else if (category == 'Lunch') {
      List<String> suggestions = [
        'Chicken Wrap with Veggies',
        'Quinoa Salad Bowl',
        'Turkey & Avocado Sandwich',
        'Mediterranean Bowl'
      ];
      return suggestions[index];
    } else if (category == 'Dinner') {
      List<String> suggestions = [
        'Grilled Salmon with Veggies',
        'Lean Beef Stir Fry',
        'Vegetable & Chicken Curry',
        'Zucchini Pasta with Meatballs'
      ];
      return suggestions[index];
    } else {
      List<String> suggestions = [
        'Greek Yogurt & Berries',
        'Protein Bar',
        'Apple with Almond Butter',
        'Veggie Sticks with Hummus'
      ];
      return suggestions[index];
    }
  }

  Widget _buildWaterTab() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Daily Water Intake',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Goal: 8 glasses (2L)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  value: _waterIntake / _waterGoal,
                  strokeWidth: 15,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$_waterIntake / $_waterGoal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'glasses',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _waterIntake > 0
                    ? () {
                        setState(() {
                          _waterIntake--;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.red,
                ),
                child: Icon(Icons.remove, color: Colors.white),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _waterIntake < _waterGoal
                    ? () {
                        setState(() {
                          _waterIntake++;
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.blue,
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(
                      'Why water matters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Staying hydrated helps your body regulate temperature, prevent infections, deliver nutrients to cells, and keep organs functioning properly.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: SizeConfig.screenHeight! * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Food',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Recent Foods',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Food Item ${index + 1}'),
                      subtitle: Text('${(index + 1) * 50} calories'),
                      trailing: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          // Add food to log
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
