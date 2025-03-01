
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';

class GetNutritionByCategoryUseCase {
  final NutritionRepository repository;

  GetNutritionByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Nutrition>>> call(String category) async {
    return await repository.getNutritionByCategory(category);
  }
}
