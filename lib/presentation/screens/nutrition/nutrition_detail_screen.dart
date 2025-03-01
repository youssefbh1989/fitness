
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
