import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<Workout>>> getWorkouts();
  Future<Either<Failure, Workout>> getWorkoutById(String id);
  Future<Either<Failure, List<Workout>>> getWorkoutsByCategory(String category);
  Future<Either<Failure, List<Workout>>> getFeaturedWorkouts();
  Future<Either<Failure, List<String>>> getWorkoutCategories();
  Future<Either<Failure, List<Workout>>> getFavoriteWorkouts();
  Future<Either<Failure, bool>> toggleFavoriteWorkout(String id);
}