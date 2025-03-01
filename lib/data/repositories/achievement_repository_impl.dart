
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  @override
  Future<Either<Failure, List<Achievement>>> getAchievements() async {
    try {
      // This would normally connect to an API or local database
      await Future.delayed(const Duration(seconds: 1));
      return Right(_getMockAchievements());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load achievements'));
    }
  }

  @override
  Future<Either<Failure, List<Achievement>>> getAchievementsByCategory(AchievementCategory category) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final achievements = _getMockAchievements();
      return Right(achievements.where((achievement) => achievement.category == category).toList());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to load achievements by category'));
    }
  }

  @override
  Future<Either<Failure, Achievement>> unlockAchievement(String id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final achievements = _getMockAchievements();
      final achievement = achievements.firstWhere((achievement) => achievement.id == id);
      final unlockedAchievement = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        progress: 1.0,
      );
      return Right(unlockedAchievement);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to unlock achievement'));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalPoints() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final achievements = _getMockAchievements();
      final totalPoints = achievements
          .where((achievement) => achievement.isUnlocked)
          .fold(0, (sum, achievement) => sum + achievement.points);
      return Right(totalPoints);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get total points'));
    }
  }

  List<Achievement> _getMockAchievements() {
    return [
      Achievement(
        id: '1',
        title: 'First Workout',
        description: 'Complete your first workout',
        iconUrl: 'assets/images/achievements/first_workout.png',
        points: 10,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 30)),
        progress: 1.0,
        category: AchievementCategory.workout,
      ),
      Achievement(
        id: '2',
        title: 'Workout Streak',
        description: 'Complete workouts for 7 consecutive days',
        iconUrl: 'assets/images/achievements/workout_streak.png',
        points: 50,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 15)),
        progress: 1.0,
        category: AchievementCategory.workout,
      ),
      Achievement(
        id: '3',
        title: 'Strength Master',
        description: 'Complete 20 strength workouts',
        iconUrl: 'assets/images/achievements/strength_master.png',
        points: 30,
        isUnlocked: false,
        progress: 0.75,
        category: AchievementCategory.workout,
      ),
      Achievement(
        id: '4',
        title: 'Cardio King',
        description: 'Complete 20 cardio workouts',
        iconUrl: 'assets/images/achievements/cardio_king.png',
        points: 30,
        isUnlocked: false,
        progress: 0.5,
        category: AchievementCategory.workout,
      ),
      Achievement(
        id: '5',
        title: 'Meal Planner',
        description: 'Create your first meal plan',
        iconUrl: 'assets/images/achievements/meal_planner.png',
        points: 15,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
        progress: 1.0,
        category: AchievementCategory.nutrition,
      ),
      Achievement(
        id: '6',
        title: 'Nutrition Expert',
        description: 'Track your meals for 30 days',
        iconUrl: 'assets/images/achievements/nutrition_expert.png',
        points: 40,
        isUnlocked: false,
        progress: 0.3,
        category: AchievementCategory.nutrition,
      ),
      Achievement(
        id: '7',
        title: 'Progress Tracker',
        description: 'Add your first progress photo',
        iconUrl: 'assets/images/achievements/progress_tracker.png',
        points: 10,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 20)),
        progress: 1.0,
        category: AchievementCategory.progress,
      ),
      Achievement(
        id: '8',
        title: 'Weight Goal',
        description: 'Reach your first weight goal',
        iconUrl: 'assets/images/achievements/weight_goal.png',
        points: 30,
        isUnlocked: false,
        progress: 0.8,
        category: AchievementCategory.progress,
      ),
      Achievement(
        id: '9',
        title: 'Social Butterfly',
        description: 'Create your first post in the community',
        iconUrl: 'assets/images/achievements/social_butterfly.png',
        points: 10,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        progress: 1.0,
        category: AchievementCategory.community,
      ),
      Achievement(
        id: '10',
        title: 'Influencer',
        description: 'Get 50 likes on your posts',
        iconUrl: 'assets/images/achievements/influencer.png',
        points: 25,
        isUnlocked: false,
        progress: 0.4,
        category: AchievementCategory.community,
      ),
      Achievement(
        id: '11',
        title: 'Early Bird',
        description: 'Complete a workout before 7 AM',
        iconUrl: 'assets/images/achievements/early_bird.png',
        points: 20,
        isUnlocked: false,
        progress: 0.0,
        category: AchievementCategory.special,
      ),
      Achievement(
        id: '12',
        title: 'Night Owl',
        description: 'Complete a workout after 10 PM',
        iconUrl: 'assets/images/achievements/night_owl.png',
        points: 20,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
        progress: 1.0,
        category: AchievementCategory.special,
      ),
    ];
  }
}
