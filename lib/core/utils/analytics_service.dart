
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  static const String _eventsKey = 'analytics_events';
  static const int _maxEventsStored = 1000;
  
  factory AnalyticsService() {
    return _instance;
  }
  
  AnalyticsService._internal();
  
  // Track events locally (in a production app, you'd send these to Firebase, Mixpanel, etc.)
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final event = AnalyticsEvent(
        name: eventName,
        parameters: parameters,
        timestamp: DateTime.now(),
      );
      
      // Store event locally
      await _storeEvent(event);
      
      // Log the event (in a production app, you'd send to an analytics service)
      print('Analytics Event: ${event.name} - ${event.parameters}');
    } catch (e) {
      print('Error tracking analytics event: $e');
    }
  }
  
  // Track screen views
  Future<void> trackScreenView(String screenName) async {
    await trackEvent('screen_view', parameters: {'screen_name': screenName});
  }
  
  // Track workout started
  Future<void> trackWorkoutStarted(String workoutId, String workoutName) async {
    await trackEvent('workout_started', parameters: {
      'workout_id': workoutId,
      'workout_name': workoutName,
    });
  }
  
  // Track workout completed
  Future<void> trackWorkoutCompleted(
    String workoutId,
    String workoutName,
    int durationSeconds,
  ) async {
    await trackEvent('workout_completed', parameters: {
      'workout_id': workoutId,
      'workout_name': workoutName,
      'duration_seconds': durationSeconds,
    });
  }
  
  // Track achievement earned
  Future<void> trackAchievementEarned(String achievementId, String achievementName) async {
    await trackEvent('achievement_earned', parameters: {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
    });
  }
  
  // Track user sign up
  Future<void> trackSignUp(String method) async {
    await trackEvent('sign_up', parameters: {'method': method});
  }
  
  // Track user login
  Future<void> trackLogin(String method) async {
    await trackEvent('login', parameters: {'method': method});
  }
  
  // Track meal logged
  Future<void> trackMealLogged(String mealType, int calories) async {
    await trackEvent('meal_logged', parameters: {
      'meal_type': mealType,
      'calories': calories,
    });
  }
  
  // Track app opened
  Future<void> trackAppOpen() async {
    await trackEvent('app_open');
  }
  
  // Track app background/foreground
  Future<void> trackAppBackground() async {
    await trackEvent('app_background');
  }
  
  Future<void> trackAppForeground() async {
    await trackEvent('app_foreground');
  }
  
  // Store event locally
  Future<void> _storeEvent(AnalyticsEvent event) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEvents = prefs.getStringList(_eventsKey) ?? [];
      
      // Add new event
      storedEvents.add(jsonEncode(event.toMap()));
      
      // Keep only the last N events to prevent excessive storage usage
      if (storedEvents.length > _maxEventsStored) {
        storedEvents.removeRange(0, storedEvents.length - _maxEventsStored);
      }
      
      await prefs.setStringList(_eventsKey, storedEvents);
    } catch (e) {
      print('Error storing analytics event: $e');
    }
  }
  
  // Get all stored events (for debugging)
  Future<List<AnalyticsEvent>> getStoredEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEvents = prefs.getStringList(_eventsKey) ?? [];
      
      return storedEvents.map((eventJson) {
        return AnalyticsEvent.fromMap(jsonDecode(eventJson));
      }).toList();
    } catch (e) {
      print('Error getting stored analytics events: $e');
      return [];
    }
  }
  
  // Clear all stored events
  Future<void> clearStoredEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_eventsKey);
    } catch (e) {
      print('Error clearing stored analytics events: $e');
    }
  }
}

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic>? parameters;
  final DateTime timestamp;
  
  AnalyticsEvent({
    required this.name,
    this.parameters,
    required this.timestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parameters': parameters,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory AnalyticsEvent.fromMap(Map<String, dynamic> map) {
    return AnalyticsEvent(
      name: map['name'],
      parameters: map['parameters'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
