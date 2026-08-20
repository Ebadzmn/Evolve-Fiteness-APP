import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan_detail/training_plan_detail_cubit.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan_detail/training_plan_detail_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingPlanDetailPage extends StatelessWidget {
  final String planId;

  const TrainingPlanDetailPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => TrainingPlanDetailCubit(
        getTrainingPlanById: sl<GetTrainingPlanByIdUseCase>(),
      )..loadTrainingPlanDetail(planId),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          title: Text(
            localizations.trainingPlanAppBarTitle,
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
        body: BlocBuilder<TrainingPlanDetailCubit, TrainingPlanDetailState>(
          builder: (context, state) {
            if (state is TrainingPlanDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TrainingPlanDetailError) {
              return Center(
                child: Text(
                  '${localizations.dailyTrackingError}: ${state.message}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is TrainingPlanDetailLoaded) {
              return _PlanDetailContent(plan: state.plan);
            }
            // Initial state or fallback
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _PlanDetailContent extends StatelessWidget {
  final TrainingPlanEntity plan;

  const _PlanDetailContent({required this.plan});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final exercises = plan.exercises;
    final exerciseCount = exercises.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        children: [
          _PlanHeaderCard(plan: plan, exerciseCount: exerciseCount),
          SizedBox(height: 16.h),
          Expanded(
            child: exerciseCount == 0
                ? Center(
                    child: Text(
                      localizations.noExercisesFound,
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: exerciseCount,
                    padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _ExerciseCard(index: index, exercise: exercise);
                    },
                  ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.WorkoutSessionPage, extra: plan.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F123B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: const Color(0xFF2E2E8D)),
                ),
              ),
              child: Text(
                localizations.startWorkout,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _PlanHeaderCard extends StatelessWidget {
  final TrainingPlanEntity plan;
  final int exerciseCount;

  const _PlanHeaderCard({required this.plan, required this.exerciseCount});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final difficulty = (plan.difficulty ?? '').trim();
    final subtitle = plan.subtitle.trim();
    final comment = (plan.comment ?? '').trim();

    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          if (difficulty.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2538),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                difficulty,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (difficulty.isNotEmpty) SizedBox(height: 12.h),
          if (subtitle.isNotEmpty && comment.isEmpty) ...[
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          if (comment.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2538),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: const Color(0xFF4CAF50),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.coachComment,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          comment,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            localizations.exercisesCount(exerciseCount),
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final TrainingPlanExerciseEntity exercise;
  final int index;

  const _ExerciseCard({required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final setsDetail = exercise.exerciseSets;
    final subtitleText = (exercise.comment ?? '').trim().isNotEmpty
        ? exercise.comment!.trim()
        : (exercise.muscle ?? '').trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            leading: CircleAvatar(
              radius: 16.r,
              backgroundColor: const Color(0xFFEFA9A9),
              child: Text(
                exercise.name.isNotEmpty
                    ? exercise.name.substring(0, 1).toUpperCase()
                    : '?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              exercise.name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: subtitleText.isNotEmpty
                ? Text(
                    subtitleText,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  )
                : null,
            childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 40.w,
                    child: Text(
                      localizations.setLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      localizations.repsLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 40.w,
                    child: Text(
                      localizations.rirLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (setsDetail.isEmpty)
                Text(
                  localizations.noSetsDefined,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12.sp,
                  ),
                )
              else
                Column(
                  children: List.generate(setsDetail.length, (index) {
                    final setGroup = setsDetail[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              setGroup.sets.isNotEmpty
                                  ? setGroup.sets
                                  : '${index + 1}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              setGroup.repRange.isNotEmpty
                                  ? setGroup.repRange
                                  : '-',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 40.w,
                            child: Text(
                              setGroup.rir.isNotEmpty ? setGroup.rir : '-',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
