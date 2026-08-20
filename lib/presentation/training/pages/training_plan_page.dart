import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plans_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_plan/training_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TrainingPlanPage extends StatelessWidget {
  const TrainingPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrainingPlanBloc(
        getTrainingPlans: sl<GetTrainingPlansUseCase>(),
        getTrainingHistory: sl<GetTrainingHistoryUseCase>(),
      )..add(const TrainingPlanLoadRequested()),
      child: const _TrainingPlanView(),
    );
  }
}

class _TrainingPlanView extends StatelessWidget {
  const _TrainingPlanView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
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
      body: BlocBuilder<TrainingPlanBloc, TrainingPlanState>(
        builder: (context, state) {
          if (state.status == TrainingPlanStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TrainingPlanStatus.failure) {
            return Center(
              child: Text(
                '${localizations.dailyTrackingError}: ${state.errorMessage}',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }

          if (state.plans.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TrainingPlanBloc>()
                    .add(const TrainingPlanLoadRequested());
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200.h),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        localizations.coachAddedShortly,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<TrainingPlanBloc>()
                  .add(const TrainingPlanLoadRequested());
            },
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.9,
              ),
              itemCount: state.plans.length,
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                final lastWorkoutDate =
                    state.lastWorkoutDates[plan.title.trim().toLowerCase()];
                return _TrainingPlanCard(
                  plan: plan,
                  lastWorkoutDate: lastWorkoutDate,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TrainingPlanCard extends StatelessWidget {
  final TrainingPlanEntity plan;
  final DateTime? lastWorkoutDate;

  const _TrainingPlanCard({
    required this.plan,
    this.lastWorkoutDate,
  });

  List<Color> _getGradientColors(int hash) {
    final gradients = [
      [const Color(0xFF1E3C72), const Color(0xFF2A5298)], // Deep Royal Blue
      [const Color(0xFF134E5E), const Color(0xFF71B280)], // Emerald Teal
      [const Color(0xFF4568DC), const Color(0xFFB06AB3)], // Neon Violet
      [const Color(0xFF2C3E50), const Color(0xFF000000)], // Sleek Dark Slate
    ];
    return gradients[hash.abs() % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = plan.date;
    if (lastWorkoutDate != null) {
      displayDate = DateFormat('d MMM yyyy').format(lastWorkoutDate!);
    } else {
      try {
        if (plan.date.isNotEmpty) {
          final parsed = DateTime.parse(plan.date);
          displayDate = DateFormat('d MMM yyyy').format(parsed);
        }
      } catch (_) {
        displayDate = plan.date;
      }
    }

    final cardGradients = _getGradientColors(plan.title.hashCode);

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () {
        context.push(AppRoutes.trainingPlanDetailPage, extra: plan.id);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A2F),
              const Color(0xFF101021),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: cardGradients[0].withOpacity(0.4),
            width: 1.2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: cardGradients[0].withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Subtle decorative background circle
              Positioned(
                right: -20.w,
                top: -20.h,
                child: Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cardGradients[1].withOpacity(0.12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top header row with icon box & difficulty badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: cardGradients,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: cardGradients[0].withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fitness_center_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                        if (plan.difficulty != null &&
                            plan.difficulty!.isNotEmpty)
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: cardGradients[0].withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: cardGradients[0].withOpacity(0.4),
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                plan.difficulty!,
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Title & exercises
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          plan.subtitle.isNotEmpty
                              ? plan.subtitle
                              : AppLocalizations.of(context)!.noExercisesSubtitle,
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Footer date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: cardGradients[1].withOpacity(0.8),
                          size: 13.sp,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            displayDate,
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white30,
                          size: 11.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
