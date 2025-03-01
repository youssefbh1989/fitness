import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/update_user_profile_usecase.dart';
import '../../domain/usecases/workout/get_workouts_usecase.dart';
import '../../domain/usecases/workout/get_workout_by_id_usecase.dart';
import '../../domain/usecases/workout/get_workouts_by_category_usecase.dart';
import '../../domain/usecases/workout/get_featured_workouts_usecase.dart';
import '../../domain/usecases/workout/get_workout_categories_usecase.dart';
import '../../domain/usecases/exercise/get_exercises_usecase.dart';
import '../../domain/usecases/exercise/get_exercise_by_id_usecase.dart';
import '../../domain/usecases/exercise/get_exercises_by_category_usecase.dart';
import '../../domain/usecases/exercise/get_exercise_categories_usecase.dart';
import '../../domain/usecases/nutrition/get_nutrition_plans_usecase.dart';
import '../../domain/usecases/nutrition/get_nutrition_plan_by_id_usecase.dart';
import '../../domain/usecases/nutrition/get_nutrition_plans_by_goal_usecase.dart';
import '../../domain/usecases/nutrition/get_nutrition_goals_usecase.dart';
import '../../domain/usecases/nutrition/get_meal_plans_usecase.dart';
import '../../domain/usecases/nutrition/get_nutrition_by_category_usecase.dart';
import '../../domain/usecases/nutrition/get_meal_plan_details_usecase.dart';
import '../../domain/usecases/nutrition/create_meal_plan_usecase.dart';
import '../../domain/usecases/progress/get_progress_history_usecase.dart';
import '../../domain/usecases/progress/add_progress_entry_usecase.dart';
import '../../domain/usecases/notification/get_notifications_usecase.dart';
import '../../domain/usecases/notification/mark_as_read_usecase.dart';
import '../../domain/usecases/notification/mark_all_as_read_usecase.dart';
import '../../domain/usecases/post/get_posts_usecase.dart';
import '../../domain/usecases/post/create_post_usecase.dart';
import '../../domain/usecases/post/like_post_usecase.dart';
import '../../domain/usecases/post/unlike_post_usecase.dart';
import '../../domain/usecases/post/get_user_posts_usecase.dart';
import '../../domain/usecases/achievement/get_achievements_usecase.dart';
import '../../domain/usecases/achievement/get_achievements_by_category_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/user/user_bloc.dart';
import '../../presentation/blocs/workout/workout_bloc.dart';
import '../../presentation/blocs/exercise/exercise_bloc.dart';
import '../../presentation/blocs/nutrition/nutrition_bloc.dart';
import '../../presentation/blocs/onboarding/onboarding_bloc.dart';
import '../../presentation/blocs/progress/progress_bloc.dart';
import '../../presentation/blocs/notification/notification_bloc.dart';
import '../../presentation/blocs/community/community_bloc.dart';
import '../../presentation/blocs/achievement/achievement_bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<WorkoutRepository>(() => WorkoutRepositoryImpl());
  sl.registerLazySingleton<ExerciseRepository>(() => ExerciseRepositoryImpl());
  sl.registerLazySingleton<NutritionRepository>(() => NutritionRepositoryImpl());
  sl.registerLazySingleton<ProgressRepository>(() => ProgressRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl());
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());
  sl.registerLazySingleton<AchievementRepository>(() => AchievementRepositoryImpl());

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutsUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutsByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedWorkoutsUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));
  sl.registerLazySingleton(() => GetExerciseByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetExercisesByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetExerciseCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionPlansUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionPlanByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionPlansByGoalUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionGoalsUseCase(sl()));
  sl.registerLazySingleton(() => GetMealPlansUseCase(sl()));
  sl.registerLazySingleton(() => GetNutritionByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetMealPlanDetailsUseCase(sl()));
  sl.registerLazySingleton(() => CreateMealPlanUseCase(sl()));
  sl.registerLazySingleton(() => GetProgressHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddProgressEntryUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllAsReadUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => LikePostUseCase(sl()));
  sl.registerLazySingleton(() => UnlikePostUseCase(sl()));
  sl.registerLazySingleton(() => GetUserPostsUseCase(sl()));
  sl.registerLazySingleton(() => GetAchievementsUseCase(sl()));
  sl.registerLazySingleton(() => GetAchievementsByCategoryUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        signupUseCase: sl(),
      ));
  sl.registerFactory(() => OnboardingBloc());
  sl.registerFactory(() => UserBloc(
        getUserProfileUseCase: sl(),
        updateUserProfileUseCase: sl(),
      ));
  sl.registerFactory(() => WorkoutBloc(
    getWorkoutsUseCase: sl(),
    getWorkoutByIdUseCase: sl(),
    getWorkoutsByCategoryUseCase: sl(),
    getFeaturedWorkoutsUseCase: sl(),
    getWorkoutCategoriesUseCase: sl(),
  ));
  sl.registerFactory(() => ExerciseBloc(
        getExercisesUseCase: sl(),
        getExerciseByIdUseCase: sl(),
        getExercisesByCategoryUseCase: sl(),
        getExerciseCategoriesUseCase: sl(),
      ));
  sl.registerFactory(() => NutritionBloc(
    getMealPlansUseCase: sl(),
    getNutritionByCategoryUseCase: sl(),
    getMealPlanDetailsUseCase: sl(),
    createMealPlanUseCase: sl(),
  ));
  sl.registerFactory(() => ProgressBloc(
        getProgressHistory: sl(),
        addProgressEntry: sl(),
      ));
  sl.registerFactory(
    () => NotificationBloc(
      getNotifications: sl(),
      markAsRead: sl(),
      markAllAsRead: sl(),
    ),
  );
  sl.registerFactory(
    () => CommunityBloc(
      getPostsUseCase: sl(),
      createPostUseCase: sl(),
      likePostUseCase: sl(),
      unlikePostUseCase: sl(),
      getUserPostsUseCase: sl(),
    ),
  );
  sl.registerFactory(() => AchievementBloc(
        getAchievementsUseCase: sl(),
        getAchievementsByCategoryUseCase: sl(),
      ));
}
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitbody/data/repositories/auth_repository_impl.dart';
import 'package:fitbody/data/repositories/workout_repository_impl.dart';
import 'package:fitbody/domain/repositories/auth_repository.dart';
import 'package:fitbody/domain/repositories/workout_repository.dart';
import 'package:fitbody/domain/usecases/auth/login_usecase.dart';
import 'package:fitbody/domain/usecases/auth/register_usecase.dart';
import 'package:fitbody/domain/usecases/workout/get_workouts_usecase.dart';
import 'package:fitbody/presentation/bloc/auth/auth_bloc.dart';
import 'package:fitbody/presentation/bloc/workout/workout_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkoutsUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));
  sl.registerFactory(() => WorkoutBloc(
    getWorkoutsUseCase: sl(),
  ));
}
