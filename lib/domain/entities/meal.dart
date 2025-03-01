
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
