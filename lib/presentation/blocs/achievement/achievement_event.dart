
import 'package:equatable/equatable.dart';
import '../../../domain/entities/achievement.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object?> get props => [];
}

class GetAchievementsEvent extends AchievementEvent {}

class GetAchievementsByCategoryEvent extends AchievementEvent {
  final AchievementCategory category;

  const GetAchievementsByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class UnlockAchievementEvent extends AchievementEvent {
  final String id;

  const UnlockAchievementEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetTotalPointsEvent extends AchievementEvent {}
part of 'achievement_bloc.dart';

abstract class AchievementEvent extends Equatable {
  const AchievementEvent();

  @override
  List<Object> get props => [];
}

class LoadAchievementsEvent extends AchievementEvent {}

class CheckForNewAchievementsEvent extends AchievementEvent {}

class UpdateAchievementProgressEvent extends AchievementEvent {
  final String achievementId;
  final double progress;
  final int currentValue;
  
  const UpdateAchievementProgressEvent({
    required this.achievementId,
    required this.progress,
    required this.currentValue,
  });
  
  @override
  List<Object> get props => [achievementId, progress, currentValue];
}
