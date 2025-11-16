import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutsLoaded extends WorkoutState {
  final List<Workout> workouts;

  const WorkoutsLoaded(this.workouts);

  @override
  List<Object?> get props => [workouts];
}

class WorkoutDetailLoaded extends WorkoutState {
  final Workout workout;

  const WorkoutDetailLoaded(this.workout);

  @override
  List<Object?> get props => [workout];
}

class WorkoutCategoriesLoading extends WorkoutState {}

class WorkoutCategoriesLoaded extends WorkoutState {
  final List<String> categories;

  const WorkoutCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class WorkoutSearchResults extends WorkoutState {
  final List<Workout> workouts;
  final String query;

  const WorkoutSearchResults(this.workouts, this.query);

  @override
  List<Object?> get props => [workouts, query];
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutsBycategoryLoaded extends WorkoutState {
  final List<Workout> workouts;
  final String category;

  const WorkoutsBycategoryLoaded(this.workouts, this.category);

  @override
  List<Object?> get props => [workouts, category];
}

class FeaturedWorkoutsLoaded extends WorkoutState {
  final List<Workout> workouts;

  const FeaturedWorkoutsLoaded(this.workouts);

  @override
  List<Object?> get props => [workouts];
}