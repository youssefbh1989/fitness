import 'package:equatable/equatable.dart';
import '../../../domain/entities/nutrition.dart';
import '../../../domain/entities/meal.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  bool get isLoading => this is NutritionLoading;

  @override
  List<Object?> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionPlansLoaded extends NutritionState {
  final List<NutritionPlan> nutritionPlans;

  const NutritionPlansLoaded(this.nutritionPlans);

  @override
  List<Object> get props => [nutritionPlans];
}

class NutritionPlanDetailLoaded extends NutritionState {
  final NutritionPlan nutritionPlan;

  const NutritionPlanDetailLoaded(this.nutritionPlan);

  @override
  List<Object> get props => [nutritionPlan];
}

class NutritionGoalsLoaded extends NutritionState {
  final List<String> goals;

  const NutritionGoalsLoaded(this.goals);

  @override
  List<Object> get props => [goals];
}

class MealPlansLoaded extends NutritionState {
  final List<MealPlan> mealPlans;

  const MealPlansLoaded(this.mealPlans);

  @override
  List<Object?> get props => [mealPlans];
}

class MealPlanLoaded extends NutritionState {
  final List<Meal> meals;

  const MealPlanLoaded(this.meals);

  @override
  List<Object> get props => [meals];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object?> get props => [message];
}