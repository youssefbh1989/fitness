
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/achievement.dart';

abstract class AchievementRepository {
  Future<Either<Failure, List<Achievement>>> getAchievements();
  Future<Either<Failure, List<Achievement>>> getAchievementsByCategory(AchievementCategory category);
  Future<Either<Failure, Achievement>> unlockAchievement(String id);
  Future<Either<Failure, int>> getTotalPoints();
}
