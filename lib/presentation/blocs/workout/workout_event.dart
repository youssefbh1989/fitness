import 'package:equatable/equatable.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkoutsEvent extends WorkoutEvent {
  const LoadWorkoutsEvent();
}

class LoadWorkoutDetailEvent extends WorkoutEvent {
  final String workoutId;

  const LoadWorkoutDetailEvent(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class LoadWorkoutsByCategoryEvent extends WorkoutEvent {
  final String category;

  const LoadWorkoutsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchWorkouts extends WorkoutEvent {
  final String query;

  const SearchWorkouts(this.query);

  @override
  List<Object?> get props => [query];
}