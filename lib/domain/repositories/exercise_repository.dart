
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<Exercise>>> getExercises();
  Future<Either<Failure, Exercise>> getExerciseById(String id);
  Future<Either<Failure, List<Exercise>>> getExercisesByCategory(String category);
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscleGroup(String muscleGroup);
  Future<Either<Failure, List<String>>> getExerciseCategories();
  Future<Either<Failure, List<String>>> getMuscleGroups();
}
