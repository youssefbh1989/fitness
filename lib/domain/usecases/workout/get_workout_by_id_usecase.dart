
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';
import '../base/usecase.dart';

class GetWorkoutByIdUseCase extends UseCase<Workout, Params> {
  final WorkoutRepository repository;

  GetWorkoutByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Workout>> call(Params params) {
    return repository.getWorkoutById(params.id!);
  }
}
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';

class GetWorkoutByIdUseCase {
  final WorkoutRepository repository;

  GetWorkoutByIdUseCase(this.repository);

  Future<Either<Failure, Workout>> call(String id) async {
    return await repository.getWorkoutById(id);
  }
}
