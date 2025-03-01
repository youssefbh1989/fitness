
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
class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final int duration;
  final String imageUrl;
  final String? targetMuscle;
  final String? instructions;
  
  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.imageUrl,
    this.targetMuscle,
    this.instructions,
  });
  
  Exercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    int? duration,
    String? imageUrl,
    String? targetMuscle,
    String? instructions,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      instructions: instructions ?? this.instructions,
    );
  }
}
class Exercise {
  final String id;
  final String name;
  final String instructions;
  final String imageUrl;
  final int sets;
  final int reps;
  final int restTime; // in seconds
  final bool isRest;
  final int duration; // in seconds (for rest/timed exercises)
  final List<String> targetMuscles;
  final String difficulty;
  final List<String> equipment;

  Exercise({
    required this.id,
    required this.name,
    required this.instructions,
    required this.imageUrl,
    this.sets = 0,
    this.reps = 0,
    this.restTime = 30,
    this.isRest = false,
    this.duration = 0,
    required this.targetMuscles,
    required this.difficulty,
    required this.equipment,
  });

  Exercise copyWith({
    String? id,
    String? name,
    String? instructions,
    String? imageUrl,
    int? sets,
    int? reps,
    int? restTime,
    bool? isRest,
    int? duration,
    List<String>? targetMuscles,
    String? difficulty,
    List<String>? equipment,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      isRest: isRest ?? this.isRest,
      duration: duration ?? this.duration,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      difficulty: difficulty ?? this.difficulty,
      equipment: equipment ?? this.equipment,
    );
  }
}
