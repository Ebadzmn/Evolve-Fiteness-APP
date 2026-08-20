import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/apiUrls/api_urls.dart';
import 'core/network/api_client.dart';
import 'core/network/connectivity_cubit.dart';
import 'core/notifications/fcm_service.dart';
import 'core/storage/token_storage.dart';
import 'core/storage/nutrition_storage.dart';
import 'core/session/session_manager.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/forget_password_usecase.dart';

import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/daily_tracking/data/datasources/daily_tracking_remote_datasource.dart';
import 'features/daily_tracking/data/repositories/daily_repository_impl.dart';
import 'domain/repositories/daily/daily_repository.dart';
import 'domain/usecases/daily/get_daily_initial_usecase.dart';
import 'domain/usecases/daily/get_daily_by_date_usecase.dart';
import 'domain/usecases/daily/save_daily_usecase.dart';
import 'domain/usecases/daily/update_daily_usecase.dart';
import 'presentation/daily/daily_tracking/presentation/pages/bloc/daily_bloc.dart';
import 'presentation/daily/daily_tracking/presentation/pages/controller/daily_tracking_controller.dart';
import 'features/training/data/datasources/training_remote_datasource.dart';
import 'features/training/data/repositories/training_repository_impl.dart';
import 'domain/repositories/training_history/training_plan_repository.dart';
import 'features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/save_training_history_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/domain/repositories/training_history/training_history_repository.dart';
import 'package:fitness_app/features/training/data/repositories/training_history_repository_impl.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/workout_session/workout_session_cubit.dart';
import 'features/training/domain/usecases/get_exercises_usecase.dart';
import 'features/training/domain/repositories/exercise_repository.dart';
import 'features/training/data/repositories/exercise_repository_impl.dart';
import 'features/training/data/datasources/exercise_remote_data_source.dart';
import 'features/training/data/datasources/training_split_remote_data_source.dart';
import 'features/training/data/repositories/training_split_repository_impl.dart';
import 'domain/repositories/training_history/training_split_repository.dart';
import 'features/training/domain/usecases/get_training_split_usecase.dart';
import 'features/training/presentation/pages/bloc/training_spilt2/training_split_bloc.dart';
import 'presentation/training/controllers/workout_session_controller.dart';
import 'features/nutrition/data/datasources/nutrition_remote_data_source.dart';
import 'features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'features/nutrition/data/repositories/nutrition_repository.dart';
import 'features/nutrition/data/repositories/fake_nutrition_repository.dart';
import 'features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'features/nutrition/domain/usecases/get_nutrition_initial_usecase.dart';
import 'features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_bloc.dart';
import 'features/nutrition/presentation/pages/bloc/nutrition_bloc/nutrition_bloc.dart';
import 'features/nutrition/presentation/pages/bloc/track_meals/track_meals_bloc.dart';
import 'features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'features/nutrition/domain/usecases/get_track_meal_suggestions_usecase.dart';
import 'features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'features/nutrition/domain/usecases/delete_tracked_food_item_usecase.dart';
import 'features/nutrition/domain/usecases/add_food_item_to_meal_usecase.dart';
import 'features/nutrition/domain/usecases/add_food_items_to_meal_usecase.dart';
import 'features/nutrition/domain/usecases/get_nutrition_statistics_usecase.dart';
import 'features/nutrition/domain/usecases/get_food_items_usecase.dart';
import 'features/nutrition/domain/usecases/sync_nutrition_data_usecase.dart';
import 'features/nutrition/domain/usecases/update_water_usecase.dart';
import 'features/nutrition/domain/usecases/get_water_config_usecase.dart';
import 'features/nutrition/presentation/pages/bloc/nutrition_statistics/nutrition_statistics_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_supplements_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_bloc.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'presentation/nutrition/controllers/nutrition_controller.dart';
import 'presentation/daily/controllers/daily_nutrition_controller.dart';
import 'features/notification/data/datasources/notes_remote_data_source.dart';
import 'features/notification/data/repositories/notes_repository_impl.dart';
import 'features/notification/domain/repositories/notes_repository.dart';
import 'features/notification/domain/usecases/get_athlete_notes_usecase.dart';
import 'features/notification/presentation/bloc/notification_bloc.dart';
import 'features/timeline/data/datasources/timeline_remote_data_source.dart';
import 'features/timeline/data/repositories/timeline_repository_impl.dart';
import 'features/timeline/domain/repositories/timeline_repository.dart';
import 'features/timeline/domain/usecases/get_timeline_usecase.dart';
import 'features/timeline/presentation/bloc/timeline_bloc.dart';
import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_date_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_history_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_initial_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_user_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/save_checkin_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  //! Core
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<NutritionStorage>(() => NutritionStorage(sl()));
  sl.registerLazySingleton<SessionManager>(
    () => SessionManager(tokenStorage: sl()),
  );
  sl.registerLazySingleton<NetworkConfig>(
    () => NetworkConfig(baseUrl: ApiUrls.baseUrl),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(config: sl(), tokenStorage: sl(), sessionManager: sl()),
  );
  sl.registerLazySingleton<FcmService>(
    () => FcmService(tokenStorage: sl(), apiClient: sl()),
  );
  sl.registerLazySingleton<ConnectivityCubit>(
    () => ConnectivityCubit(),
  );

  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      forgetPasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      tokenStorage: sl(),
      syncNutritionDataUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), tokenStorage: sl()),
  );

  //! Features - Daily Tracking
  // Bloc
  sl.registerFactory(
    () => DailyTrackingController(
      getInitial: sl(),
      getByDate: sl(),
      saveDaily: sl(),
      updateDaily: sl(),
      sharedPreferences: sl(),
      getTrainingPlans: sl(),
    ),
  );

  sl.registerFactory(
    () => DailyBloc(
      getInitial: sl(),
      getByDate: sl(),
      saveDaily: sl(),
      updateDaily: sl(),
      sharedPreferences: sl(),
      getTrainingPlans: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDailyInitialUseCase(sl()));
  sl.registerLazySingleton(() => GetDailyByDateUseCase(sl()));
  sl.registerLazySingleton(() => SaveDailyUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDailyUseCase(sl()));

  // Repository
  sl.registerLazySingleton<DailyRepository>(
    () => DailyRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DailyTrackingRemoteDataSource>(
    () => DailyTrackingRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Training
  // Bloc
  // TrainingPlanBloc is created in the UI using provided UseCase, or can be registered here if needed factory.
  // For now, staying consistent with existing pattern if Blocs are factories.
  sl.registerFactory(
    () => WorkoutSessionCubit(
      getTrainingPlanById: sl(),
      saveTrainingHistory: sl(),
      getProfile: sl(),
    ),
  );

  sl.registerFactory(
    () => WorkoutSessionController(
      getTrainingPlanById: sl(),
      getTrainingHistory: sl(),
      saveTrainingHistory: sl(),
      getProfile: sl(),
      exerciseRepository: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTrainingPlansUseCase(sl()));
  sl.registerLazySingleton(() => GetTrainingPlanByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => SaveTrainingHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetTrainingHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TrainingPlanRepository>(
    () => TrainingRepositoryImpl(remoteDataSource: sl(), getProfile: sl()),
  );
  sl.registerLazySingleton<TrainingHistoryRepository>(
    () => TrainingHistoryRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TrainingRemoteDataSource>(
    () => TrainingRemoteDataSourceImpl(apiClient: sl()),
  );

  // Exercise Feature
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(apiClient: sl()),
  );

  // Training Split Feature
  sl.registerFactory(() => TrainingSplitBloc(getSplit: sl(), getProfile: sl()));
  sl.registerLazySingleton(() => GetTrainingSplitUseCase(sl()));
  sl.registerLazySingleton<TrainingSplitRepository>(
    () => TrainingSplitRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TrainingSplitRemoteDataSource>(
    () => TrainingSplitRemoteDataSourceImpl(apiClient: sl()),
  );

  // Nutrition Feature
  sl.registerFactory(() => NutritionPlanBloc(getPlan: sl(), getProfile: sl()));
  sl.registerFactory(
    () => NutritionBloc(
      getProfile: sl(),
      getPlan: sl(),
      getTrackMeals: sl(),
      nutritionStorage: sl(),
    ),
  );
  sl.registerFactory(
    () => NutritionController(
      getProfile: sl(),
      getPlan: sl(),
      getTrackMeals: sl(),
      nutritionStorage: sl(),
      tokenStorage: sl(),
    ),
  );
  sl.registerFactory(
    () => DailyNutritionController(
      getPlan: sl(),
      getProfile: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetNutritionInitialUseCase(sl()));
  sl.registerLazySingleton(
    () => GetNutritionPlanUseCase(sl()),
  ); // Changed from GetNutritionInitialUseCase to match original
  sl.registerLazySingleton(() => GetFoodItemsUseCase(sl()));
  sl.registerLazySingleton(() => GetSupplementsUseCase(sl()));
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NutritionRemoteDataSource>(
    () => NutritionRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton(() => FakeNutritionRepository());

  // Track Meals Feature
  sl.registerFactory(
    () => TrackMealsBloc(
      initialDate: DateTime.now(),
      getMeals: sl(), // Kept original 'getMeals'
      getPlan: sl(),
      saveMeal: sl(),
      deleteFoodItem: sl(),
      addFoodItemsToMeal: sl(),
      getSuggestions: sl(),
      getProfile: sl(),
      updateWater: sl(),
      getWaterConfig: sl(),
    ),
  );
  sl.registerFactory(
    () => NutritionSupplementBloc(getSupplements: sl(), getProfile: sl()),
  );
  sl.registerLazySingleton(() => GetTrackMealsUseCase(sl()));
  sl.registerLazySingleton(() => GetTrackMealSuggestionsUseCase(sl()));
  sl.registerLazySingleton(() => SaveTrackMealUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTrackedFoodItemUseCase(sl()));
  // AddFoodToMeal
  sl.registerLazySingleton(() => AddFoodItemToMealUseCase(sl()));
  sl.registerLazySingleton(() => AddFoodItemsToMealUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWaterUseCase(sl()));
  sl.registerLazySingleton(() => GetWaterConfigUseCase(sl()));

  // Notes / Notification Feature
  sl.registerFactory(
    () => NotificationBloc(
      getNotes: sl(),
      getProfile: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetAthleteNotesUseCase(sl()));
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(apiClient: sl()),
  );

  // Nutrition Statistics
  sl.registerFactory(() => NutritionStatisticsBloc(getStatistics: sl()));
  sl.registerLazySingleton(() => GetNutritionStatisticsUseCase(sl()));

  sl.registerLazySingleton(
    () => SyncNutritionDataUseCase(
      getProfileUseCase: sl(),
      getNutritionPlanUseCase: sl(),
      getTrackMealsUseCase: sl(),
      nutritionStorage: sl(),
      tokenStorage: sl(),
    ),
  );

  // Feature - Profile
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl()),
  );

  // Feature - Timeline
  sl.registerFactory(() => TimelineBloc(getTimelineUseCase: sl()));
  sl.registerLazySingleton(() => GetTimelineUseCase(sl()));
  sl.registerLazySingleton<TimelineRepository>(
    () => TimelineRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TimelineRemoteDataSource>(
    () => TimelineRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Feature - CheckIn
  sl.registerLazySingleton(() => FakeCheckInRepository(apiClient: sl()));
  sl.registerLazySingleton(() => GetCheckInInitialUseCase(sl()));
  sl.registerLazySingleton(() => SaveCheckInUseCase(sl()));
  sl.registerLazySingleton(() => GetCheckInHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetCheckInDateUseCase(sl()));
  sl.registerLazySingleton(() => GetCheckInUserUseCase(sl()));
}
