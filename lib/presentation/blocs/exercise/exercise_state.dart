import 'package:equatable/equatable.dart';
import '../../../domain/entities/exercise.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExercisesLoaded extends ExerciseState {
  final List<Exercise> exercises;

  const ExercisesLoaded(this.exercises);

  @override
  List<Object?> get props => [exercises];
}

class ExerciseLoaded extends ExerciseState {
  final Exercise exercise;

  const ExerciseLoaded(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class ExerciseCategoriesLoaded extends ExerciseState {
  final List<String> categories;

  const ExerciseCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ExerciseSearchResults extends ExerciseState {
  final List<Exercise> exercises;
  final String query;
  const ExerciseSearchResults(this.exercises, this.query);

  @override
  List<Object> get props => [exercises, query];
}

class MuscleGroupsLoaded extends ExerciseState {
  final List<String> muscleGroups;

  const MuscleGroupsLoaded(this.muscleGroups);

  @override
  List<Object?> get props => [muscleGroups];
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}