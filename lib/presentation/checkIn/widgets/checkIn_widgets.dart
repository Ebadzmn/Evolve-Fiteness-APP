import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'dart:ui';
import 'dart:io';

class CheckInStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const CheckInStep({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    // Colors based on state
    final indicatorColor = isActive || isCompleted
        ? const Color(0xFF82C941)
        : Colors.white12;
    final circleColor = isActive || isCompleted
        ? const Color(0xFF82C941)
        : const Color(0XFF101021); // Green if active, Dark Grey if not
    final iconColor = Colors.white; // Always white as requested

    return Column(
      children: [
        // Top Indicator Bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 60.w,
          height: 4.h,
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        // Icon Circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          child: Icon(icon, color: iconColor, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        // Label
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}

class CheckInCard extends StatelessWidget {
  final String title;
  final String? value;
  final String? subValue;
  final IconData? icon;
  final bool showBadge;

  const CheckInCard({
    super.key,
    required this.title,
    this.value,
    this.subValue,
    this.icon,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF101021), // Dark card background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Row(
              children: [
                Icon(icon, color: const Color(0xFF82C941), size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (value != null) ...[
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      value!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ] else ...[
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showBadge)
                  Builder(
                    builder: (context) {
                      final localizations = AppLocalizations.of(context)!;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF82C941).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: const Color(0xFF82C941),
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              localizations.checkInSinceLastBadge,
                              style: TextStyle(
                                color: const Color(0xFF82C941),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class InstructionText extends StatelessWidget {
  final IconData icon;
  final String text;

  const InstructionText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class FileUploadWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final List<String> selectedPaths;
  final Function(String) onRemove;

  const FileUploadWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.selectedPaths = const [],
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFF446B36), // Muted green background
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF82C941), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: Colors.white, size: 32.sp),
                SizedBox(height: 8.h),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedPaths.isNotEmpty) ...[
          SizedBox(height: 16.h),
          SizedBox(
            height: 80.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedPaths.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return FilePreviewWidget(
                  path: selectedPaths[index],
                  onRemove: () => onRemove(selectedPaths[index]),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class FilePreviewWidget extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const FilePreviewWidget({
    super.key,
    required this.path,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 14.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class VideoUploadWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String? selectedPath;
  final VoidCallback onRemove;

  const VideoUploadWidget({
    super.key,
    required this.label,
    required this.onTap,
    this.selectedPath,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: Colors.white70,
              strokeWidth: 1,
              dashWidth: 8,
              dashSpace: 4,
              radius: 20.r,
            ),
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: const Color(0xFF446B36).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selectedPath != null) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.videocam_outlined,
                  color: Colors.white70,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    selectedPath!.split('/').last,
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashSpace;
  final double dashWidth;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1,
    this.dashSpace = 4,
    this.dashWidth = 8,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);

    // Draw dashed path
    final Path dashPath = Path();
    for (final PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
