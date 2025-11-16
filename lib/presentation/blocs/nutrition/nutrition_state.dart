import 'package:equatable/equatable.dart';
import '../../../domain/entities/nutrition.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  bool get isLoading => this is NutritionLoading;

  @override
  List<Object?> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class MealPlansLoaded extends NutritionState {
  final List<MealPlan> mealPlans;

  const MealPlansLoaded(this.mealPlans);

  @override
  List<Object?> get props => [mealPlans];
}

class NutritionCategoryLoaded extends NutritionState {
  final List<Nutrition> nutritionItems;
  final String category;

  const NutritionCategoryLoaded(this.nutritionItems, this.category);

  @override
  List<Object?> get props => [nutritionItems, category];
}

class MealPlanDetailsLoaded extends NutritionState {
  final MealPlan mealPlan;

  const MealPlanDetailsLoaded(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}

class MealPlanCreated extends NutritionState {
  final MealPlan mealPlan;

  const MealPlanCreated(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}

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

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object?> get props => [message];
}