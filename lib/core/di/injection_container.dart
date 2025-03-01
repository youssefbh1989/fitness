import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/user_data_source.dart';
import '../../data/datasources/user_data_source_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
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
import '../../domain/entities/user.dart'; // Assuming User entity exists


final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(sharedPreferences: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(dataSource: sl()));
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
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), signupUseCase: sl()));
  sl.registerFactory(() => OnboardingBloc());
  sl.registerFactory(() => UserBloc(getUserProfileUseCase: sl()));
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
  sl.registerFactory(() => ProgressBloc(getProgressHistory: sl(), addProgressEntry: sl()));
  sl.registerFactory(() => NotificationBloc(
        getNotifications: sl(),
        markAsRead: sl(),
        markAllAsRead: sl(),
      ));
  sl.registerFactory(() => CommunityBloc(
        getPostsUseCase: sl(),
        createPostUseCase: sl(),
        likePostUseCase: sl(),
        unlikePostUseCase: sl(),
        getUserPostsUseCase: sl(),
      ));
  sl.registerFactory(() => AchievementBloc(
        getAchievementsUseCase: sl(),
        getAchievementsByCategoryUseCase: sl(),
      ));
}

//Data Layer

//Data Sources
abstract class UserDataSource {
  Future<User> getUserProfile();
  Future<void> updateUserProfile(User user);
}

class UserDataSourceImpl implements UserDataSource {
  final SharedPreferences sharedPreferences;

  UserDataSourceImpl({required this.sharedPreferences});

  @override
  Future<User> getUserProfile() async {
    //Implementation to fetch user profile from SharedPreferences or other source
    //Replace with actual implementation
    return User(id: 1, name: 'Test User', email: 'test@example.com');
  }

  @override
  Future<void> updateUserProfile(User user) async {
    //Implementation to update user profile in SharedPreferences or other source
  }
}


//Repositories
abstract class UserRepository {
  Future<User> getUserProfile();
  Future<void> updateUserProfile(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<User> getUserProfile() => dataSource.getUserProfile();

  @override
  Future<void> updateUserProfile(User user) => dataSource.updateUserProfile(user);
}


//Domain Layer

//Use Cases
class GetUserProfileUseCase {
  final UserRepository userRepository;

  GetUserProfileUseCase(this.userRepository);

  Future<User> call() async {
    return await userRepository.getUserProfile();
  }
}

class UpdateUserProfileUseCase {
  final UserRepository userRepository;

  UpdateUserProfileUseCase(this.userRepository);

  Future<void> call(User user) async {
    await userRepository.updateUserProfile(user);
  }
}


//Presentation Layer

//Blocs
//UserBloc - Events and States are added below

//User Events
abstract class UserEvent {}

class GetUserProfile extends UserEvent {}

class UpdateUserProfile extends UserEvent {
  final User user;
  UpdateUserProfile({required this.user});
}


//User States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded({required this.user});
}

class UserError extends UserState {
  final String message;
  UserError({required this.message});
}


//User Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  UserBloc({required this.getUserProfileUseCase, required this.updateUserProfileUseCase}) : super(UserInitial()) {
    on<GetUserProfile>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await getUserProfileUseCase();
        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
    on<UpdateUserProfile>((event, emit) async {
      emit(UserLoading());
      try {
        await updateUserProfileUseCase(event.user);
        //Potentially fetch updated user profile
        final user = await getUserProfileUseCase();
        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
  }
}


//Entities
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/user_data_source.dart';
import '../../data/datasources/user_data_source_impl.dart';
import '../../data/datasources/workout_data_source.dart';
import '../../data/datasources/workout_data_source_impl.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/datasources/auth_data_source_impl.dart';
import '../../data/datasources/nutrition_data_source.dart';
import '../../data/datasources/nutrition_data_source_impl.dart';
import '../../data/datasources/progress_data_source.dart';
import '../../data/datasources/progress_data_source_impl.dart';
import '../../data/datasources/achievement_data_source.dart';
import '../../data/datasources/achievement_data_source_impl.dart';

import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/achievement_repository_impl.dart';

import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/achievement_repository.dart';

import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/update_user_profile_usecase.dart';

import '../../domain/usecases/workout/get_workouts_usecase.dart';
import '../../domain/usecases/workout/get_workout_detail_usecase.dart';
import '../../domain/usecases/workout/create_workout_usecase.dart';
import '../../domain/usecases/workout/track_workout_usecase.dart';
import '../../domain/usecases/workout/complete_workout_usecase.dart';

import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/check_auth_status_usecase.dart';

import '../../domain/usecases/nutrition/get_nutrition_data_usecase.dart';
import '../../domain/usecases/nutrition/add_meal_usecase.dart';

import '../../domain/usecases/progress/get_progress_photos_usecase.dart';
import '../../domain/usecases/progress/add_progress_photo_usecase.dart';

import '../../domain/usecases/achievement/get_achievements_usecase.dart';

import '../../presentation/blocs/user/user_bloc.dart';
import '../../presentation/blocs/workout/workout_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/nutrition/nutrition_bloc.dart';
import '../../presentation/blocs/progress/progress_bloc.dart';
import '../../presentation/blocs/workout_tracker/workout_tracker_bloc.dart';
import '../../presentation/blocs/achievement/achievement_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<WorkoutDataSource>(
    () => WorkoutDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NutritionDataSource>(
    () => NutritionDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProgressDataSource>(
    () => ProgressDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AchievementDataSource>(
    () => AchievementDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => GetWorkoutsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetWorkoutDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateWorkoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => TrackWorkoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => CompleteWorkoutUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => GetNutritionDataUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddMealUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => GetProgressPhotosUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddProgressPhotoUseCase(repository: sl()));
  
  sl.registerLazySingleton(() => GetAchievementsUseCase(repository: sl()));

  // BLoCs
  sl.registerFactory(() => UserBloc(getUserProfileUseCase: sl()));
  
  sl.registerFactory(() => WorkoutBloc(
    getWorkoutsUseCase: sl(),
    getWorkoutDetailUseCase: sl(),
    createWorkoutUseCase: sl(),
  ));
  
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    logoutUseCase: sl(),
    checkAuthStatusUseCase: sl(),
  ));
  
  sl.registerFactory(() => NutritionBloc(
    getNutritionDataUseCase: sl(),
    addMealUseCase: sl(),
  ));
  
  sl.registerFactory(() => ProgressBloc(
    getProgressPhotosUseCase: sl(),
    addProgressPhotoUseCase: sl(),
  ));
  
  sl.registerFactory(() => WorkoutTrackerBloc(
    trackWorkoutUseCase: sl(),
    completeWorkoutUseCase: sl(),
  ));
  
  sl.registerFactory(() => AchievementBloc(
    getAchievementsUseCase: sl(),
  ));
}
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../presentation/blocs/achievement/achievement_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/nutrition/nutrition_bloc.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';
import '../../presentation/blocs/user/user_bloc.dart';
import '../../presentation/blocs/workout/workout_bloc.dart';
import '../../presentation/blocs/workout_tracker/workout_tracker_bloc.dart';
import '../../core/utils/analytics_service.dart';
import '../../core/utils/notification_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<AppDatabase>(AppDatabase());
  
  // Utils
  sl.registerSingleton<AnalyticsService>(AnalyticsService());
  sl.registerSingleton<NotificationService>(NotificationService());
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sharedPreferences: sl()),
  );
  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(database: sl(), sharedPreferences: sl()),
  );
  
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(database: sl()),
  );
  
  sl.registerLazySingleton<AchievementRepository>(
    () => AchievementRepositoryImpl(database: sl()),
  );
  
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(database: sl()),
  );
  
  // BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl(), userRepository: sl()),
  );
  
  sl.registerFactory<UserBloc>(
    () => UserBloc(userRepository: sl()),
  );
  
  sl.registerFactory<WorkoutBloc>(
    () => WorkoutBloc(workoutRepository: sl()),
  );
  
  sl.registerFactory<WorkoutTrackerBloc>(
    () => WorkoutTrackerBloc(workoutRepository: sl()),
  );
  
  sl.registerFactory<AchievementBloc>(
    () => AchievementBloc(
      achievementRepository: sl(),
      userRepository: sl(),
    ),
  );
  
  sl.registerFactory<NutritionBloc>(
    () => NutritionBloc(nutritionRepository: sl()),
  );
  
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(sharedPreferences: sl()),
  );
}
