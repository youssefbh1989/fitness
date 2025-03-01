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
//Import new screens here.  These files need to be created.
import '../screens/workout/completed_workouts_screen.dart';
import '../screens/nutrition/meal_planning_screen.dart';
import '../screens/exercise/exercise_detail_screen.dart';
import '../screens/settings/notifications_settings_screen.dart';
import '../screens/subscription/subscription_screen.dart';


class AppRouter {
  static const String initialRoute = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String workoutDetail = '/workout/detail';
  static const String workoutTracking = '/workout/tracking';
  static const String createWorkout = '/workout/create';
  static const String challengeDetail = '/challenge/detail';
  static const String articleDetail = '/article/detail';
  static const String settings = '/settings';
  static const String editProfile = '/profile/edit';
  static const String nutritionDetail = '/nutrition/detail';
  static const String nutritionTracking = '/nutrition/tracking';
  static const String exerciseLibrary = '/exercise/library';
  static const String search = '/search';
  static const String achievements = '/achievements';
  static const String progressPhotos = '/progress/photos';
  //New routes
  static const String completedWorkouts = '/workout/history';
  static const String mealPlanning = '/nutrition/meal-planning';
  static const String exerciseDetail = '/exercise/detail';
  static const String notificationSettings = '/settings/notifications';
  static const String subscription = '/subscription';


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
        final workoutId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(workoutId: workoutId),
        );

      case workoutTracking:
        final workoutId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WorkoutTrackingScreen(workoutId: workoutId),
        );

      case createWorkout:
        return MaterialPageRoute(builder: (_) => const CreateWorkoutScreen());

      case challengeDetail:
        final challengeId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ChallengeDetailScreen(challengeId: challengeId),
        );

      case articleDetail:
        final articleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(articleId: articleId),
        );

      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case nutritionDetail:
        final nutritionId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => NutritionDetailScreen(nutritionId: nutritionId),
        );

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

      case completedWorkouts:
        return MaterialPageRoute(builder: (_) => const CompletedWorkoutsScreen());

      case mealPlanning:
        return MaterialPageRoute(builder: (_) => const MealPlanningScreen());

      case exerciseDetail:
        final exerciseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exerciseId: exerciseId),
        );

      case notificationSettings:
        return MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen());

      case subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());

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