import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/usecases/workout/get_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_by_id_usecase.dart';
import '../../../domain/usecases/workout/get_workouts_by_category_usecase.dart';
import '../../../domain/usecases/workout/get_featured_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_categories_usecase.dart';
import '../../../domain/usecases/base/usecase.dart';

// Events
abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
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

// States
abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;
  const WorkoutLoaded(this.workouts);

  @override
  List<Object> get props => [workouts];
}

class WorkoutDetailLoaded extends WorkoutState {
  final Workout workout;
  const WorkoutDetailLoaded(this.workout);

  @override
  List<Object> get props => [workout];
}

class WorkoutCategoriesLoaded extends WorkoutState {
  final List<String> categories;
  const WorkoutCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class WorkoutSearchResults extends WorkoutState {
  final List<Workout> workouts;
  final String query;
  const WorkoutSearchResults(this.workouts, this.query);

  @override
  List<Object> get props => [workouts, query];
}

class WorkoutError extends WorkoutState {
  final String message;
  const WorkoutError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutsUseCase getWorkouts;
  final GetWorkoutByIdUseCase getWorkoutById;
  final GetWorkoutsByCategoryUseCase getWorkoutsByCategory;
  final GetFeaturedWorkoutsUseCase getFeaturedWorkouts;
  final GetWorkoutCategoriesUseCase getWorkoutCategories;

  WorkoutBloc({
    required this.getWorkouts,
    required this.getWorkoutById,
    required this.getWorkoutsByCategory,
    required this.getFeaturedWorkouts,
    required this.getWorkoutCategories,
  }) : super(WorkoutInitial()) {
    on<GetAllWorkouts>(_onGetAllWorkouts);
    on<GetWorkoutById>(_onGetWorkoutById);
    on<GetWorkoutsByCategory>(_onGetWorkoutsByCategory);
    on<GetFeaturedWorkouts>(_onGetFeaturedWorkouts);
    on<GetWorkoutCategories>(_onGetWorkoutCategories);
    on<SearchWorkouts>(_onSearchWorkouts);
  }

  Future<void> _onGetAllWorkouts(GetAllWorkouts event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getWorkouts(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutById(GetWorkoutById event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getWorkoutById(Params(event.id));
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onGetWorkoutsByCategory(GetWorkoutsByCategory event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getWorkoutsByCategory(Params(event.category));
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetFeaturedWorkouts(GetFeaturedWorkouts event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getFeaturedWorkouts(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutCategories(GetWorkoutCategories event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getWorkoutCategories(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (categories) => emit(WorkoutCategoriesLoaded(categories)),
    );
  }

  Future<void> _onSearchWorkouts(SearchWorkouts event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    final result = await getWorkouts(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) {
        final query = event.query.toLowerCase();
        final filteredWorkouts = workouts.where((workout) {
          return workout.title.toLowerCase().contains(query) ||
              workout.description.toLowerCase().contains(query) ||
              workout.category.toLowerCase().contains(query) ||
              workout.level.toLowerCase().contains(query);
        }).toList();
        emit(WorkoutSearchResults(filteredWorkouts, event.query));
      },
    );
  }
}