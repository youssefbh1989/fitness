import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/nutrition.dart';
import '../../blocs/nutrition/nutrition_bloc.dart';
import '../../routes/app_router.dart';
import '../../widgets/custom_app_bar.dart';

class NutritionListScreen extends StatefulWidget {
  const NutritionListScreen({Key? key}) : super(key: key);

  @override
  State<NutritionListScreen> createState() => _NutritionListScreenState();
}

class _NutritionListScreenState extends State<NutritionListScreen> {
  String _selectedGoal = 'All';
  List<String> _nutritionGoals = ['All'];

  @override
  void initState() {
    super.initState();
    context.read<NutritionBloc>().add(const GetNutritionPlans());
    context.read<NutritionBloc>().add(const GetNutritionGoals());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nutrition Plans',
        showBackButton: true,
      ),
      body: BlocConsumer<NutritionBloc, NutritionState>(
        listener: (context, state) {
          if (state is NutritionGoalsLoaded) {
            setState(() {
              _nutritionGoals = ['All', ...state.goals];
            });
          }
        },
        builder: (context, state) {
          if (state is NutritionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NutritionPlansLoaded) {
            return _buildContent(context, state.nutritionPlans);
          } else if (state is NutritionError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.mealPlanner); // Route to Meal Planner Screen
        },
        icon: const Icon(Icons.restaurant_menu),
        label: const Text('Meal Planner'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<NutritionPlan> nutritionPlans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Goal filter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Filter by Goal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nutritionGoals.length,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemBuilder: (context, index) {
              final goal = _nutritionGoals[index];
              final isSelected = goal == _selectedGoal;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(goal),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedGoal = goal;
                      });

                      if (goal == 'All') {
                        context.read<NutritionBloc>().add(const GetNutritionPlans());
                      } else {
                        context.read<NutritionBloc>().add(GetNutritionPlansByGoal(goal));
                      }
                    }
                  },
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),

        // Nutrition plans
        Expanded(
          child: nutritionPlans.isEmpty
              ? const Center(child: Text('No nutrition plans available'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: nutritionPlans.length,
                  itemBuilder: (context, index) {
                    final plan = nutritionPlans[index];
                    return _buildNutritionPlanCard(context, plan);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNutritionPlanCard(BuildContext context, NutritionPlan plan) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.nutritionDetailRoute,
          arguments: plan.id,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(plan.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal tag
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

                  // Title
                  Text(
                    plan.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),

                  // Description
                  Text(
                    plan.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 15),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat(context, '${plan.calories} kcal', 'Calories'),
                      _buildStat(context, '${plan.protein}g', 'Protein'),
                      _buildStat(context, '${plan.carbs}g', 'Carbs'),
                      _buildStat(context, '${plan.fat}g', 'Fat'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
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
}