import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class YesNoSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double spacing;

  const YesNoSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _circleOption(
          text: 'Yes',
          selected: value,
          onTap: () => onChanged(true),
        ),
        SizedBox(width: spacing.w),
        _circleOption(
          text: 'No',
          selected: !value,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }

  Widget _circleOption({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final Color fillColor = selected ? Colors.green : Colors.grey;
    final Color borderColor = selected ? Colors.white : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 22.h,
            width: 22.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: Border.all(color: borderColor, width: 1.w),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
