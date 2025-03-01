
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/progress.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  // This would typically connect to a real data source
  // For now we'll use an in-memory list for demo purposes
  final List<Progress> _progressEntries = [];

  @override
  Future<Either<Failure, List<Progress>>> getProgressHistory(String userId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final userEntries = _progressEntries
          .where((entry) => entry.userId == userId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
          
      return Right(userEntries);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Progress>> addProgressEntry(Progress progress) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _progressEntries.add(progress);
      return Right(progress);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Progress>> updateProgressEntry(Progress progress) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final index = _progressEntries.indexWhere((entry) => entry.id == progress.id);
      if (index != -1) {
        _progressEntries[index] = progress;
        return Right(progress);
      } else {
        return Left(NotFoundFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProgressEntry(String id) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final success = _progressEntries.removeWhere((entry) => entry.id == id) > 0;
      if (success) {
        return const Right(true);
      } else {
        return Left(NotFoundFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Progress>>> getProgressByDateRange(String userId, DateTime startDate, DateTime endDate) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final filteredEntries = _progressEntries
          .where((entry) => 
              entry.userId == userId && 
              entry.date.isAfter(startDate.subtract(const Duration(days: 1))) && 
              entry.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
          
      return Right(filteredEntries);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
