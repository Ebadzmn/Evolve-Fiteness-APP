import 'dart:async';

import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:fitness_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OtpPages extends StatefulWidget {
  final String email;
  const OtpPages({super.key, required this.email});

  @override
  State<OtpPages> createState() => _OtpPagesState();
}

class _OtpPagesState extends State<OtpPages> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  int _remainingTime = 120; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            context.go(AppRoutes.createNewPasswordPage);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 32.h),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CustomAppBar(
                title: localizations.authOtpVerification,
                showBackButton: true,
              ),

              SizedBox(height: 69.h),

              Text(localizations.authCheckYourEmail, style: AppTextStyle.authHeading1),

              SizedBox(height: 11.h),

              Text(
                'We send a verification code Please Check your e-mail',
                style: AppTextStyle.authHeading2,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                label: localizations.authOtp,
                hintText: localizations.authEnterOtp,
                prefixIcon: Icons.lock,
                controller: _otpController,
              ),
              SizedBox(height: 18.h),

              Text(
                'This code will expire in ${_formatTime(_remainingTime)}',
                style: AppTextStyle.authHeading2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: state is AuthLoading ? localizations.checkInLoadingLabel : localizations.authOtpVerification,
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_otpController.text.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                VerifyOtpRequested(
                                  email: widget.email,
                                  otp: _otpController.text,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localizations.authPleaseEnterOtp),
                                ),
                              );
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
