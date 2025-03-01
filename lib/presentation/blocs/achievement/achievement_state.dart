
import 'package:equatable/equatable.dart';
import '../../../domain/entities/achievement.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();
  
  @override
  List<Object?> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementsLoaded extends AchievementState {
  final List<Achievement> achievements;

  const AchievementsLoaded(this.achievements);

  @override
  List<Object?> get props => [achievements];
}

class AchievementsByCategoryLoaded extends AchievementState {
  final List<Achievement> achievements;
  final AchievementCategory category;

  const AchievementsByCategoryLoaded(this.achievements, this.category);

  @override
  List<Object?> get props => [achievements, category];
}

class AchievementUnlocked extends AchievementState {
  final Achievement achievement;

  const AchievementUnlocked(this.achievement);

  @override
  List<Object?> get props => [achievement];
}

class TotalPointsLoaded extends AchievementState {
  final int points;

  const TotalPointsLoaded(this.points);

  @override
  List<Object?> get props => [points];
}

class AchievementError extends AchievementState {
  final String message;

  const AchievementError(this.message);

  @override
  List<Object?> get props => [message];
}
part of 'achievement_bloc.dart';

abstract class AchievementState extends Equatable {
  const AchievementState();
  
  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementLoaded extends AchievementState {
  final List<Achievement> earnedAchievements;
  final List<AchievementProgress> inProgressAchievements;
  final List<Achievement>? newlyEarnedAchievements;
  
  const AchievementLoaded({
    required this.earnedAchievements,
    required this.inProgressAchievements,
    this.newlyEarnedAchievements,
  });
  
  @override
  List<Object> get props => [earnedAchievements, inProgressAchievements];
}

class AchievementError extends AchievementState {
  final String message;
  
  const AchievementError({required this.message});
  
  @override
  List<Object> get props => [message];
}
