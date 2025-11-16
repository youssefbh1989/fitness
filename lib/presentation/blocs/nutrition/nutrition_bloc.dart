import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/nutrition/get_meal_plans_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_by_category_usecase.dart';
import '../../../domain/usecases/nutrition/get_meal_plan_details_usecase.dart';
import '../../../domain/usecases/nutrition/create_meal_plan_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plans_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plan_by_id_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_plans_by_goal_usecase.dart';
import '../../../domain/usecases/nutrition/get_nutrition_goals_usecase.dart';
import '../../../domain/entities/nutrition_plan.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetMealPlansUseCase getMealPlansUseCase;
  final GetNutritionByCategoryUseCase getNutritionByCategoryUseCase;
  final GetMealPlanDetailsUseCase getMealPlanDetailsUseCase;
  final CreateMealPlanUseCase createMealPlanUseCase;
  final GetNutritionPlansUseCase getNutritionPlansUseCase;
  final GetNutritionPlanByIdUseCase getNutritionPlanByIdUseCase;
  final GetNutritionPlansByGoalUseCase getNutritionPlansByGoalUseCase;
  final GetNutritionGoalsUseCase getNutritionGoalsUseCase;

  NutritionBloc({
    required this.getMealPlansUseCase,
    required this.getNutritionByCategoryUseCase,
    required this.getMealPlanDetailsUseCase,
    required this.createMealPlanUseCase,
    required this.getNutritionPlansUseCase,
    required this.getNutritionPlanByIdUseCase,
    required this.getNutritionPlansByGoalUseCase,
    required this.getNutritionGoalsUseCase,
  }) : super(NutritionInitial()) {
    on<GetMealPlansEvent>(_onGetMealPlans);
    on<GetNutritionByCategoryEvent>(_onGetNutritionByCategory);
    on<GetMealPlanDetailsEvent>(_onGetMealPlanDetails);
    on<CreateMealPlanEvent>(_onCreateMealPlan);
    on<GetNutritionPlans>(_onGetNutritionPlans);
    on<GetNutritionPlanById>(_onGetNutritionPlanById);
    on<GetNutritionPlansByGoal>(_onGetNutritionPlansByGoal);
    on<GetNutritionGoals>(_onGetNutritionGoals);
  }

  Future<void> _onGetMealPlans(
    GetMealPlansEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getMealPlansUseCase();
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (mealPlans) => emit(MealPlansLoaded(mealPlans)),
    );
  }

  Future<void> _onGetNutritionByCategory(
    GetNutritionByCategoryEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getNutritionByCategoryUseCase(event.category);
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionItems) => emit(NutritionCategoryLoaded(nutritionItems, event.category)),
    );
  }

  Future<void> _onGetMealPlanDetails(
    GetMealPlanDetailsEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await getMealPlanDetailsUseCase(event.id);
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (mealPlan) => emit(MealPlanDetailsLoaded(mealPlan)),
    );
  }

  Future<void> _onCreateMealPlan(
    CreateMealPlanEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());
    final result = await createMealPlanUseCase(event.mealPlan);
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (mealPlan) => emit(MealPlanCreated(mealPlan)),
    );
  }

  Future<void> _onGetNutritionPlans(
    GetNutritionPlans event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());

    final result = await getNutritionPlansUseCase(NoParams());

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

    final result = await getNutritionPlanByIdUseCase(Params(id: event.id));

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

    final result = await getNutritionPlansByGoalUseCase(Params(goal: event.goal));

    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionPlans) => emit(NutritionPlansByGoalLoaded(nutritionPlans, event.goal)),
    );
  }

  Future<void> _onGetNutritionGoals(
    GetNutritionGoals event,
    Emitter<NutritionState> emit,
  ) async {
    final result = await getNutritionGoalsUseCase(NoParams());

    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (goals) => emit(NutritionGoalsLoaded(goals)),
    );
  }
}