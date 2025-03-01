
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/nutrition_repository.dart';
import '../base/usecase.dart';

class GetNutritionGoalsUseCase extends UseCase<List<String>, NoParams> {
  final NutritionRepository repository;

  GetNutritionGoalsUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getNutritionGoals();
  }
}
