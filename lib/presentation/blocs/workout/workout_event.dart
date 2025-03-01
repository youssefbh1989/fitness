import 'package:equatable/equatable.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class GetAllWorkouts extends WorkoutEvent {
  const GetAllWorkouts();
}

class GetWorkoutById extends WorkoutEvent {
  final String id;

  const GetWorkoutById(this.id);

  @override
  List<Object> get props => [id];
}

class GetWorkoutsByCategory extends WorkoutEvent {
  final String category;

  const GetWorkoutsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class GetFeaturedWorkouts extends WorkoutEvent {
  const GetFeaturedWorkouts();
}

class GetWorkoutCategories extends WorkoutEvent {
  const GetWorkoutCategories();
}

class SearchWorkouts extends WorkoutEvent {
  final String query;

  const SearchWorkouts(this.query);

  @override
  List<Object> get props => [query];
}
import 'package:equatable/equatable.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object> get props => [];
}

class GetWorkoutsEvent extends WorkoutEvent {}

class GetWorkoutByIdEvent extends WorkoutEvent {
  final String id;

  const GetWorkoutByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetWorkoutsByCategoryEvent extends WorkoutEvent {
  final String category;

  const GetWorkoutsByCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class GetFeaturedWorkoutsEvent extends WorkoutEvent {}

class GetWorkoutCategoriesEvent extends WorkoutEvent {}
