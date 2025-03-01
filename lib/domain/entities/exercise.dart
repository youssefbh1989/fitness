
import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int? sets;
  final int? reps;
  final int? duration; // in seconds
  final String equipment;
  final String? category;
  final String? muscleGroup;
  final String? videoUrl;
  final List<String>? instructions;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.sets,
    this.reps,
    this.duration,
    required this.equipment,
    this.category,
    this.muscleGroup,
    this.videoUrl,
    this.instructions,
  });

  @override
  List<Object?> get props => [
    id, name, description, imageUrl, sets, 
    reps, duration, equipment, category, 
    muscleGroup, videoUrl, instructions
  ];
}
class Exercise {
  final String id;
  final String name;
  final String description;
  final String equipment;
  final String difficulty;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final List<String> tips;
  final String imageUrl;
  final String videoUrl;
  final int estimatedCaloriesBurn;
  final List<ExerciseSummary> similarExercises;
  
  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.equipment,
    required this.difficulty,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.instructions,
    required this.tips,
    required this.imageUrl,
    required this.videoUrl,
    required this.estimatedCaloriesBurn,
    required this.similarExercises,
  });
}

class ExerciseSummary {
  final String id;
  final String name;
  final String imageUrl;
  
  ExerciseSummary({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
