
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/achievement/get_achievements_usecase.dart';
import '../../../domain/usecases/achievement/get_achievements_by_category_usecase.dart';
import 'achievement_event.dart';
import 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final GetAchievementsUseCase getAchievements;
  final GetAchievementsByCategoryUseCase getAchievementsByCategory;

  AchievementBloc({
    required this.getAchievements,
    required this.getAchievementsByCategory,
  }) : super(AchievementInitial()) {
    on<GetAchievementsEvent>(_onGetAchievements);
    on<GetAchievementsByCategoryEvent>(_onGetAchievementsByCategory);
    on<UnlockAchievementEvent>(_onUnlockAchievement);
    on<GetTotalPointsEvent>(_onGetTotalPoints);
  }

  Future<void> _onGetAchievements(GetAchievementsEvent event, Emitter<AchievementState> emit) async {
    emit(AchievementLoading());
    final result = await getAchievements();
    result.fold(
      (failure) => emit(AchievementError(failure.message)),
      (achievements) => emit(AchievementsLoaded(achievements)),
    );
  }

  Future<void> _onGetAchievementsByCategory(GetAchievementsByCategoryEvent event, Emitter<AchievementState> emit) async {
    emit(AchievementLoading());
    final result = await getAchievementsByCategory(event.category);
    result.fold(
      (failure) => emit(AchievementError(failure.message)),
      (achievements) => emit(AchievementsByCategoryLoaded(achievements, event.category)),
    );
  }

  Future<void> _onUnlockAchievement(UnlockAchievementEvent event, Emitter<AchievementState> emit) async {
    // In a real app, this would call a repository method to unlock the achievement
    // For now, we'll just emit the current state
  }

  Future<void> _onGetTotalPoints(GetTotalPointsEvent event, Emitter<AchievementState> emit) async {
    emit(AchievementLoading());
    // In a real app, this would call a repository method to get the total points
    // For now, we'll just fake it
    final result = await getAchievements();
    result.fold(
      (failure) => emit(AchievementError(failure.message)),
      (achievements) {
        final totalPoints = achievements
            .where((achievement) => achievement.isUnlocked)
            .fold(0, (sum, achievement) => sum + achievement.points);
        emit(TotalPointsLoaded(totalPoints));
      },
    );
  }
}
