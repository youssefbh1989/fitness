import 'package:equatable/equatable.dart';
import 'exercise.dart';

class Workout extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String level;
  final int duration; // minutes
  final List<Exercise> exercises;
  final String category;
  final bool isPremium;
  final int? calories;
  final bool isFavorite;

  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.level,
    required this.duration,
    required this.exercises,
    required this.category,
    this.isPremium = false,
    this.calories,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'level': level,
      'duration': duration,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'category': category,
      'isPremium': isPremium,
      'calories': calories,
      'isFavorite': isFavorite,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      level: json['level'],
      duration: json['duration'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      category: json['category'],
      isPremium: json['isPremium'] ?? false,
      calories: json['calories'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Workout copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? level,
    int? duration,
    List<Exercise>? exercises,
    String? category,
    bool? isPremium,
    int? calories,
    bool? isFavorite,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      exercises: exercises ?? this.exercises,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      calories: calories ?? this.calories,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id, title, description, imageUrl, level, 
    duration, exercises, category, isPremium, calories, isFavorite
  ];
}