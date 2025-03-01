
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/exercise.dart';
import '../../repositories/exercise_repository.dart';

class GetExerciseByIdUseCase {
  final ExerciseRepository repository;

  GetExerciseByIdUseCase(this.repository);

  Future<Either<Failure, Exercise>> call(String id) {
    return repository.getExerciseById(id);
  }
}
