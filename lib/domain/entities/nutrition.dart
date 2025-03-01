
import 'package:equatable/equatable.dart';

class NutritionPlan extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String goal;
  final List<Meal> meals;
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
      meals: (json['meals'] as List)
          .map((m) => Meal.fromJson(m))
          .toList(),
      isPremium: json['isPremium'] ?? false,
    );
  }
  
  @override
  List<Object?> get props => [
    id, title, description, imageUrl, goal, meals, isPremium
  ];
}

class Meal extends Equatable {
  final String id;
  final String name;
  final String type; // breakfast, lunch, dinner, snack
  final List<FoodItem> items;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? imageUrl;
  final String? recipeUrl;
  
  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.items,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    this.recipeUrl,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'items': items.map((i) => i.toJson()).toList(),
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
      'recipeUrl': recipeUrl,
    };
  }
  
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      items: (json['items'] as List)
          .map((i) => FoodItem.fromJson(i))
          .toList(),
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      imageUrl: json['imageUrl'],
      recipeUrl: json['recipeUrl'],
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, type, items, calories, protein, 
    carbs, fat, imageUrl, recipeUrl
  ];
}

class FoodItem extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  
  const FoodItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
  
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
    );
  }
  
  @override
  List<Object?> get props => [
    id, name, quantity, unit, calories, protein, carbs, fat
  ];
}
import 'package:equatable/equatable.dart';

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

  Nutrition copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? category,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    List<String>? ingredients,
    List<String>? instructions,
    int? preparationTime,
    bool? isFavorite,
  }) {
    return Nutrition(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      preparationTime: preparationTime ?? this.preparationTime,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        category,
        calories,
        protein,
        carbs,
        fat,
        ingredients,
        instructions,
        preparationTime,
        isFavorite,
      ];
}
