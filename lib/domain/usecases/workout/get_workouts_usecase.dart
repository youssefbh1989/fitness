
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';

class GetWorkoutsUseCase {
  final WorkoutRepository repository;

  GetWorkoutsUseCase(this.repository);

  Future<Either<Failure, List<Workout>>> call() {
    return repository.getWorkouts();
  }
  
  Future<Either<Failure, Workout>> getById(String id) {
    return repository.getWorkoutById(id);
  }
  
  Future<Either<Failure, List<Workout>>> getByCategory(String category) {
    return repository.getWorkoutsByCategory(category);
  }
  
  Future<Either<Failure, List<Workout>>> getFeatured() {
    return repository.getFeaturedWorkouts();
  }
  
  Future<Either<Failure, List<String>>> getCategories() {
    return repository.getWorkoutCategories();
  }
}
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/workout.dart';
import '../../repositories/workout_repository.dart';

class GetWorkoutsUseCase {
  final WorkoutRepository repository;

  GetWorkoutsUseCase(this.repository);

  Future<Either<Failure, List<Workout>>> call() async {
    return await repository.getWorkouts();
  }
}
import 'package:dartz/dartz.dart';
import 'package:fitbody/core/error/failures.dart';
import 'package:fitbody/domain/entities/workout.dart';
import 'package:fitbody/domain/repositories/workout_repository.dart';

class GetWorkoutsUseCase {
  final WorkoutRepository repository;

  GetWorkoutsUseCase(this.repository);

  Future<Either<Failure, List<Workout>>> call() {
    return repository.getWorkouts();
  }
}
