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

class ForgetpassPage extends StatefulWidget {
  const ForgetpassPage({super.key});

  @override
  State<ForgetpassPage> createState() => _ForgetpassPageState();
}

class _ForgetpassPageState extends State<ForgetpassPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            context.push(AppRoutes.otpPages, extra: _emailController.text);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
          child: Column(
            children: [
              SizedBox(height: 10.h),

              CustomAppBar(
                title: AppLocalizations.of(context)!.forgetPasswordAppBarTitle,
              ),

              SizedBox(height: 81.h),

              Text(
                AppLocalizations.of(context)!.forgetPasswordTitle,
                style: AppTextStyle.authHeading1,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 11.h),

              Text(
                AppLocalizations.of(context)!.forgetPasswordDescription,
                style: AppTextStyle.authHeading2,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              CustomTextField(
                label: AppLocalizations.of(context)!.forgetPasswordEmailLabel,
                hintText: AppLocalizations.of(context)!.forgetPasswordEmailHint,
                prefixIcon: Icons.email,
                controller: _emailController,
              ),

              SizedBox(height: 24.h),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: state is AuthLoading
                        ? AppLocalizations.of(context)!.forgetPasswordSending
                        : AppLocalizations.of(context)!.forgetPasswordSendCode,
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_emailController.text.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                ForgetPasswordRequested(
                                  email: _emailController.text,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.forgetPasswordEmailRequired,
                                  ),
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
