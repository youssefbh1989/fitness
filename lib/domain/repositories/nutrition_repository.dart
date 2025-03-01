
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/nutrition.dart';

abstract class NutritionRepository {
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlans();
  Future<Either<Failure, NutritionPlan>> getNutritionPlanById(String id);
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlansByGoal(String goal);
  Future<Either<Failure, List<String>>> getNutritionGoals();
}
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/nutrition.dart';

abstract class NutritionRepository {
  Future<Either<Failure, List<Nutrition>>> getMealPlans();
  Future<Either<Failure, List<Nutrition>>> getNutritionByCategory(String category);
  Future<Either<Failure, Nutrition>> getMealPlanDetails(String id);
  Future<Either<Failure, Nutrition>> createMealPlan(Nutrition nutrition);
  Future<Either<Failure, void>> toggleFavorite(String id);
  Future<Either<Failure, List<Nutrition>>> getFavoriteMeals();
  Future<Either<Failure, List<Nutrition>>> searchMeals(String query);
}
