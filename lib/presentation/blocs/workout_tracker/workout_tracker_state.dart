
part of 'workout_tracker_bloc.dart';

abstract class WorkoutTrackerState extends Equatable {
  const WorkoutTrackerState();
  
  @override
  List<Object> get props => [];
}

class WorkoutTrackerInitial extends WorkoutTrackerState {}

class WorkoutTrackerLoading extends WorkoutTrackerState {}

class WorkoutTrackerActive extends WorkoutTrackerState {
  final Workout workout;
  final int currentExerciseIndex;
  final List<ExerciseSet> completedSets;
  final DateTime startTime;

  const WorkoutTrackerActive({
    required this.workout,
    required this.currentExerciseIndex,
    required this.completedSets,
    required this.startTime,
  });

  @override
  List<Object> get props => [workout, currentExerciseIndex, completedSets, startTime];

  bool get isLastExercise => currentExerciseIndex >= workout.exercises.length - 1;
}

class WorkoutTrackerSaving extends WorkoutTrackerState {}

class WorkoutTrackerCompleted extends WorkoutTrackerState {
  final Workout completedWorkout;

  const WorkoutTrackerCompleted({required this.completedWorkout});

  @override
  List<Object> get props => [completedWorkout];
}

class WorkoutTrackerError extends WorkoutTrackerState {
  final String message;

  const WorkoutTrackerError({required this.message});

  @override
  List<Object> get props => [message];
}
