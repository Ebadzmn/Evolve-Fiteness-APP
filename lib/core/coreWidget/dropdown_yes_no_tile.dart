import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownYesNoTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const DropdownYesNoTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0XFF101021),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      useSafeArea: true,
      builder: (_) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _optionRow(context, 'Yes', true),
                  SizedBox(height: 12.h),
                  _optionRow(context, 'No', false),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _optionRow(BuildContext context, String text, bool selectedValue) {
    final bool selected = value == selectedValue;
    final Color fillColor = selected ? Colors.green : Colors.grey;
    final Color borderColor = selected ? Colors.white : Colors.grey;
    return InkWell(
      onTap: () {
        onChanged(selectedValue);
        Navigator.of(context).pop();
      },
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openSheet(context),
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0XFF152032),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: value
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                value ? 'Yes' : 'No',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right, color: Colors.white70, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
