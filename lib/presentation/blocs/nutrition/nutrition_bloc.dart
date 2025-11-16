import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plans_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plan_by_id_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plans_by_goal_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_goals_usecase.dart';
import '../../../domain/usecases/base/usecase.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetNutritionPlansUseCase getNutritionPlansUseCase;
  final GetNutritionPlanByIdUseCase getNutritionPlanByIdUseCase;
  final GetNutritionPlansByGoalUseCase getNutritionPlansByGoalUseCase;
  final GetNutritionGoalsUseCase getNutritionGoalsUseCase;

  NutritionBloc({
    required this.getNutritionPlansUseCase,
    required this.getNutritionPlanByIdUseCase,
    required this.getNutritionPlansByGoalUseCase,
    required this.getNutritionGoalsUseCase,
  }) : super(NutritionInitial()) {
    on<GetNutritionPlans>(_onGetNutritionPlans);
    on<GetNutritionPlanById>(_onGetNutritionPlanById);
    on<GetNutritionPlansByGoal>(_onGetNutritionPlansByGoal);
    on<GetNutritionGoals>(_onGetNutritionGoals);
    on<LogMealEvent>(_onLogMeal);
    on<GetTodayMealsEvent>(_onGetTodayMeals);
    on<DeleteMealEvent>(_onDeleteMeal);
  }

  Future<void> _onGetNutritionPlans(
    GetNutritionPlans event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getNutritionPlansUseCase.call();
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionPlans) => emit(NutritionPlansLoaded(nutritionPlans)),
    );
  }

  Future<void> _onGetNutritionPlanById(
    GetNutritionPlanById event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getNutritionPlanByIdUseCase.call(Params(id: event.id));
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionPlan) => emit(NutritionPlanDetailLoaded(nutritionPlan)),
    );
  }

  Future<void> _onGetNutritionPlansByGoal(
    GetNutritionPlansByGoal event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getNutritionPlansByGoalUseCase.call(Params(goal: event.goal));
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionPlans) => emit(NutritionPlansLoaded(nutritionPlans)),
    );
  }

  Future<void> _onGetNutritionGoals(
    GetNutritionGoals event,
    Emitter<NutritionState> emit,
  ) async {
    final result = await getNutritionGoalsUseCase.call(NoParams());
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (goals) => emit(NutritionGoalsLoaded(goals)),
    );
  }

  Future<void> _onLogMeal(
    LogMealEvent event,
    Emitter<NutritionState> emit,
  ) async {
    // Implement meal logging logic
    emit(NutritionLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const NutritionError('Meal logged successfully'));
  }

  Future<void> _onGetTodayMeals(
    GetTodayMealsEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    // Return empty list for now
    emit(const MealPlansLoaded([]));
  }

  Future<void> _onDeleteMeal(
    DeleteMealEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const NutritionError('Meal deleted successfully'));
  }
}