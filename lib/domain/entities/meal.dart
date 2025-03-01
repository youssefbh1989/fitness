
import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final String type; // breakfast, lunch, dinner, snack
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double servingSize;
  final String servingUnit;
  final String? imageUrl;
  final double? fiber;
  final double? sugar;
  final double? saturatedFat;
  final double? sodium;
  final String? ingredients;
  final String? notes;
  final DateTime createdAt;

  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
    required this.servingUnit,
    this.imageUrl,
    this.fiber,
    this.sugar,
    this.saturatedFat,
    this.sodium,
    this.ingredients,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    calories,
    protein,
    carbs,
    fat,
    servingSize,
    servingUnit,
    imageUrl,
    fiber,
    sugar,
    saturatedFat,
    sodium,
    ingredients,
    notes,
    createdAt,
  ];
}
class Meal {
  final String id;
  final String name;
  final int calories;
  final String type; // Breakfast, Lunch, Dinner, Snack
  final String time;
  final String day;
  final String imageUrl;
  final List<String> ingredients;
  final Map<String, int> macros; // protein, carbs, fat

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.type,
    required this.time,
    required this.day,
    required this.imageUrl,
    required this.ingredients,
    required this.macros,
  });

  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    String? type,
    String? time,
    String? day,
    String? imageUrl,
    List<String>? ingredients,
    Map<String, int>? macros,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      type: type ?? this.type,
      time: time ?? this.time,
      day: day ?? this.day,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      macros: macros ?? this.macros,
    );
  }
}
