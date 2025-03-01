import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/error_handler.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/analytics_service.dart';
import 'core/routes/app_router.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';
import 'presentation/blocs/workout/workout_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/achievement/achievement_bloc.dart';
import 'presentation/blocs/nutrition/nutrition_bloc.dart';
import 'presentation/blocs/workout_tracker/workout_tracker_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/size_config.dart';
import 'presentation/screens/nutrition_screen.dart';
import 'presentation/screens/workout_details_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/progress_tracking_screen.dart';
import 'presentation/screens/workout_session_screen.dart';
import 'domain/entities/user.dart';
import 'domain/entities/workout.dart';
import 'domain/entities/exercise.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  await di.sl<NotificationService>().init();
  await di.sl<AnalyticsService>().trackAppOpen();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _errorHandler = ErrorHandler();
  late DeepLinkHandler _deepLinkHandler;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initDeepLinks();
    });
  }

  Future<void> _initDeepLinks() async {
    _deepLinkHandler = DeepLinkHandler(navigator: _navigatorKey.currentState!);
    await _deepLinkHandler.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _errorHandler.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      di.sl<AnalyticsService>().trackAppBackground();
    } else if (state == AppLifecycleState.resumed) {
      di.sl<AnalyticsService>().trackAppForeground();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<WorkoutBloc>(
          create: (context) => di.sl<WorkoutBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => di.sl<SettingsBloc>()..add(LoadSettingsEvent()),
        ),
        BlocProvider<AchievementBloc>(
          create: (context) => di.sl<AchievementBloc>(),
        ),
        BlocProvider<NutritionBloc>(
          create: (context) => di.sl<NutritionBloc>(),
        ),
        BlocProvider<WorkoutTrackerBloc>(
          create: (context) => di.sl<WorkoutTrackerBloc>(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          bool isDarkMode = false;
          if (state is SettingsLoaded) {
            isDarkMode = state.settings.darkMode;
          }
          return MaterialApp(
            title: 'FitBody',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF5C6BC0),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                color: Colors.transparent,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5C6BC0),
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: const Color(0xFF5C6BC0),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                color: Colors.transparent,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.dark().textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5C6BC0),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardColor: const Color(0xFF1E1E1E),
            ),
            themeMode: ThemeMode.system,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/',
            navigatorKey: _navigatorKey,
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('es', ''), // Spanish
              Locale('fr', ''), // French
              Locale('de', ''), // German
              Locale('ja', ''), // Japanese
              Locale('zh', ''), // Chinese
              Locale('ru', ''), // Russian
              Locale('pt', ''), // Portuguese
              Locale('it', ''), // Italian
              Locale('ar', ''), // Arabic
            ],
            localizationsDelegates: const [
              //AppLocalizations.delegate, // Assuming this is defined elsewhere
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: state is SettingsLoaded ? Locale(state.settings.language) : null,
            navigatorObservers: [
              di.sl<AnalyticsService>().getAnalyticsObserver(),
            ],
            builder: (context, child) {
              SizeConfig().init(context);
              return StreamBuilder<AppError>(
                stream: _errorHandler.errorStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        ErrorHandler.showErrorSnackBar(
                          context,
                          snapshot.data!.friendlyMessage,
                        );
                      }
                    });
                  }
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


// Placeholder implementations -  Replace with actual implementations
class NutritionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Nutrition')), body: const Center(child: Text('Nutrition Screen')));
  }
}


class WorkoutDetailsScreen extends StatelessWidget {
  final Workout workout;
  const WorkoutDetailsScreen({super.key, required this.workout});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(workout.name)), body: ListView.builder(
      itemCount: workout.exercises.length,
      itemBuilder: (context, index) {
          final exercise = workout.exercises[index];
          return ListTile(title: Text(exercise.name));
        },
    ));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Settings')), body: const Center(child: Text('Settings Screen')));
  }
}

class ProgressTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Progress')), body: const Center(child: Text('Progress Tracking Screen')));
  }
}

class WorkoutSessionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Workout Session')), body: const Center(child: Text('Workout Session Screen')));
  }
}


// AppRouter implementation - needs significant expansion
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen()); //Needs HomeScreen implementation
      case '/nutrition':
        return MaterialPageRoute(builder: (_) => const NutritionScreen());
      case '/workoutDetails':
        return MaterialPageRoute(builder: (_) => const WorkoutDetailsScreen(workout: Workout(name: "Workout 1", exercises: [Exercise(name: "Exercise 1")])));
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/progress':
        return MaterialPageRoute(builder: (_) => const ProgressTrackingScreen());
      case '/workoutSession':
        return MaterialPageRoute(builder: (_) => const WorkoutSessionScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('404 Not Found'))));
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitBody')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/nutrition'), child: const Text('Nutrition')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/workoutDetails'), child: const Text('Workout Details')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: const Text('Settings')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/progress'), child: const Text('Progress')),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/workoutSession'), child: const Text('Start Workout')),
          ],
        ),
      ),
    );
  }
}

//DeepLinkHandler - needs implementation
class DeepLinkHandler {
  final NavigatorState navigator;
  DeepLinkHandler({required this.navigator});
  Future<void> init() async {}
}

// Missing Blocs, Events, and States - needs implementation for all blocs
class CheckAuthStatusEvent {}
class LoadSettingsEvent {}
class GetUserProfileEvent {}
class FetchWorkoutsEvent {}
class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded({required this.settings});
}
class SettingsState {}


class Settings {
  final bool darkMode;
  final String language;
  Settings({required this.darkMode, required this.language});
}

class AppError {
  final String friendlyMessage;
  AppError({required this.friendlyMessage});
}

class ErrorHandler {
  final StreamController<AppError?> _errorStreamController = StreamController<AppError?>.broadcast();
  Stream<AppError> get errorStream => _errorStreamController.stream.whereType<AppError>();
  void dispose() { _errorStreamController.close(); }
  static void showErrorSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
}