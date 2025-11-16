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
}