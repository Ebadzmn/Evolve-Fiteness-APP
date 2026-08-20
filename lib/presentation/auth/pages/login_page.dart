import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/bloc/locale_cubit.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRoutes.homePage);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.h),

                    CustomAppBar(
                      title: AppLocalizations.of(context)!.loginAppBarTitle,
                    ),

                    SizedBox(height: 70.h),

                    Text(
                      AppLocalizations.of(context)!.loginHeadline,
                      style: AppTextStyle.authHeading1,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 11.h),

                    SizedBox(height: 52.h),

                    CustomTextField(
                      controller: emailController,
                      hintText: AppLocalizations.of(context)!.loginEmailHint,
                      label: AppLocalizations.of(context)!.loginEmailLabel,
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24.h),

                    CustomTextField(
                      controller: passwordController,
                      hintText: AppLocalizations.of(context)!.loginPasswordHint,
                      label: AppLocalizations.of(context)!.loginPasswordLabel,
                      prefixIcon: Icons.lock,
                      isPassword: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                AppRoutes.webViewScreen,
                                extra: {
                                  'url':
                                      'https://forms.cloud.microsoft/pages/responsepage.aspx?id=DQSIkWdsW0yxEjajBLZtrQAAAAAAAAAAAAO__SF0W0RUMjBBS0lPTEtQMEJORlBWRjNBRDY3VjdBSy4u&route=shorturl',
                                },
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.applyHereText,
                              style: AppTextStyle.authHeading3.copyWith(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF8080EE),
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.forgetPassPage);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.loginForgotPassword,
                            style: AppTextStyle.authHeading3,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              CustomButton(
                                text: AppLocalizations.of(context)!.loginButton,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginRequested(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 16.h),
                              _LanguageToggleButton(),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isEnglish = locale.languageCode == 'en';
    final label = isEnglish ? 'EN' : 'DE';

    return Align(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: Colors.white.withOpacity(0.8),
        ),
        onPressed: () {
          context.read<LocaleCubit>().toggleLocale();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
