import 'package:equatable/equatable.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object> get props => [];
}

class GetNutritionPlans extends NutritionEvent {
  const GetNutritionPlans();
}

class GetNutritionPlanById extends NutritionEvent {
  final String id;

  const GetNutritionPlanById(this.id);

  @override
  List<Object> get props => [id];
}

class GetNutritionPlansByGoal extends NutritionEvent {
  final String goal;

  const GetNutritionPlansByGoal(this.goal);

  @override
  List<Object> get props => [goal];
}

class GetNutritionGoals extends NutritionEvent {
  const GetNutritionGoals();
}

class GetNutritionPlanDetail extends NutritionEvent {
  final String id;

  const GetNutritionPlanDetail(this.id);

  @override
  List<Object> get props => [id];
}

class LoadNutritionPlans extends NutritionEvent {
  final String userId;

  const LoadNutritionPlans({required this.userId});

  @override
  List<Object> get props => [userId];
}
import 'package:equatable/equatable.dart';
import '../../../domain/entities/nutrition.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object?> get props => [];
}

class GetMealPlansEvent extends NutritionEvent {}

class GetNutritionByCategoryEvent extends NutritionEvent {
  final String category;

  const GetNutritionByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class GetMealPlanDetailsEvent extends NutritionEvent {
  final String id;

  const GetMealPlanDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateMealPlanEvent extends NutritionEvent {
  final MealPlan mealPlan;

  const CreateMealPlanEvent(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}
