
import 'package:equatable/equatable.dart';

class CompletedWorkout extends Equatable {
  final String id;
  final String workoutName;
  final String workoutType;
  final DateTime completedAt;
  final int duration; // in seconds
  final int caloriesBurned;
  final int exercisesCompleted;
  final int totalSets;
  final List<CompletedExercise> exercises;
  final Map<String, dynamic> performance;

  const CompletedWorkout({
    required this.id,
    required this.workoutName,
    required this.workoutType,
    required this.completedAt,
    required this.duration,
    required this.caloriesBurned,
    required this.exercisesCompleted,
    required this.totalSets,
    required this.exercises,
    this.performance = const {},
  });

  CompletedWorkout copyWith({
    String? id,
    String? workoutName,
    String? workoutType,
    DateTime? completedAt,
    int? duration,
    int? caloriesBurned,
    int? exercisesCompleted,
    int? totalSets,
    List<CompletedExercise>? exercises,
    Map<String, dynamic>? performance,
  }) {
    return CompletedWorkout(
      id: id ?? this.id,
      workoutName: workoutName ?? this.workoutName,
      workoutType: workoutType ?? this.workoutType,
      completedAt: completedAt ?? this.completedAt,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      totalSets: totalSets ?? this.totalSets,
      exercises: exercises ?? this.exercises,
      performance: performance ?? this.performance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutName': workoutName,
      'workoutType': workoutType,
      'completedAt': completedAt.toIso8601String(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'exercisesCompleted': exercisesCompleted,
      'totalSets': totalSets,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'performance': performance,
    };
  }

  factory CompletedWorkout.fromJson(Map<String, dynamic> json) {
    return CompletedWorkout(
      id: json['id'] as String,
      workoutName: json['workoutName'] as String,
      workoutType: json['workoutType'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      duration: json['duration'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      exercisesCompleted: json['exercisesCompleted'] as int,
      totalSets: json['totalSets'] as int,
      exercises: (json['exercises'] as List)
          .map((e) => CompletedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      performance: json['performance'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  List<Object?> get props => [
        id,
        workoutName,
        workoutType,
        completedAt,
        duration,
        caloriesBurned,
        exercisesCompleted,
        totalSets,
        exercises,
        performance,
      ];
}

class CompletedExercise extends Equatable {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final String? note;

  const CompletedExercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.note,
  });

  CompletedExercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    double? weight,
    String? note,
  }) {
    return CompletedExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'note': note,
    };
  }

  factory CompletedExercise.fromJson(Map<String, dynamic> json) {
    return CompletedExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, sets, reps, weight, note];
}
