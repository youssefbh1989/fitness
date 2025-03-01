
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';

class GetMealPlansUseCase {
  final NutritionRepository repository;

  GetMealPlansUseCase(this.repository);

  Future<Either<Failure, List<Nutrition>>> call() async {
    return await repository.getMealPlans();
  }
}
