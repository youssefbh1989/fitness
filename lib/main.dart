import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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


