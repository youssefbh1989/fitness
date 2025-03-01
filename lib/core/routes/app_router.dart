
import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/nutrition/nutrition_screen.dart';
import '../../presentation/screens/workout/workout_details_screen.dart';
import '../../presentation/screens/workout/workout_session_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../domain/entities/workout.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case '/nutrition':
        return MaterialPageRoute(builder: (_) => const NutritionScreen());
      
      case '/workout_details':
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(
          builder: (_) => WorkoutDetailsScreen(workout: workout),
        );
      
      case '/workout_session':
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(workout: workout),
        );
      
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      
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
