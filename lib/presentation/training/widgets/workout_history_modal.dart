import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/presentation/training/controllers/previous_workout_modal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutHistoryModal extends StatelessWidget {
  final String planTitle;

  const WorkoutHistoryModal({super.key, required this.planTitle});

  @override
  Widget build(BuildContext context) {
    // Inject the controller with the planTitle tag
    final controller = Get.put(
      PreviousWorkoutModalController(planTitle: planTitle),
      tag: planTitle,
    );
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.previousWorkoutTitle,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Flexible(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                );
              }

              final workoutsList = controller.workouts;
              if (workoutsList.isEmpty) {
                return Center(
                  child: Text(
                    localizations.noPreviousWorkoutRecords,
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: workoutsList.map((workout) {
                    // Group sets by exercise
                    final Map<String, List<PushDataEntity>> exercises = {};
                    for (var set in workout.pushData) {
                      if (!exercises.containsKey(set.exerciseName)) {
                        exercises[set.exerciseName] = [];
                      }
                      exercises[set.exerciseName]!.add(set);
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date & Time
                          Text(
                            '${workout.dateTime.day.toString().padLeft(2, '0')}/${workout.dateTime.month.toString().padLeft(2, '0')}/${workout.dateTime.year} ${localizations.atLabel} ${workout.time.hour}:${workout.time.minute}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (workout.note.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Text(
                              workout.note,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                          SizedBox(height: 16.h),

                          // Exercise List
                          ...exercises.entries.map((entry) {
                            final name = entry.key;
                            final sets = entry.value;

                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131F),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: const Color(0xFF2E2E5D)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (sets.isNotEmpty && sets.first.exerciseNotes != null && sets.first.exerciseNotes!.isNotEmpty) ...[
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
                                  SizedBox(height: 8.h),
                                  // Set breakdown
                                  ...sets.map((s) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${localizations.setLabel} ${s.sets}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                          Text(
                                            '${s.weight} kg x ${s.repRange} (RIR: ${s.rir})',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }),
                          Divider(color: Colors.white24, height: 16.h),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
