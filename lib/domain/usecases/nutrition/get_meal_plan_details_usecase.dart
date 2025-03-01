
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';

class GetMealPlanDetailsUseCase {
  final NutritionRepository repository;

  GetMealPlanDetailsUseCase(this.repository);

  Future<Either<Failure, Nutrition>> call(String id) async {
    return await repository.getMealPlanDetails(id);
  }
}
