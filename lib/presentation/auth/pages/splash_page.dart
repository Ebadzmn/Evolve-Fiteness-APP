import 'dart:async';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/assets_path.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // 2 seconds delay for splash animation or branding
    Timer(const Duration(seconds: 2), () {
      // After delay, trigger auth check
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.homePage);
        } else if (state is AuthUnauthenticated) {
          context.go(AppRoutes.loginPage);
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                AssetsPath.splashLogo,
                width: 300.w,
                height: 300.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
