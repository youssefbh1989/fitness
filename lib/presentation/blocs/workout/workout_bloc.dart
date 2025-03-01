import 'package:flutter_bloc/flutter_bloc.dart';
import 'workout_event.dart';
import 'workout_state.dart';
import '../../../domain/usecases/workout/get_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_by_id_usecase.dart';
import '../../../domain/usecases/workout/get_workouts_by_category_usecase.dart';
import '../../../domain/usecases/workout/get_featured_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_categories_usecase.dart';
import '../../../domain/usecases/base/usecase.dart';
import '../../../domain/entities/workout.dart';

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

  Future<void> _onGetAllWorkouts(
    GetAllWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkouts(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutById(
    GetWorkoutById event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutById(Params(event.id));
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutDetailLoaded(workout)),
    );
  }

  Future<void> _onGetWorkoutsByCategory(
    GetWorkoutsByCategory event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutsByCategory(Params(event.category));
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetFeaturedWorkouts(
    GetFeaturedWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getFeaturedWorkouts(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutCategories(
    GetWorkoutCategories event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutCategoriesLoading());
    final result = await getWorkoutCategories(NoParams());
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (categories) => emit(WorkoutCategoriesLoaded(categories)),
    );
  }

  Future<void> _onSearchWorkouts(
    SearchWorkouts event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());

    // In a real app, you would call a search API or repository method
    // For now, we'll get all workouts and filter them locally
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
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/workout/get_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_by_id_usecase.dart';
import '../../../domain/usecases/workout/get_workouts_by_category_usecase.dart';
import '../../../domain/usecases/workout/get_featured_workouts_usecase.dart';
import '../../../domain/usecases/workout/get_workout_categories_usecase.dart';
import 'workout_event.dart';
import 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutsUseCase getWorkoutsUseCase;
  final GetWorkoutByIdUseCase getWorkoutByIdUseCase;
  final GetWorkoutsByCategoryUseCase getWorkoutsByCategoryUseCase;
  final GetFeaturedWorkoutsUseCase getFeaturedWorkoutsUseCase;
  final GetWorkoutCategoriesUseCase getWorkoutCategoriesUseCase;

  WorkoutBloc({
    required this.getWorkoutsUseCase,
    required this.getWorkoutByIdUseCase,
    required this.getWorkoutsByCategoryUseCase,
    required this.getFeaturedWorkoutsUseCase,
    required this.getWorkoutCategoriesUseCase,
  }) : super(WorkoutInitial()) {
    on<GetWorkoutsEvent>(_onGetWorkouts);
    on<GetWorkoutByIdEvent>(_onGetWorkoutById);
    on<GetWorkoutsByCategoryEvent>(_onGetWorkoutsByCategory);
    on<GetFeaturedWorkoutsEvent>(_onGetFeaturedWorkouts);
    on<GetWorkoutCategoriesEvent>(_onGetWorkoutCategories);
  }

  Future<void> _onGetWorkouts(
    GetWorkoutsEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutsUseCase();
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutsLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutById(
    GetWorkoutByIdEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutByIdUseCase(event.id);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workout) => emit(WorkoutLoaded(workout)),
    );
  }

  Future<void> _onGetWorkoutsByCategory(
    GetWorkoutsByCategoryEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutsByCategoryUseCase(event.category);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutsLoaded(workouts)),
    );
  }

  Future<void> _onGetFeaturedWorkouts(
    GetFeaturedWorkoutsEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getFeaturedWorkoutsUseCase();
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(FeaturedWorkoutsLoaded(workouts)),
    );
  }

  Future<void> _onGetWorkoutCategories(
    GetWorkoutCategoriesEvent event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await getWorkoutCategoriesUseCase();
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (categories) => emit(WorkoutCategoriesLoaded(categories)),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/usecases/workout/get_workouts_usecase.dart';

part 'workout_event.dart';
part 'workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutsUseCase getWorkoutsUseCase;

  WorkoutBloc({required this.getWorkoutsUseCase}) : super(WorkoutInitial()) {
    on<FetchWorkoutsEvent>(_onFetchWorkouts);
  }

  Future<void> _onFetchWorkouts(FetchWorkoutsEvent event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());
    
    final result = await getWorkoutsUseCase();
    
    result.fold(
      (failure) => emit(WorkoutError(message: failure.message)),
      (workouts) => emit(WorkoutLoaded(workouts: workouts))
    );
  }
}
