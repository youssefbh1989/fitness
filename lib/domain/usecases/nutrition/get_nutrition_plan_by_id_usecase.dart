
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';
import '../base/usecase.dart';

class GetNutritionPlanByIdUseCase extends UseCase<NutritionPlan, Params> {
  final NutritionRepository repository;

  GetNutritionPlanByIdUseCase(this.repository);

  @override
  Future<Either<Failure, NutritionPlan>> call(Params params) {
    return repository.getNutritionPlanById(params.id!);
  }
}
