import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/repositories/achievement_repository.dart';
import '../../../domain/repositories/user_repository.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AchievementRepository achievementRepository;
  final UserRepository userRepository;

  AchievementBloc({
    required this.achievementRepository,
    required this.userRepository,
  }) : super(AchievementInitial()) {
    on<LoadAchievementsEvent>(_onLoadAchievements);
    on<CheckForNewAchievementsEvent>(_onCheckForNewAchievements);
    on<UpdateAchievementProgressEvent>(_onUpdateAchievementProgress);
  }

  Future<void> _onLoadAchievements(
    LoadAchievementsEvent event,
    Emitter<AchievementState> emit,
  ) async {
    emit(AchievementLoading());

    try {
      final currentUser = await userRepository.getCurrentUser();
      if (currentUser == null) {
        emit(AchievementError(message: 'User not found'));
        return;
      }

      final achievements = await achievementRepository.getUserAchievements(currentUser.id);
      final allAchievements = await achievementRepository.getAllAchievements();

      // Get progress for achievements not yet earned
      final achievementProgress = <AchievementProgress>[];

      for (final achievement in allAchievements) {
        // Skip already earned achievements
        if (achievements.any((a) => a.id == achievement.id)) {
          continue;
        }

        final progress = await achievementRepository.getAchievementProgress(
          userId: currentUser.id,
          achievement: achievement,
        );

        achievementProgress.add(progress);
      }

      emit(AchievementLoaded(
        earnedAchievements: achievements,
        inProgressAchievements: achievementProgress,
      ));
    } catch (e) {
      emit(AchievementError(message: e.toString()));
    }
  }

  Future<void> _onCheckForNewAchievements(
    CheckForNewAchievementsEvent event,
    Emitter<AchievementState> emit,
  ) async {
    // Only check if we already have achievements loaded
    if (state is AchievementLoaded) {
      final currentState = state as AchievementLoaded;

      try {
        final currentUser = await userRepository.getCurrentUser();
        if (currentUser == null) {
          return;
        }

        final newlyEarnedAchievements = <Achievement>[];

        // Check each in-progress achievement
        for (final progress in currentState.inProgressAchievements) {
          final updatedProgress = await achievementRepository.getAchievementProgress(
            userId: currentUser.id,
            achievement: progress.achievement,
          );

          // If newly completed
          if (updatedProgress.isCompleted && !progress.isCompleted) {
            // Award the achievement
            final earnedAchievement = await achievementRepository.awardAchievement(
              userId: currentUser.id,
              achievementId: progress.achievement.id,
            );

            if (earnedAchievement != null) {
              newlyEarnedAchievements.add(earnedAchievement);
            }
          }
        }

        // If we earned new achievements, emit updated state
        if (newlyEarnedAchievements.isNotEmpty) {
          // Filter out the newly earned achievements from in-progress
          final updatedInProgress = currentState.inProgressAchievements
              .where((progress) => !newlyEarnedAchievements
                  .any((achievement) => achievement.id == progress.achievement.id))
              .toList();

          emit(AchievementLoaded(
            earnedAchievements: [...currentState.earnedAchievements, ...newlyEarnedAchievements],
            inProgressAchievements: updatedInProgress,
            newlyEarnedAchievements: newlyEarnedAchievements,
          ));
        }
      } catch (e) {
        print('Error checking for new achievements: $e');
        // Don't update state on error, just log
      }
    }
  }

  Future<void> _onUpdateAchievementProgress(
    UpdateAchievementProgressEvent event,
    Emitter<AchievementState> emit,
  ) async {
    if (state is AchievementLoaded) {
      final currentState = state as AchievementLoaded;

      try {
        // Update progress for the specific achievement
        final index = currentState.inProgressAchievements.indexWhere(
          (progress) => progress.achievement.id == event.achievementId
        );

        if (index != -1) {
          final updatedProgress = currentState.inProgressAchievements[index].copyWith(
            progress: event.progress,
            currentValue: event.currentValue,
          );

          final updatedInProgress = List<AchievementProgress>.from(currentState.inProgressAchievements);
          updatedInProgress[index] = updatedProgress;

          emit(AchievementLoaded(
            earnedAchievements: currentState.earnedAchievements,
            inProgressAchievements: updatedInProgress,
          ));
        }
      } catch (e) {
        print('Error updating achievement progress: $e');
        // Don't update state on error, just log
      }
    }
  }
}