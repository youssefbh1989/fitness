import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../core/theme/app_theme.dart';
import 'blocs/splash/splash_bloc.dart';
import 'blocs/workout/workout_bloc.dart';
import 'blocs/exercise/exercise_bloc.dart';
import 'blocs/nutrition/nutrition_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/notification/notification_bloc.dart';
import 'blocs/community/community_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/progress/progress_bloc.dart';
import 'blocs/achievement/achievement_bloc.dart';
import 'routes/app_router.dart';

class FitBodyApp extends StatelessWidget {
  const FitBodyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) => GetIt.I<SplashBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => GetIt.I<AuthBloc>(),
        ),
        BlocProvider<WorkoutBloc>(
          create: (context) => GetIt.I<WorkoutBloc>(),
        ),
        BlocProvider<ExerciseBloc>(
          create: (context) => GetIt.I<ExerciseBloc>(),
        ),
        BlocProvider<NutritionBloc>(
          create: (context) => GetIt.I<NutritionBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => GetIt.I<UserBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => GetIt.I<NotificationBloc>(),
        ),
        BlocProvider<CommunityBloc>(
          create: (context) => GetIt.I<CommunityBloc>(),
        ),
        BlocProvider<ProgressBloc>(
          create: (context) => GetIt.I<ProgressBloc>(),
        ),
        BlocProvider<AchievementBloc>(
          create: (context) => GetIt.I<AchievementBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'FitBody',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}