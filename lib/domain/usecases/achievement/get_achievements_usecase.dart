
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/achievement.dart';
import '../../repositories/achievement_repository.dart';

class GetAchievementsUseCase {
  final AchievementRepository repository;

  GetAchievementsUseCase(this.repository);

  Future<Either<Failure, List<Achievement>>> call() async {
    return await repository.getAchievements();
  }
}
