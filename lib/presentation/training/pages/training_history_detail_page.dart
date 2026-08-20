import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingHistoryDetailPage extends StatelessWidget {
  final TrainingHistoryEntity historyItem;

  const TrainingHistoryDetailPage({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Group sets by exercise name
    final Map<String, List<PushDataEntity>> exercises = {};
    for (var set in historyItem.pushData) {
      if (!exercises.containsKey(set.exerciseName)) {
        exercises[set.exerciseName] = [];
      }
      exercises[set.exerciseName]!.add(set);
    }

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          historyItem.trainingName,
          style: AppTextStyle.appbarHeading.copyWith(fontSize: 16.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              '${historyItem.dateTime.day}/${historyItem.dateTime.month}/${historyItem.dateTime.year} ${localizations.atLabel} ${historyItem.time.hour}:${historyItem.time.minute}',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            // Notes
            if (historyItem.note.isNotEmpty)
              Text(
                historyItem.note,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),

            SizedBox(height: 20.h),

            // Detail Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercises.entries.map((entry) {
                  final exerciseName = entry.key;
                  final sets = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                exerciseName,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                        ),
                        if (sets.isNotEmpty &&
                            sets.first.exerciseNotes != null &&
                            sets.first.exerciseNotes!.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            '${localizations.noteLabel}: ${sets.first.exerciseNotes}',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        SizedBox(height: 12.h),
                        // Sets Rows
                        ...sets.map((set) {
                          final reps = num.tryParse(set.repRange) ?? 0;
                          final totalSetWeight = set.weight * reps;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${set.weight} kg x ${set.repRange} (Total: $totalSetWeight)',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
