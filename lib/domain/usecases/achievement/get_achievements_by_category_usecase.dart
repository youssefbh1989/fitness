
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/achievement.dart';
import '../../repositories/achievement_repository.dart';

class GetAchievementsByCategoryUseCase {
  final AchievementRepository repository;

  GetAchievementsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Achievement>>> call(AchievementCategory category) async {
    return await repository.getAchievementsByCategory(category);
  }
}
