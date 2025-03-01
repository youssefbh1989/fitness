
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/workout/workout_detail_screen.dart';
import '../screens/workout/workout_tracking_screen.dart';
import '../screens/workout/create_workout_screen.dart';
import '../screens/challenge/challenge_detail_screen.dart';
import '../screens/article/article_detail_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/nutrition/nutrition_detail_screen.dart';
import '../screens/nutrition/nutrition_tracking_screen.dart';
import '../screens/exercise/exercise_library_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/user/achievement_screen.dart';
import '../screens/progress/progress_photos_screen.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/article.dart';
import '../../domain/entities/challenge.dart';
import '../../data/datasources/local/app_database.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String workoutDetail = '/workout-detail';
  static const String workoutTracking = '/workout-tracking';
  static const String createWorkout = '/create-workout';
  static const String challengeDetail = '/challenge-detail';
  static const String articleDetail = '/article-detail';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String nutritionDetail = '/nutrition-detail';
  static const String nutritionTracking = '/nutrition-tracking';
  static const String exerciseLibrary = '/exercise-library';
  static const String search = '/search';
  static const String achievements = '/achievements';
  static const String progressPhotos = '/progress-photos';
  
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: _isFirstLaunch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (snapshot.data == true) {
                return const OnboardingScreen();
              } else {
                return FutureBuilder<String?>(
                  future: SharedPreferencesHelper.getLoggedInUserId(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    if (snapshot.data != null) {
                      return const HomeScreen();
                    } else {
                      return const LoginScreen();
                    }
                  },
                );
              }
            },
          ),
        );
        
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
        
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        
      case workoutDetail:
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(workout: workout),
        );
        
      case workoutTracking:
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(
          builder: (_) => WorkoutTrackingScreen(workout: workout),
        );
        
      case createWorkout:
        return MaterialPageRoute(builder: (_) => const CreateWorkoutScreen());
        
      case challengeDetail:
        final challenge = settings.arguments as Challenge;
        return MaterialPageRoute(
          builder: (_) => ChallengeDetailScreen(challenge: challenge),
        );
        
      case articleDetail:
        final article = settings.arguments as Article;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        );
        
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
        
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
        
      case nutritionDetail:
        return MaterialPageRoute(builder: (_) => const NutritionDetailScreen());
        
      case nutritionTracking:
        final date = settings.arguments as DateTime?;
        return MaterialPageRoute(
          builder: (_) => NutritionTrackingScreen(date: date ?? DateTime.now()),
        );
        
      case exerciseLibrary:
        return MaterialPageRoute(builder: (_) => const ExerciseLibraryScreen());
        
      case search:
        final initialQuery = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => SearchScreen(initialQuery: initialQuery),
        );
        
      case achievements:
        return MaterialPageRoute(builder: (_) => const AchievementScreen());
        
      case progressPhotos:
        return MaterialPageRoute(builder: (_) => const ProgressPhotosScreen());
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  static Future<bool> _isFirstLaunch() async {
    return SharedPreferencesHelper.isFirstTimeLaunch();
  }
}
