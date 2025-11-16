import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';
import '../base/usecase.dart';

class GetWorkoutsUseCase extends UseCase<List<Workout>, NoParams> {
  final WorkoutRepository repository;

  GetWorkoutsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Workout>>> call(NoParams params) async {
    return await repository.getWorkouts();
  }
}