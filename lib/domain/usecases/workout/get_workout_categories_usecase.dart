
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/workout_repository.dart';
import '../base/usecase.dart';

class GetWorkoutCategoriesUseCase extends UseCase<List<String>, NoParams> {
  final WorkoutRepository repository;

  GetWorkoutCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getWorkoutCategories();
  }
}
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/workout_repository.dart';

class GetWorkoutCategoriesUseCase {
  final WorkoutRepository repository;

  GetWorkoutCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getWorkoutCategories();
  }
}
