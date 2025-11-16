import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/nutrition.dart';

abstract class NutritionRepository {
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlans();
  Future<Either<Failure, NutritionPlan>> getNutritionPlanById(String id);
  Future<Either<Failure, List<NutritionPlan>>> getNutritionPlansByGoal(String goal);
  Future<Either<Failure, List<String>>> getNutritionGoals();
}