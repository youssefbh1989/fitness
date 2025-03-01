
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';
import '../base/usecase.dart';

class GetWorkoutsByCategoryUseCase extends UseCase<List<Workout>, Params> {
  final WorkoutRepository repository;

  GetWorkoutsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Workout>>> call(Params params) {
    return repository.getWorkoutsByCategory(params.category!);
  }
}
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';

class GetWorkoutsByCategoryUseCase {
  final WorkoutRepository repository;

  GetWorkoutsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Workout>>> call(String category) async {
    return await repository.getWorkoutsByCategory(category);
  }
}
