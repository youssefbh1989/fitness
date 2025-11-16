import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout.dart';

abstract class WorkoutTrackerState extends Equatable {
  const WorkoutTrackerState();

  @override
  List<Object?> get props => [];
}

class WorkoutTrackerInitial extends WorkoutTrackerState {}

class WorkoutInProgress extends WorkoutTrackerState {
  final Workout workout;
  final int currentExerciseIndex;
  final List<String> completedExercises;
  final int elapsedSeconds;
  final bool isResting;
  final int restSeconds;
  final bool isPaused;

  const WorkoutInProgress({
    required this.workout,
    required this.currentExerciseIndex,
    required this.completedExercises,
    required this.elapsedSeconds,
    this.isResting = false,
    this.restSeconds = 0,
    this.isPaused = false,
  });

  WorkoutInProgress copyWith({
    Workout? workout,
    int? currentExerciseIndex,
    List<String>? completedExercises,
    int? elapsedSeconds,
    bool? isResting,
    int? restSeconds,
    bool? isPaused,
  }) {
    return WorkoutInProgress(
      workout: workout ?? this.workout,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      completedExercises: completedExercises ?? this.completedExercises,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isResting: isResting ?? this.isResting,
      restSeconds: restSeconds ?? this.restSeconds,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object?> get props => [
    workout,
    currentExerciseIndex,
    completedExercises,
    elapsedSeconds,
    isResting,
    restSeconds,
    isPaused,
  ];
}

class WorkoutCompleted extends WorkoutTrackerState {
  final Workout workout;
  final int totalSeconds;
  final List<String> completedExercises;

  const WorkoutCompleted({
    required this.workout,
    required this.totalSeconds,
    required this.completedExercises,
  });

  @override
  List<Object?> get props => [workout, totalSeconds, completedExercises];
}

class WorkoutTrackerError extends WorkoutTrackerState {
  final String message;

  const WorkoutTrackerError(this.message);

  @override
  List<Object?> get props => [message];
}