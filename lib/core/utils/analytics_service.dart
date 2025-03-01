
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/nutrition.dart';
import 'dart:async';

class AnalyticsService {
  final FirebaseAnalytics _analytics;
  
  AnalyticsService(this._analytics);
  
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // App lifecycle events
  Future<void> trackAppOpen() async {
    await _analytics.logAppOpen();
  }
  
  Future<void> trackAppBackground() async {
    await _logEvent('app_background');
  }
  
  Future<void> trackAppForeground() async {
    await _logEvent('app_foreground');
  }
  
  // Authentication events
  Future<void> logLogin({required String loginMethod}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }
  
  Future<void> logSignUp({required String signUpMethod}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }
  
  // User profile events
  Future<void> setUserProperties({
    required User user,
  }) async {
    await _analytics.setUserId(id: user.id);
    
    if (user.name.isNotEmpty) {
      await _analytics.setUserProperty(name: 'user_name', value: user.name);
    }
    
    if (user.email.isNotEmpty) {
      await _analytics.setUserProperty(name: 'user_email', value: user.email);
    }
    
    if (user.fitnessLevel != null) {
      await _analytics.setUserProperty(name: 'fitness_level', value: user.fitnessLevel);
    }
    
    if (user.fitnessGoal != null) {
      await _analytics.setUserProperty(name: 'fitness_goal', value: user.fitnessGoal);
    }
    
    await _analytics.setUserProperty(name: 'account_created_at', value: user.createdAt.toString());
  }
  
  Future<void> logProfileUpdate() async {
    await _logEvent('profile_updated');
  }
  
  // Screen tracking
  Future<void> logScreenView({required String screenName}) async {
    await _analytics.logScreenView(screenName: screenName);
  }
  
  // Workout events
  Future<void> logWorkoutStarted({
    required Workout workout,
  }) async {
    await _analytics.logEvent(
      name: 'workout_started',
      parameters: {
        'workout_id': workout.id,
        'workout_name': workout.name,
        'workout_duration': workout.estimatedDuration.inMinutes,
        'workout_type': workout.type,
        'workout_difficulty': workout.difficulty,
      },
    );
  }
  
  Future<void> logWorkoutCompleted({
    required Workout workout,
    required int actualDuration,
    required double caloriesBurned,
    required int exercisesCompleted,
  }) async {
    await _analytics.logEvent(
      name: 'workout_completed',
      parameters: {
        'workout_id': workout.id,
        'workout_name': workout.name,
        'workout_duration': workout.estimatedDuration.inMinutes,
        'actual_duration': actualDuration,
        'calories_burned': caloriesBurned,
        'exercises_completed': exercisesCompleted,
        'workout_type': workout.type,
        'workout_difficulty': workout.difficulty,
      },
    );
  }
  
  Future<void> logWorkoutPaused({
    required Workout workout,
    required int elapsedTime,
  }) async {
    await _analytics.logEvent(
      name: 'workout_paused',
      parameters: {
        'workout_id': workout.id,
        'workout_name': workout.name,
        'elapsed_time': elapsedTime,
      },
    );
  }
  
  Future<void> logWorkoutResumed({
    required Workout workout,
    required int elapsedTime,
  }) async {
    await _analytics.logEvent(
      name: 'workout_resumed',
      parameters: {
        'workout_id': workout.id,
        'workout_name': workout.name,
        'elapsed_time': elapsedTime,
      },
    );
  }
  
  Future<void> logWorkoutCancelled({
    required Workout workout,
    required int elapsedTime,
    required int exercisesCompleted,
  }) async {
    await _analytics.logEvent(
      name: 'workout_cancelled',
      parameters: {
        'workout_id': workout.id,
        'workout_name': workout.name,
        'elapsed_time': elapsedTime,
        'exercises_completed': exercisesCompleted,
        'completion_percentage': (exercisesCompleted / workout.exercises.length) * 100,
      },
    );
  }
  
  // Exercise events
  Future<void> logExerciseCompleted({
    required String exerciseId,
    required String exerciseName,
    required String exerciseType,
    required int sets,
    required int reps,
    required double weight,
  }) async {
    await _analytics.logEvent(
      name: 'exercise_completed',
      parameters: {
        'exercise_id': exerciseId,
        'exercise_name': exerciseName,
        'exercise_type': exerciseType,
        'sets': sets,
        'reps': reps,
        'weight': weight,
      },
    );
  }
  
  // Nutrition events
  Future<void> logMealLogged({
    required Meal meal,
  }) async {
    await _analytics.logEvent(
      name: 'meal_logged',
      parameters: {
        'meal_id': meal.id,
        'meal_type': meal.type,
        'meal_name': meal.name,
        'calories': meal.calories,
        'protein': meal.protein,
        'carbs': meal.carbs,
        'fat': meal.fat,
        'time_of_day': meal.timeOfDay.toString(),
      },
    );
  }
  
  Future<void> logWaterLogged({
    required double amount,
  }) async {
    await _analytics.logEvent(
      name: 'water_logged',
      parameters: {
        'amount_ml': amount,
      },
    );
  }
  
  // Achievement events
  Future<void> logAchievementUnlocked({
    required String achievementId,
    required String achievementName,
  }) async {
    await _analytics.logEvent(
      name: 'achievement_unlocked',
      parameters: {
        'achievement_id': achievementId,
        'achievement_name': achievementName,
      },
    );
  }
  
  // Subscription events
  Future<void> logSubscriptionStarted({
    required String subscriptionType,
    required double price,
    required String currency,
    required String paymentMethod,
  }) async {
    await _analytics.logEvent(
      name: 'subscription_started',
      parameters: {
        'subscription_type': subscriptionType,
        'price': price,
        'currency': currency,
        'payment_method': paymentMethod,
      },
    );
  }
  
  Future<void> logSubscriptionCancelled({
    required String subscriptionType,
    required String reason,
  }) async {
    await _analytics.logEvent(
      name: 'subscription_cancelled',
      parameters: {
        'subscription_type': subscriptionType,
        'cancellation_reason': reason,
      },
    );
  }
  
  // Social sharing events
  Future<void> logShare({
    required String contentType,
    required String contentId,
    required String method,
  }) async {
    await _analytics.logShare(
      contentType: contentType,
      itemId: contentId,
      method: method,
    );
  }
  
  // App rating events
  Future<void> logRateApp({
    required int rating,
    String? feedback,
  }) async {
    final Map<String, dynamic> parameters = {
      'rating': rating,
    };
    
    if (feedback != null && feedback.isNotEmpty) {
      parameters['feedback'] = feedback;
    }
    
    await _analytics.logEvent(
      name: 'rate_app',
      parameters: parameters,
    );
  }
  
  // Search events
  Future<void> logSearch({
    required String searchTerm,
    required String searchCategory,
  }) async {
    await _analytics.logSearch(searchTerm: searchTerm);
    
    await _analytics.logEvent(
      name: 'search_detailed',
      parameters: {
        'search_term': searchTerm,
        'search_category': searchCategory,
      },
    );
  }
  
  // Error events
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
  }) async {
    final Map<String, dynamic> parameters = {
      'error_type': errorType,
      'error_message': errorMessage,
    };
    
    if (stackTrace != null) {
      parameters['stack_trace'] = stackTrace.substring(0, 
          stackTrace.length > 500 ? 500 : stackTrace.length);
    }
    
    await _analytics.logEvent(
      name: 'app_error',
      parameters: parameters,
    );
  }
  
  // Performance events
  Future<void> logPerformanceIssue({
    required String screenName,
    required String issueType,
    required int duration,
  }) async {
    await _analytics.logEvent(
      name: 'performance_issue',
      parameters: {
        'screen_name': screenName,
        'issue_type': issueType,
        'duration': duration,
      },
    );
  }
  
  // App settings events
  Future<void> logSettingsChanged({
    required String setting,
    required String oldValue,
    required String newValue,
  }) async {
    await _analytics.logEvent(
      name: 'settings_changed',
      parameters: {
        'setting': setting,
        'old_value': oldValue,
        'new_value': newValue,
      },
    );
  }
  
  // Health app connection events
  Future<void> logHealthAppConnected({
    required String platform,
  }) async {
    await _analytics.logEvent(
      name: 'health_app_connected',
      parameters: {
        'platform': platform,
      },
    );
  }
  
  Future<void> logHealthAppDisconnected({
    required String platform,
    required String reason,
  }) async {
    await _analytics.logEvent(
      name: 'health_app_disconnected',
      parameters: {
        'platform': platform,
        'reason': reason,
      },
    );
  }
  
  // Helper method for basic events
  Future<void> _logEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }
}
