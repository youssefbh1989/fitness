import 'package:equatable/equatable.dart';
import '../../../domain/entities/meal.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object?> get props => [];
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

class LogMealEvent extends NutritionEvent {
  final Meal meal;
  const LogMealEvent({required this.meal});

  @override
  List<Object> get props => [meal];
}

class GetTodayMealsEvent extends NutritionEvent {
  const GetTodayMealsEvent();
}

class DeleteMealEvent extends NutritionEvent {
  final String mealId;
  const DeleteMealEvent({required this.mealId});

  @override
  List<Object> get props => [mealId];
}

class FetchMealPlanEvent extends NutritionEvent {
  final String day;
  const FetchMealPlanEvent({required this.day});

  @override
  List<Object> get props => [day];
}

class AddMealEvent extends NutritionEvent {
  final Meal meal;
  final String day;
  const AddMealEvent({required this.meal, required this.day});

  @override
  List<Object> get props => [meal, day];
}

class GenerateMealPlanEvent extends NutritionEvent {
  final String day;
  final int calories;
  final String dietType;
  const GenerateMealPlanEvent({
    required this.day,
    required this.calories,
    required this.dietType,
  });

  @override
  List<Object> get props => [day, calories, dietType];
}