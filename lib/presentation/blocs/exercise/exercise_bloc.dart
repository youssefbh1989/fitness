
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/exercise/get_exercises_usecase.dart';
import '../../../domain/usecases/exercise/get_exercise_by_id_usecase.dart';
import '../../../domain/usecases/exercise/get_exercises_by_category_usecase.dart';
import '../../../domain/usecases/exercise/get_exercise_categories_usecase.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesUseCase getExercisesUseCase;
  final GetExerciseByIdUseCase getExerciseByIdUseCase;
  final GetExercisesByCategoryUseCase getExercisesByCategoryUseCase;
  final GetExerciseCategoriesUseCase getExerciseCategoriesUseCase;

  ExerciseBloc({
    required this.getExercisesUseCase,
    required this.getExerciseByIdUseCase,
    required this.getExercisesByCategoryUseCase,
    required this.getExerciseCategoriesUseCase,
  }) : super(ExerciseInitial()) {
    on<GetExercisesEvent>(_onGetExercises);
    on<GetExerciseByIdEvent>(_onGetExerciseById);
    on<GetExercisesByCategoryEvent>(_onGetExercisesByCategory);
    on<GetExerciseCategoriesEvent>(_onGetExerciseCategories);
    on<SearchExercisesEvent>(_onSearchExercises);
  }

  Future<void> _onGetExercises(
    GetExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExercisesUseCase();
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercises) => emit(ExercisesLoaded(exercises)),
    );
  }

  Future<void> _onGetExerciseById(
    GetExerciseByIdEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExerciseByIdUseCase(event.id);
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercise) => emit(ExerciseLoaded(exercise)),
    );
  }

  Future<void> _onGetExercisesByCategory(
    GetExercisesByCategoryEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExercisesByCategoryUseCase(event.category);
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercises) => emit(ExercisesLoaded(exercises)),
    );
  }

  Future<void> _onGetExerciseCategories(
    GetExerciseCategoriesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExerciseCategoriesUseCase();
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (categories) => emit(ExerciseCategoriesLoaded(categories)),
    );
  }

  Future<void> _onSearchExercises(
    SearchExercisesEvent event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    final result = await getExercisesUseCase();
    result.fold(
      (failure) => emit(ExerciseError(failure.message)),
      (exercises) {
        final query = event.query.toLowerCase();
        final filteredExercises = exercises.where((exercise) {
          return exercise.name.toLowerCase().contains(query) ||
              exercise.description.toLowerCase().contains(query) ||
              exercise.category.toLowerCase().contains(query) ||
              exercise.muscleGroup.toLowerCase().contains(query);
        }).toList();
        emit(ExerciseSearchResults(filteredExercises, event.query));
      },
    );
  }
}
