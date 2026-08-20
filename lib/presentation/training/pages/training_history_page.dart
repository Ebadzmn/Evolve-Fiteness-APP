import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_history/training_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/injection_container.dart' as di;

class TrainingHistoryPage extends StatelessWidget {
  const TrainingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TrainingHistoryBloc(getHistory: di.sl<GetTrainingHistoryUseCase>())
            ..add(const TrainingHistoryLoadRequested()),
      child: const _TrainingHistoryView(),
    );
  }
}

class _TrainingHistoryView extends StatelessWidget {
  const _TrainingHistoryView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.trainingHistoryAppBarTitle,
          style: AppTextStyle.appbarHeading,
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
      body: BlocBuilder<TrainingHistoryBloc, TrainingHistoryState>(
        builder: (context, state) {
          if (state.status == TrainingHistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TrainingHistoryStatus.failure) {
            return Center(
              child: Text(
                '${localizations.dailyTrackingError}: ${state.errorMessage}',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }
          if (state.history.isEmpty) {
            return Center(
              child: Text(
                localizations.trainingHistoryEmpty,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.history.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return _HistoryCard(item: state.history[index]);
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final TrainingHistoryEntity item;

  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Group sets by exercise name and calculate total weight
    final Map<String, List<PushDataEntity>> exercises = {};
    num calculatedTotalWeight = 0;
    for (var set in item.pushData) {
      final reps = num.tryParse(set.repRange) ?? 0;
      calculatedTotalWeight += (set.weight * reps);
      if (!exercises.containsKey(set.exerciseName)) {
        exercises[set.exerciseName] = [];
      }
      exercises[set.exerciseName]!.add(set);
    }
    final topExercises = exercises.keys.take(3).toList();

    return InkWell(
      onTap: () =>
          context.push(AppRoutes.trainingHistoryDetailPage, extra: item),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Month | Workouts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatMonthOnly(item.dateTime),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // "9 Workouts" - logic would go here ideally
                Text(
                  localizations.oneWorkout,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Workout Title
            Text(
              item.trainingName,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            // Full Date
            Text(
              _formatFullDate(item.dateTime, localizations.atLabel),
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),

            // Sets Label
            Text(
              localizations.setsBestSetLabel,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 8.h),

            // Exercises List with Best Set logic
            ...topExercises.map((name) {
              final sets = exercises[name]!;
              var bestSet = sets.first;
              for (var s in sets) {
                if (s.weight > bestSet.weight) {
                  bestSet = s;
                }
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  '${sets.length} × $name → ${localizations.bestSetPrefix}: ${bestSet.weight} kg × ${bestSet.repRange} @ RIR ${bestSet.rir}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
                ),
              );
            }),

            SizedBox(height: 16.h),

            // Stats Row
            Row(
              children: [
                _statItem(
                  Icons.access_time_filled,
                  '${item.time.hour} h ${item.time.minute} m',
                ),
                SizedBox(width: 20.w),
                _statItem(
                  Icons.monitor_weight_outlined,
                  '${calculatedTotalWeight % 1 == 0 ? calculatedTotalWeight.toInt() : calculatedTotalWeight.toStringAsFixed(1)} (kg)',
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.white70, size: 18.sp),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
        ),
      ],
    );
  }

  String _formatMonthOnly(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[date.month - 1];
  }

  String _formatFullDate(DateTime date, String atLabel) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$weekday, $day $month $year $atLabel $hour:$minute';
  }
}
