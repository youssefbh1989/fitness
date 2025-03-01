
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart' as di;
import 'core/utils/error_handler.dart';
import 'core/utils/notification_service.dart';
import 'core/utils/analytics_service.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';
import 'presentation/blocs/workout/workout_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/achievement/achievement_bloc.dart';
import 'presentation/blocs/nutrition/nutrition_bloc.dart';
import 'presentation/blocs/workout_tracker/workout_tracker_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependencies
  await di.init();
  
  // Initialize notification service
  await di.sl<NotificationService>().init();
  
  // Track app open
  await di.sl<AnalyticsService>().trackAppOpen();
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _errorHandler = ErrorHandler();
  late DeepLinkHandler _deepLinkHandler;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize deep links after the widget is built
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
            title: 'Fitness App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
            navigatorKey: _navigatorKey,
            // Configure supported locales
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
            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // Determine the app locale based on device locale
            locale: state is SettingsLoaded ? 
              Locale(state.settings.language) : null,
            navigatorObservers: [
              // Track screen views for analytics
              _analyticsService.getAnalyticsObserver(),
            ],
            builder: (context, child) {
              SizeConfig().init(context);
              
              // Error handling UI wrapper
              return StreamBuilder<AppError>(
                stream: _errorHandler.errorStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // Show error snackbar
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        ErrorHandler.showErrorSnackBar(
                          context,
                          snapshot.data!.friendlyMessage,
                        );
                      }
                    });
                  }
                  
                  // Ensure proper text scaling
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: child!,
                  );
                },
              );
            },
            // Handle deep links
            onGenerateInitialRoutes: (String initialRoute) {
              // This is called when app is started from a deep link
              if (initialRoute != '/') {
                return [
                  AppRouter.onGenerateRoute(RouteSettings(name: initialRoute))
                ];
              }
              return [
                AppRouter.onGenerateRoute(const RouteSettings(name: '/'))
              ];
            },
          );
        },
      ),
    );
  }
}
