import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/config/app_text_style.dart'; // আপনার স্টাইল ফাইল ইম্পোর্ট করুন

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackButton = true, // ডিফল্টভাবে ব্যাক বাটন দেখাবে
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
              child: Container(
                width: 32.w,
                height: 32.w,

                child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
              ),
            ),
          ),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyle.appbarHeading,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
