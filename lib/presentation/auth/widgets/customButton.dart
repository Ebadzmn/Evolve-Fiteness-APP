import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = const Color(
      0xFF1F2050,
    ), // ডিফল্ট বাটন কালার (ছবির মতো)
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // বাটনটি পুরো স্ক্রিন জুড়ে প্রশস্ত হবে
      height: 55, // বাটনের উচ্চতা
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // ব্যাকগ্রাউন্ড কালার
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // বর্ডার রাউন্ড (Text Field এর সাথে মিল রেখে)
          ),
          elevation: 2, // হালকা শ্যাডো
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
