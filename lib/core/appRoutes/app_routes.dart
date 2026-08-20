import 'package:fitness_app/presentation/daily/daily_tracking/presentation/pages/daily_page.dart';
import 'package:fitness_app/presentation/auth/pages/forgetPass_page.dart';
import 'package:fitness_app/presentation/auth/pages/otp_pages.dart';
import 'package:fitness_app/presentation/auth/pages/create_new_password_page.dart';
import 'package:fitness_app/presentation/auth/pages/password_changed_success_page.dart';
import 'package:fitness_app/presentation/checkIn/pages/checkIn_pages.dart';
import 'package:fitness_app/presentation/home/pages/home_page.dart';
import 'package:fitness_app/presentation/training/pages/exercise_page.dart';
import 'package:fitness_app/presentation/training/pages/training_plan_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_plan_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_food_items_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_track_meals_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_statistics_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_peds_page.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_supplement_page.dart';
import 'package:fitness_app/presentation/training/pages/exercise_detail_page.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:fitness_app/presentation/training/pages/training_history_detail_page.dart';
import 'package:fitness_app/presentation/training/pages/training_history_page.dart';
import 'package:fitness_app/presentation/training/pages/training_plan_detail_page.dart';
import 'package:fitness_app/presentation/training/pages/training_split_page.dart';
import 'package:fitness_app/presentation/training/pages/workout_session_page.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/presentation/auth/pages/login_page.dart';
import 'package:fitness_app/presentation/auth/pages/splash_page.dart';
import 'package:fitness_app/presentation/auth/pages/webview_screen.dart';
import 'package:fitness_app/presentation/notification/pages/notification_page.dart';

import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splashPage = '/splash';
  static const String loginPage = '/login';
  static const String forgetPassPage = '/forgetPass';
  static const String otpPages = '/otpPages';
  static const String createNewPasswordPage = '/create_new_password';
  static const String passwordChangedSuccessPage = '/password_changed_success';
  static const String homePage = '/home';
  static const String checkinPages = '/checkinPages';
  static const String dailyPage = '/daily';
  static const String exercisesPage = '/exercises';
  static const String exerciseDetailPage = '/exercise_detail';
  static const String nutritionPage = '/nutrition';
  static const String nutritionPlanPage = '/nutrition_plan';
  static const String nutritionFoodItemsPage = '/nutrition_food_items';
  static const String nutritionTrackMealsPage = '/nutrition_track_meals';
  static const String nutritionStatisticsPage = '/nutrition_statistics';
  static const String nutritionPEDsPage = '/nutrition_peds';
  static const String nutritionSupplementPage = '/nutrition_supplement';
  static const String trainingSplitPage = '/training_split';
  static const String trainingSplitDetailPage = '/training_split_detail';
  static const String WorkoutSessionPage = '/workout_session';
  static const String trainingPlanPage = '/training_plan';
  static const String trainingHistoryPage = '/training_history';
  static const String trainingHistoryDetailPage = '/training_history_detail';
  static const String trainingPlanDetailPage = '/training_plan_detail';
  static const String webViewScreen = '/webview';
  static const String rusuiPage = '/rusui';
  static const String notificationPage = '/notifications';

  static Page<dynamic> fadeTransitionPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<dynamic>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

final GoRouter AppRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: AppRoutes.splashPage,
  routes: [
    GoRoute(
      path: AppRoutes.splashPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const SplashPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.loginPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgetPassPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ForgetpassPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.webViewScreen,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final url =
            extra?['url'] as String? ?? 'https://form.typeform.com/to/hSeMPXph';
        final title = extra?['title'] as String? ?? '';
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: WebViewScreen(url: url, title: title),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.otpPages,
      pageBuilder: (context, state) {
        final email = state.extra as String? ?? '';
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: OtpPages(email: email),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.createNewPasswordPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const CreateNewPasswordPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.passwordChangedSuccessPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const PasswordChangedSuccessPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.homePage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.notificationPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NotificationPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.checkinPages,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const CheckinPages(),
      ),
    ),

    GoRoute(
      path: AppRoutes.dailyPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const DailyPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionPlanPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionPlanPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionFoodItemsPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionFoodItemsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionTrackMealsPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionTrackMealsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionStatisticsPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionStatisticsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionPEDsPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionPEDsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.nutritionSupplementPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const NutritionSupplementPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.exercisesPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const ExercisePage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.trainingPlanPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingPlanPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.WorkoutSessionPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final planId = extra is String ? extra : 'unknown';
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: WorkoutSessionPage(planId: planId),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.trainingHistoryPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingHistoryPage(),
      ),
    ),

    GoRoute(
      path: AppRoutes.trainingHistoryDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final historyItem = extra is TrainingHistoryEntity
            ? extra
            : TrainingHistoryEntity(
                id: '',
                userId: '',
                trainingName: 'Error',
                time: const TrainingTimeEntity(hour: '0', minute: '0'),
                pushData: const [],
                note: '',
                dateTime: DateTime.now(),
                updatedAt: DateTime.now(),
                totalWeight: 0,
              );
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: TrainingHistoryDetailPage(historyItem: historyItem),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.trainingPlanDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final planId = extra is String ? extra : '0';
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: TrainingPlanDetailPage(planId: planId),
        );
      },
    ),

    GoRoute(
      path: AppRoutes.trainingSplitPage,
      pageBuilder: (context, state) => AppRoutes.fadeTransitionPage(
        context: context,
        state: state,
        child: const TrainingSplitPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.exerciseDetailPage,
      pageBuilder: (context, state) {
        final extra = state.extra;
        final ex = extra is ExerciseEntity ? extra : null;
        return AppRoutes.fadeTransitionPage(
          context: context,
          state: state,
          child: ExerciseDetailPage(
            exercise:
                ex ??
                const ExerciseEntity(
                  id: 'unknown',
                  title: 'Exercise',
                  category: 'All',
                  equipment: '',
                  tags: [],
                  description: '',
                  imageUrl: '',
                ),
          ),
        );
      },
    ),
  ],
);
