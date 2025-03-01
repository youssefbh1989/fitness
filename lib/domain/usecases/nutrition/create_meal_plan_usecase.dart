
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';

class CreateMealPlanUseCase {
  final NutritionRepository repository;

  CreateMealPlanUseCase(this.repository);

  Future<Either<Failure, Nutrition>> call(Nutrition nutrition) async {
    return await repository.createMealPlan(nutrition);
  }
}
