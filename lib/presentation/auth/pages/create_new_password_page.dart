import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:fitness_app/presentation/auth/widgets/customTextField.dart';
import 'package:fitness_app/presentation/auth/widgets/custom_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({super.key});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final localizations = AppLocalizations.of(context)!;
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.authFillBothPasswordFields)),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.authPasswordsDoNotMatch)));
      return;
    }

    context.read<AuthBloc>().add(
      AuthResetPasswordRequested(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            context.go(AppRoutes.passwordChangedSuccessPage);
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
                title: localizations.authCreateNewPassword,
                showBackButton: true,
              ),
              SizedBox(height: 69.h),
              Text(
                localizations.authCreateNewPassword,
                style: AppTextStyle.authHeading1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 11.h),
              Text(
                'Your New Password Must Be Different\nFrom Previous Passwords.',
                style: AppTextStyle.authHeading2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                label: localizations.authNewPassword,
                hintText: localizations.authEnterNewPassword,
                prefixIcon: Icons.lock,
                isPassword: _obscureNewPassword,
                controller: _newPasswordController,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                label: localizations.authConfirmPassword,
                hintText: localizations.authReEnterNewPassword,
                prefixIcon: Icons.lock,
                isPassword: _obscureConfirmPassword,
                controller: _confirmPasswordController,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: state is AuthLoading ? localizations.checkInLoadingLabel : localizations.authConfirmPassword,
                    onPressed: state is AuthLoading ? () {} : _onConfirm,
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
