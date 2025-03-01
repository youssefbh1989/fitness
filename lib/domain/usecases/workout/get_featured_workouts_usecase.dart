
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';
import '../base/usecase.dart';

class GetFeaturedWorkoutsUseCase extends UseCase<List<Workout>, NoParams> {
  final WorkoutRepository repository;

  GetFeaturedWorkoutsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Workout>>> call(NoParams params) {
    return repository.getFeaturedWorkouts();
  }
}
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';

class GetFeaturedWorkoutsUseCase {
  final WorkoutRepository repository;

  GetFeaturedWorkoutsUseCase(this.repository);

  Future<Either<Failure, List<Workout>>> call() async {
    return await repository.getFeaturedWorkouts();
  }
}
