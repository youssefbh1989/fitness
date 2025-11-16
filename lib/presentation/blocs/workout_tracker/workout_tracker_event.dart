part of 'workout_tracker_bloc.dart';

abstract class WorkoutTrackerEvent extends Equatable {
  const WorkoutTrackerEvent();

  @override
  List<Object?> get props => [];
}

class StartWorkoutEvent extends WorkoutTrackerEvent {
  final Workout workout;

  const StartWorkoutEvent(this.workout);

  @override
  List<Object?> get props => [workout];
}

class PauseWorkoutEvent extends WorkoutTrackerEvent {}

class ResumeWorkoutEvent extends WorkoutTrackerEvent {}

class CompleteExerciseEvent extends WorkoutTrackerEvent {}

class SkipExerciseEvent extends WorkoutTrackerEvent {}

class StartRestTimerEvent extends WorkoutTrackerEvent {
  final int seconds;

  const StartRestTimerEvent(this.seconds);

  @override
  List<Object?> get props => [seconds];
}

class SkipRestEvent extends WorkoutTrackerEvent {}

class CompleteWorkoutEvent extends WorkoutTrackerEvent {}

class UpdateTimerEvent extends WorkoutTrackerEvent {}