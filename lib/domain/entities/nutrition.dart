
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'goal': goal,
      'meals': meals.map((m) => m.toJson()).toList(),
      'isPremium': isPremium,
    };
  }

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      goal: json['goal'],
      meals: (json['meals'] as List).map((m) => MealPlan.fromJson(m)).toList(),
      isPremium: json['isPremium'] ?? false,
    );
  }

  NutritionPlan copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? goal,
    List<MealPlan>? meals,
    bool? isPremium,
  }) {
    return NutritionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      goal: goal ?? this.goal,
      meals: meals ?? this.meals,
      isPremium: isPremium ?? this.isPremium,
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'dailyMeals': dailyMeals.map((d) => d.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      dailyMeals: (json['dailyMeals'] as List).map((d) => DailyMeal.fromJson(d)).toList(),
      totalCalories: json['totalCalories'],
      totalProtein: json['totalProtein'].toDouble(),
      totalCarbs: json['totalCarbs'].toDouble(),
      totalFat: json['totalFat'].toDouble(),
    );
  }

  MealPlan copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<DailyMeal>? dailyMeals,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
    );
  }

  @override
  List<Object?> get props => [id, name, description, imageUrl, dailyMeals, totalCalories, totalProtein, totalCarbs, totalFat];
}

class DailyMeal extends Equatable {
  final String id;
  final String day;
  final List<MealPlanItem> meals;

  const DailyMeal({
    required this.id,
    required this.day,
    required this.meals,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'meals': meals.map((m) => m.toJson()).toList(),
    };
  }

  factory DailyMeal.fromJson(Map<String, dynamic> json) {
    return DailyMeal(
      id: json['id'],
      day: json['day'],
      meals: (json['meals'] as List).map((m) => MealPlanItem.fromJson(m)).toList(),
    );
  }

  DailyMeal copyWith({
    String? id,
    String? day,
    List<MealPlanItem>? meals,
  }) {
    return DailyMeal(
      id: id ?? this.id,
      day: day ?? this.day,
      meals: meals ?? this.meals,
    );
  }

  @override
  List<Object?> get props => [id, day, meals];
}

// Renamed from Meal to MealPlanItem to avoid conflict with lib/domain/entities/meal.dart
class MealPlanItem extends Equatable {
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

  const MealPlanItem({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'time': time,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
    };
  }

  factory MealPlanItem.fromJson(Map<String, dynamic> json) {
    return MealPlanItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      time: json['time'],
      imageUrl: json['imageUrl'],
      ingredients: List<String>.from(json['ingredients']),
    );
  }

  MealPlanItem copyWith({
    String? id,
    String? name,
    String? type,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? time,
    String? imageUrl,
    List<String>? ingredients,
  }) {
    return MealPlanItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      time: time ?? this.time,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  List<Object?> get props => [id, name, type, calories, protein, carbs, fat, time, imageUrl, ingredients];
}

class Nutrition extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String category;
  final String servingSize;
  final List<String>? ingredients;
  final String? instructions;

  const Nutrition({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
    required this.servingSize,
    this.ingredients,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'category': category,
      'servingSize': servingSize,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      category: json['category'],
      servingSize: json['servingSize'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      instructions: json['instructions'],
    );
  }

  Nutrition copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? category,
    String? servingSize,
    List<String>? ingredients,
    String? instructions,
  }) {
    return Nutrition(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      category: category ?? this.category,
      servingSize: servingSize ?? this.servingSize,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
    id, name, description, imageUrl, calories,
    protein, carbs, fat, category, servingSize,
    ingredients, instructions
  ];
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servingSize': servingSize,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      servingSize: json['servingSize'],
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }

  NutritionItem copyWith({
    String? id,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? servingSize,
    String? category,
    String? imageUrl,
  }) {
    return NutritionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      servingSize: servingSize ?? this.servingSize,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, calories, protein, carbs, fat, servingSize, category, imageUrl];
}
