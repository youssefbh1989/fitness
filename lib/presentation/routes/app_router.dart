import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/user_details_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/workout/workout_categories_screen.dart';
import '../screens/workout/workout_list_screen.dart';
import '../screens/workout/workout_detail_screen.dart';
import '../screens/workout/workout_video_player_screen.dart';
import '../screens/workout/workout_tracking_screen.dart';
import '../screens/workout/workout_timer_screen.dart';
import '../screens/workout/save_workout_screen.dart';
import '../screens/exercise/exercise_detail_screen.dart';
import '../screens/exercise/exercise_list_screen.dart';
import '../screens/exercise/exercise_categories_screen.dart'; // Added import
import '../screens/nutrition/nutrition_list_screen.dart';
import '../screens/nutrition/nutrition_categories_screen.dart';
import '../screens/nutrition/meal_detail_screen.dart';
import '../screens/nutrition/meal_planner_screen.dart';
import '../screens/nutrition/create_meal_plan_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/progress/add_progress_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/community/create_post_screen.dart';
import '../screens/community/community_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/achievements/achievements_screen.dart';

class AppRouter {
  // Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String userDetails = '/user-details';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  static const String workoutCategories = '/workout-categories';
  static const String workoutList = '/workout-list';
  static const String workoutDetail = '/workout-detail';
  static const String workoutVideo = '/workout-video';
  static const String workoutTracking = '/workout-tracking';
  static const String workoutTimer = '/workout-timer';
  static const String saveWorkout = '/save-workout';
  static const String exerciseDetail = '/exercise/detail';
  static const String exerciseList = '/exercises';
  static const String exerciseCategories = '/exercise/categories'; // Added route
  static const String nutritionList = '/nutrition-list';
  static const String nutritionCategories = '/nutrition-categories';
  static const String mealDetail = '/meal-detail';
  static const String mealPlanner = '/meal-planner';
  static const String createMealPlan = '/create-meal-plan';
  static const String progress = '/progress';
  static const String addProgress = '/add-progress';
  static const String community = '/community';
  static const String createPost = '/create-post';
  static const String communityDetail = '/community-detail';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String achievements = '/achievements';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case userDetails:
        return MaterialPageRoute(builder: (_) => const UserDetailsScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case workoutCategories:
        return MaterialPageRoute(builder: (_) => const WorkoutCategoriesScreen());
      case workoutList:
        final category = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WorkoutListScreen(category: category));
      case workoutDetail:
        final workoutId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WorkoutDetailScreen(workoutId: workoutId));
      case workoutVideo:
        final videoUrl = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WorkoutVideoPlayerScreen(videoUrl: videoUrl));
      case workoutTracking:
        final workout = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => WorkoutTrackingScreen(workout: workout));
      case workoutTimer:
        final duration = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => WorkoutTimerScreen(duration: duration));
      case saveWorkout:
        final workout = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => SaveWorkoutScreen(workout: workout));
      case exerciseDetail:
        final String exerciseId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exerciseId: exerciseId),
        );
      case exerciseList:
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ExerciseListScreen(
            category: args?['category'] as String?,
            muscleGroup: args?['muscleGroup'] as String?,
          ),
        );
      case exerciseCategories: // Added case
        return MaterialPageRoute(
          builder: (_) => const ExerciseCategoriesScreen(),
        );
      case nutritionList:
        final category = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => NutritionListScreen(category: category));
      case nutritionCategories:
        return MaterialPageRoute(builder: (_) => const NutritionCategoriesScreen());
      case mealDetail:
        final mealId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: mealId));
      case mealPlanner:
        return MaterialPageRoute(builder: (_) => const MealPlannerScreen());
      case createMealPlan:
        return MaterialPageRoute(builder: (_) => const CreateMealPlanScreen());
      case progress:
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case addProgress:
        return MaterialPageRoute(builder: (_) => const AddProgressScreen());
      case community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());
      case createPost:
        return MaterialPageRoute(builder: (_) => const CreatePostScreen());
      case communityDetail:
        final post = settings.arguments as Post;
        return MaterialPageRoute(builder: (_) => CommunityDetailScreen(post: post));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case achievements:
        return MaterialPageRoute(builder: (_) => const AchievementsScreen());
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
}
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
// Import other screens as needed

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/profile':
        // return MaterialPageRoute(builder: (_) => const ProfileScreen());
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Profile Screen - To be implemented')),
        ));
      case '/workouts':
        // return MaterialPageRoute(builder: (_) => const WorkoutsScreen());
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Workouts Screen - To be implemented')),
        ));
      case '/challenges':
        // return MaterialPageRoute(builder: (_) => const ChallengesScreen());
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Challenges Screen - To be implemented')),
        ));
      case '/articles':
        // return MaterialPageRoute(builder: (_) => const ArticlesScreen());
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(child: Text('Articles Screen - To be implemented')),
        ));
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
}
import 'package:flutter/material.dart';

import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/register_page.dart';
import '../screens/splash/splash_page.dart';
import '../screens/home/home_screen.dart';
import '../screens/workout/workout_detail_screen.dart';
import '../screens/workout/create_workout_screen.dart';
import '../screens/challenge/challenge_detail_screen.dart';
import '../screens/article/article_detail_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/nutrition/nutrition_detail_screen.dart';
import '../screens/exercise/exercise_library_screen.dart';
import '../screens/search/search_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case '/workout-detail':
        final workout = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => WorkoutDetailScreen(workout: workout),
        );
      
      case '/create-workout':
        return MaterialPageRoute(builder: (_) => const CreateWorkoutScreen());
      
      case '/challenge-detail':
        final challenge = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ChallengeDetailScreen(challenge: challenge),
        );
        
      case '/article-detail':
        final article = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        );
      
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      case '/edit-profile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      
      case '/nutrition-detail':
        return MaterialPageRoute(builder: (_) => const NutritionDetailScreen());
      
      case '/exercise-library':
        return MaterialPageRoute(builder: (_) => const ExerciseLibraryScreen());
      
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      
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
}
