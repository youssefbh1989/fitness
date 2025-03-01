
part of 'workout_tracker_bloc.dart';

abstract class WorkoutTrackerEvent extends Equatable {
  const WorkoutTrackerEvent();

  @override
  List<Object> get props => [];
}

class StartWorkoutEvent extends WorkoutTrackerEvent {
  final Workout workout;

  const StartWorkoutEvent({required this.workout});

  @override
  List<Object> get props => [workout];
}

class CompleteExerciseSetEvent extends WorkoutTrackerEvent {
  final ExerciseSet exerciseSet;
  final bool moveToNextExercise;

  const CompleteExerciseSetEvent({
    required this.exerciseSet, 
    this.moveToNextExercise = false,
  });

  @override
  List<Object> get props => [exerciseSet, moveToNextExercise];
}

class UpdateExerciseSetEvent extends WorkoutTrackerEvent {
  final ExerciseSet exerciseSet;

  const UpdateExerciseSetEvent({required this.exerciseSet});

  @override
  List<Object> get props => [exerciseSet];
}

class CompleteWorkoutEvent extends WorkoutTrackerEvent {}

class CancelWorkoutEvent extends WorkoutTrackerEvent {}
