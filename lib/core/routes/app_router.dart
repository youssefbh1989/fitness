import 'package:flutter/material.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/nutrition/nutrition_screen.dart';
import '../../presentation/screens/workout/workout_details_screen.dart';
import '../../presentation/screens/workout/workout_session_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/progress/progress_screen.dart';
import '../../domain/entities/workout.dart';
import '../../presentation/screens/profile/profile_screen.dart'; // Added import
import '../../presentation/screens/settings/help_support_screen.dart'; // Added import
import '../../presentation/screens/settings/notifications_settings_screen.dart'; // Added import
import '../../presentation/screens/settings/sync_settings_screen.dart'; // Added import
import '../../presentation/screens/settings/data_export_import_screen.dart'; // Added import
import '../../presentation/screens/progress/body_measurements_screen.dart'; // Added import


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/workout_details':
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(builder: (_) => WorkoutDetailsScreen(workout: workout));
      case '/workout_session':
        final workout = settings.arguments as Workout;
        return MaterialPageRoute(builder: (_) => WorkoutSessionScreen(workout: workout));
      case '/nutrition':
        return MaterialPageRoute(builder: (_) => const NutritionScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case '/help_support':
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case '/notification_settings':
        return MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen());
      case '/sync_settings':
        return MaterialPageRoute(builder: (_) => const SyncSettingsScreen());
      case '/data_export_import':
        return MaterialPageRoute(builder: (_) => const DataExportImportScreen());
      case '/body_measurements':
        return MaterialPageRoute(builder: (_) => const BodyMeasurementsScreen());
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