import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/assets_path.dart';
import 'package:fitness_app/presentation/auth/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PasswordChangedSuccessPage extends StatelessWidget {
  const PasswordChangedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage(AssetsPath.welcome),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A3DF0).withOpacity(0.4),
                    blurRadius: 20.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 40.sp),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Your Password Has Been\nChanged Successfully',
              style: AppTextStyle.authHeading1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              text: 'Back To Home',
              onPressed: () {
                context.go(AppRoutes.homePage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
