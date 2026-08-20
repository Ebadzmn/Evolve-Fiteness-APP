import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // উপরের লেবেল (যেমন: Email)
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8), // লেবেল এবং ইনপুটের মাঝের গ্যাপ
        // টেক্সট ফিল্ড
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
          ), // টাইপ করা টেক্সটের কালার
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(
              0xFF101020,
            ), // টেক্সটফিল্ডের ব্যাকগ্রাউন্ড কালার (ডার্ক)
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white, fontSize: 14),

            // বাম পাশের আইকন
            prefixIcon: Icon(prefixIcon, color: Colors.grey[500], size: 20),

            // ডান পাশের আইকন (পাসওয়ার্ডের চোখের আইকনের জন্য)
            suffixIcon: suffixIcon,

            // বর্ডার স্টাইল
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ), // ফোকাস করলে বর্ডার কালার
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
