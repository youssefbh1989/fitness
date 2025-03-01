
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/progress.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<Progress>>> getProgressHistory(String userId);
  Future<Either<Failure, Progress>> addProgressEntry(Progress progress);
  Future<Either<Failure, Progress>> updateProgressEntry(Progress progress);
  Future<Either<Failure, bool>> deleteProgressEntry(String id);
  Future<Either<Failure, List<Progress>>> getProgressByDateRange(String userId, DateTime startDate, DateTime endDate);
}
