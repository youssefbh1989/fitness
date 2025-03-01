
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/exercise.dart';
import '../../repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  Future<Either<Failure, List<Exercise>>> call() {
    return repository.getExercises();
  }
}
