
class CompletedWorkout {
  final String id;
  final String workoutName;
  final String workoutType;
  final int completedAt; // Unix timestamp
  final int duration; // in seconds
  final int caloriesBurned;
  final int exercisesCompleted;
  final int totalSets;
  final List<CompletedExercise> exercises;
  final Map<String, dynamic> performance; // Optional performance metrics

  CompletedWorkout({
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
}

class CompletedExercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final String? note;

  CompletedExercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    this.note,
  });
}
