import 'package:equatable/equatable.dart';

class NutritionPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String goal;
  final List<MealPlan> meals;
  final bool isPremium;

  const NutritionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.goal,
    required this.meals,
    this.isPremium = false,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, goal, meals, isPremium];
}

class MealPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<DailyMeal> dailyMeals;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  const MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.dailyMeals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, dailyMeals, totalCalories, totalProtein, totalCarbs, totalFat];
}

class DailyMeal extends Equatable {
  final String id;
  final String day;
  final List<Meal> meals;

  const DailyMeal({
    required this.id,
    required this.day,
    required this.meals,
  });

  @override
  List<Object?> get props => [id, day, meals];
}

class Meal extends Equatable {
  final String id;
  final String name;
  final String type;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String time;
  final String imageUrl;
  final List<String> ingredients;
  final Map<String, int> macros;

  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
    required this.imageUrl,
    required this.ingredients,
    required this.macros,
  });

  @override
  List<Object?> get props => [id, name, type, calories, protein, carbs, fat, time, imageUrl, ingredients, macros];
}

class Nutrition extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> ingredients;
  final List<String> instructions;
  final int preparationTime;
  final bool isFavorite;

  const Nutrition({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.instructions,
    required this.preparationTime,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, category, calories, protein, carbs, fat, ingredients, instructions, preparationTime, isFavorite];
}

class NutritionItem extends Equatable {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;
  final String category;
  final String? imageUrl;

  const NutritionItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, calories, protein, carbs, fat, servingSize, category, imageUrl];
}