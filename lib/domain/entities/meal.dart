
import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final String type; // breakfast, lunch, dinner, snack
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String? imageUrl;
  final DateTime timestamp;
  final List<String>? foods;

  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.imageUrl,
    required this.timestamp,
    this.foods,
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
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'foods': foods,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      imageUrl: json['imageUrl'],
      timestamp: DateTime.parse(json['timestamp']),
      foods: json['foods'] != null
          ? List<String>.from(json['foods'])
          : null,
    );
  }

  Meal copyWith({
    String? id,
    String? name,
    String? type,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? imageUrl,
    DateTime? timestamp,
    List<String>? foods,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      foods: foods ?? this.foods,
    );
  }

  @override
  List<Object?> get props => [
    id, name, type, calories, protein, carbs, fat,
    imageUrl, timestamp, foods
  ];
}
