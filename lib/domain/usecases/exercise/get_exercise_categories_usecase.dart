
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/exercise_repository.dart';

class GetExerciseCategoriesUseCase {
  final ExerciseRepository repository;

  GetExerciseCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getExerciseCategories();
  }
}
