import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/bloc/locale_cubit.dart';
import 'package:fitness_app/core/notifications/fcm_service.dart';
import 'package:fitness_app/core/session/session_manager.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'injection_container.dart' as di;
import 'package:get/get.dart';

import 'package:fitness_app/core/network/connectivity_cubit.dart';
import 'package:fitness_app/core/coreWidget/connectivity_banner.dart';
import 'package:fitness_app/core/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await di.init();
  await di.sl<FcmService>().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SessionManager _sessionManager;
  StreamSubscription<void>? _sessionSubscription;

  @override
  void initState() {
    super.initState();
    _sessionManager = di.sl<SessionManager>();
    _sessionSubscription = _sessionManager.onSessionExpired.listen((_) {
      // Navigate to login page when session expires
      AppRouter.go(AppRoutes.loginPage);
    });
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
          BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
          BlocProvider<ConnectivityCubit>(create: (context) => di.sl<ConnectivityCubit>()),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return GetMaterialApp.router(
              title: "Evolve - Coaching App",
              routeInformationParser: AppRouter.routeInformationParser,
              routerDelegate: AppRouter.routerDelegate,
              routeInformationProvider: AppRouter.routeInformationProvider,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) {
                return ConnectivityBannerWrapper(
                  child: child ?? const SizedBox.shrink(),
                );
              },
              theme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme().copyWith(
                  titleLarge: AppTextStyle.appbarHeading,
                  headlineMedium: AppTextStyle.authHeading1,
                  headlineSmall: AppTextStyle.authHeading2,
                ),
                scaffoldBackgroundColor: AppColor.primaryColor,
                primaryColor: AppColor.primaryColor,
                appBarTheme: AppBarTheme(
                  titleTextStyle: AppTextStyle.appbarHeading,
                  backgroundColor: AppColor.primaryColor,
                ),
              ),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
