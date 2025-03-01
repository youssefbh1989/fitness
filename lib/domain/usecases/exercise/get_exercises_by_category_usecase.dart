
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/exercise.dart';
import '../../repositories/exercise_repository.dart';

class GetExercisesByCategoryUseCase {
  final ExerciseRepository repository;

  GetExercisesByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Exercise>>> call(String category) {
    return repository.getExercisesByCategory(category);
  }
}
