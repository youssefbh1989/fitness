
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/nutrition.dart';
import '../../repositories/nutrition_repository.dart';
import '../base/usecase.dart';

class GetNutritionPlansByGoalUseCase extends UseCase<List<NutritionPlan>, Params> {
  final NutritionRepository repository;

  GetNutritionPlansByGoalUseCase(this.repository);

  @override
  Future<Either<Failure, List<NutritionPlan>>> call(Params params) {
    return repository.getNutritionPlansByGoal(params.goal!);
  }
}
