
import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class GetExercisesEvent extends ExerciseEvent {}

class GetExerciseByIdEvent extends ExerciseEvent {
  final String id;

  const GetExerciseByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetExercisesByCategoryEvent extends ExerciseEvent {
  final String category;

  const GetExercisesByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class GetExercisesByMuscleGroupEvent extends ExerciseEvent {
  final String muscleGroup;

  const GetExercisesByMuscleGroupEvent(this.muscleGroup);

  @override
  List<Object?> get props => [muscleGroup];
}

class GetExerciseCategoriesEvent extends ExerciseEvent {}

class GetMuscleGroupsEvent extends ExerciseEvent {}
