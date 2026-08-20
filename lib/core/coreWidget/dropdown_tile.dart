import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownTile extends StatelessWidget {
  final String title;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final double height;
  final String hint;

  const DropdownTile({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    this.height = 40,
    this.hint = 'Select',
  });

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0XFF101021),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, controller) => SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: ListView(
                controller: controller,
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
                  ...options.map((o) => _option(context, o)).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(BuildContext context, String o) {
    final bool selected = value == o;
    return InkWell(
      onTap: () {
        onChanged(o);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              height: 18.h,
              width: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.white : Colors.white54,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              o,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openSheet(context),
      child: Container(
        height: height.h,
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
                color: (value != null ? Colors.green : Colors.grey).withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                value ?? hint,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.expand_more, color: Colors.white70, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class DropdownMultiSelectTile extends StatelessWidget {
  final String title;
  final Set<String> selected;
  final List<String> options;
  final ValueChanged<Set<String>> onChanged;
  final String hint;

  const DropdownMultiSelectTile({
    super.key,
    required this.title,
    required this.selected,
    required this.options,
    required this.onChanged,
    this.hint = 'Select',
  });

  void _openSheet(BuildContext context) {
    final temp = Set<String>.from(selected);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0XFF101021),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      useSafeArea: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateSB) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (context, controller) => SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.sp),
              child: ListView(
                controller: controller,
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
                  ...options.map(
                    (o) => InkWell(
                      onTap: () {
                        if (temp.contains(o)) {
                          temp.remove(o);
                        } else {
                          temp.add(o);
                        }
                        setStateSB(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Container(
                              height: 10.h,
                              width: 10.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: temp.contains(o)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              o,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        onChanged(temp);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Apply',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = selected.isEmpty ? hint : '${selected.length} selected';
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
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                display,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.expand_more, color: Colors.white70, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
