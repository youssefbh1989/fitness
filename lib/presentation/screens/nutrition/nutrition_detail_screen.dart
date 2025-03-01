
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/nutrition.dart';
import '../../blocs/nutrition/nutrition_bloc.dart';
import '../../widgets/custom_app_bar.dart';

class NutritionDetailScreen extends StatefulWidget {
  final String nutritionPlanId;

  const NutritionDetailScreen({
    Key? key,
    required this.nutritionPlanId,
  }) : super(key: key);

  @override
  State<NutritionDetailScreen> createState() => _NutritionDetailScreenState();
}

class _NutritionDetailScreenState extends State<NutritionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NutritionBloc>().add(GetNutritionPlanById(widget.nutritionPlanId));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      body: BlocBuilder<NutritionBloc, NutritionState>(
        builder: (context, state) {
          if (state is NutritionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NutritionPlanDetailLoaded) {
            return _buildPlanDetail(context, state.nutritionPlan);
          } else if (state is NutritionError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  Widget _buildPlanDetail(BuildContext context, NutritionPlan plan) {
    return Stack(
      children: [
        // Cover image
        Container(
          height: SizeConfig.screenHeight * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(plan.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Content
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.35),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        plan.goal,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plan.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 15),
                    
                    // Nutrition facts
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Facts',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildNutritionFact(context, 'Calories', '${plan.calories} kcal', Colors.orange),
                              _buildNutritionFact(context, 'Protein', '${plan.protein}g', Colors.red),
                              _buildNutritionFact(context, 'Carbs', '${plan.carbs}g', Colors.blue),
                              _buildNutritionFact(context, 'Fat', '${plan.fat}g', Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      plan.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    
                    // Meals
                    Text(
                      'Meals',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),
                    
                    // Meals list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plan.meals.length,
                      itemBuilder: (context, index) {
                        final meal = plan.meals[index];
                        return _buildMealCard(context, meal);
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Save plan action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Plan saved to favorites')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('ADD TO MY PLAN', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Custom app bar
        const CustomAppBar(
          title: '',
          showBackButton: true,
          transparent: true,
        ),
      ],
    );
  }

  Widget _buildNutritionFact(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.circle,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, Meal meal) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Text(
        meal.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '${meal.calories} kcal',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meal.foods.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final food = meal.foods[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(food.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                food.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${food.serving} - ${food.calories} kcal',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                '${food.protein}g P | ${food.carbs}g C | ${food.fat}g F',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_button.dart';

class NutritionDetailScreen extends StatefulWidget {
  const NutritionDetailScreen({Key? key}) : super(key: key);

  @override
  State<NutritionDetailScreen> createState() => _NutritionDetailScreenState();
}

class _NutritionDetailScreenState extends State<NutritionDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  int _caloriesConsumed = 1450;
  int _caloriesGoal = 2000;
  int _proteinConsumed = 75;
  int _proteinGoal = 120;
  int _carbsConsumed = 180;
  int _carbsGoal = 250;
  int _fatConsumed = 45;
  int _fatGoal = 70;
  
  List<Meal> _meals = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDummyMeals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadDummyMeals() {
    _meals = [
      Meal(
        id: '1',
        name: 'Breakfast',
        time: '08:30 AM',
        foods: [
          Food(
            id: '1',
            name: 'Oatmeal with Banana',
            calories: 320,
            protein: 12,
            carbs: 58,
            fat: 6,
            quantity: 1,
            unit: 'bowl',
            imageUrl: 'assets/images/nutrition_1.jpg',
          ),
          Food(
            id: '2',
            name: 'Greek Yogurt',
            calories: 150,
            protein: 15,
            carbs: 8,
            fat: 5,
            quantity: 1,
            unit: 'cup',
            imageUrl: 'assets/images/nutrition_2.jpg',
          ),
        ],
      ),
      Meal(
        id: '2',
        name: 'Lunch',
        time: '01:15 PM',
        foods: [
          Food(
            id: '3',
            name: 'Grilled Chicken Salad',
            calories: 450,
            protein: 35,
            carbs: 30,
            fat: 20,
            quantity: 1,
            unit: 'plate',
            imageUrl: 'assets/images/nutrition_3.jpg',
          ),
          Food(
            id: '4',
            name: 'Whole Grain Bread',
            calories: 80,
            protein: 3,
            carbs: 15,
            fat: 1,
            quantity: 1,
            unit: 'slice',
            imageUrl: 'assets/images/nutrition_4.jpg',
          ),
        ],
      ),
      Meal(
        id: '3',
        name: 'Snack',
        time: '04:30 PM',
        foods: [
          Food(
            id: '5',
            name: 'Apple',
            calories: 95,
            protein: 0,
            carbs: 25,
            fat: 0,
            quantity: 1,
            unit: 'medium',
            imageUrl: 'assets/images/nutrition_5.jpg',
          ),
          Food(
            id: '6',
            name: 'Almonds',
            calories: 165,
            protein: 6,
            carbs: 6,
            fat: 14,
            quantity: 23,
            unit: 'nuts',
            imageUrl: 'assets/images/nutrition_6.jpg',
          ),
        ],
      ),
      Meal(
        id: '4',
        name: 'Dinner',
        time: '07:45 PM',
        foods: [
          Food(
            id: '7',
            name: 'Salmon Fillet',
            calories: 190,
            protein: 22,
            carbs: 0,
            fat: 10,
            quantity: 100,
            unit: 'g',
            imageUrl: 'assets/images/nutrition_7.jpg',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracking'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Diary'),
            Tab(text: 'Meals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildDiaryTab(),
          _buildMealsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFoodOrMeal,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSelector(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildCaloriesSummary(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildMacronutrientsSummary(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildWaterIntake(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          _buildMealsList(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
            });
          },
        ),
        GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
          child: Text(
            DateFormat('EEEE, MMMM d').format(_selectedDate),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: _selectedDate.isBefore(DateTime.now()) ? () {
            setState(() {
              _selectedDate = _selectedDate.add(const Duration(days: 1));
            });
          } : null,
          color: _selectedDate.isBefore(DateTime.now()) ? null : Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildCaloriesSummary() {
    final caloriesLeft = _caloriesGoal - _caloriesConsumed;
    final percentConsumed = (_caloriesConsumed / _caloriesGoal).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calories',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$_caloriesConsumed / $_caloriesGoal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Remaining',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$caloriesLeft',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          LinearProgressIndicator(
            value: percentConsumed,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildMacronutrientsSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macronutrients',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          children: [
            Expanded(
              child: _buildMacronutrientItem(
                'Protein',
                _proteinConsumed,
                _proteinGoal,
                Colors.red,
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth! * 0.04),
            Expanded(
              child: _buildMacronutrientItem(
                'Carbs',
                _carbsConsumed,
                _carbsGoal,
                Colors.green,
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth! * 0.04),
            Expanded(
              child: _buildMacronutrientItem(
                'Fat',
                _fatConsumed,
                _fatGoal,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacronutrientItem(String name, int consumed, int goal, Color color) {
    final percentConsumed = (consumed / goal).clamp(0.0, 1.0);
    
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    value: percentConsumed,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeWidth: 8,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '$consumed/$goal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Text(
          name,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${(consumed / goal * 100).toInt()}%',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWaterIntake() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Water Intake',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '5/8 glasses',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(8, (index) {
            return GestureDetector(
              onTap: () {
                // Implement water tracking logic here
              },
              child: Container(
                width: SizeConfig.screenWidth! * 0.09,
                height: 50,
                decoration: BoxDecoration(
                  color: index < 5 ? Theme.of(context).primaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.water_drop,
                  color: index < 5 ? Colors.white : Colors.grey[400],
                  size: 20,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Meals',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _meals.length,
          itemBuilder: (context, index) {
            final meal = _meals[index];
            int mealCalories = 0;
            for (var food in meal.foods) {
              mealCalories += food.calories;
            }
            
            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$mealCalories cal',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Text(meal.time),
              children: [
                ...meal.foods.map((food) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(food.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(food.name),
                  subtitle: Text('${food.quantity} ${food.unit}'),
                  trailing: Text(
                    '${food.calories} cal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // View food details
                  },
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Add food to this meal
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Food'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDiaryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Text(
            'Nutrition Diary',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.1),
            child: Text(
              'Track your nutrition over time to see your progress and patterns',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          CustomButton(
            text: 'View Weekly Report',
            onPressed: () {
              // Navigate to weekly report screen
            },
            width: SizeConfig.screenWidth! * 0.6,
          ),
        ],
      ),
    );
  }

  Widget _buildMealsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02),
          Text(
            'Meal Library',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.1),
            child: Text(
              'Create and save your favorite meals for quick logging',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          CustomButton(
            text: 'Create New Meal',
            onPressed: () {
              // Navigate to meal creation screen
            },
            width: SizeConfig.screenWidth! * 0.6,
          ),
        ],
      ),
    );
  }

  void _addFoodOrMeal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add to Diary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text('Add Food'),
              subtitle: const Text('Search our food database'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to add food screen
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.dinner_dining,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text('Create Meal'),
              subtitle: const Text('Combine foods into a meal'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to create meal screen
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: const Text('My Saved Foods'),
              subtitle: const Text('Choose from your favorites'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to saved foods screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Meal {
  final String id;
  final String name;
  final String time;
  final List<Food> foods;

  Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.foods,
  });
}

class Food {
  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final num quantity;
  final String unit;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });
}
