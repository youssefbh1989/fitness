
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';

class GetNutritionPlansUseCase {
  final NutritionRepository repository;

  GetNutritionPlansUseCase(this.repository);

  Future<Either<Failure, List<NutritionPlan>>> call() {
    return repository.getNutritionPlans();
  }
  
  Future<Either<Failure, NutritionPlan>> getById(String id) {
    return repository.getNutritionPlanById(id);
  }
  
  Future<Either<Failure, List<NutritionPlan>>> getByGoal(String goal) {
    return repository.getNutritionPlansByGoal(goal);
  }
  
  Future<Either<Failure, List<String>>> getGoals() {
    return repository.getNutritionGoals();
  }
}
