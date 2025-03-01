
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
