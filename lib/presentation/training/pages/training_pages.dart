import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/training/data/repositories/fake_training_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_initial_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_bloc/training_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_bloc/training_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_bloc/training_state.dart';
import 'package:fitness_app/core/bloc/nav_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TrainingPages extends StatelessWidget {
  const TrainingPages({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeTrainingRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeTrainingRepository>(ctx);
          return BlocProvider(
            create: (_) =>
                TrainingBloc(getInitial: GetTrainingInitialUseCase(repo))
                  ..add(const TrainingInitRequested()),
            child: const _TrainingView(),
          );
        },
      ),
    );
  }
}

class _TrainingView extends StatelessWidget {
  const _TrainingView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.read<NavBloc>().add(const NavEvent(0));
              },
            ),
          ),
        ),
        title: Text(
          localizations.trainingAppBarTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TrainingBloc, TrainingState>(
        builder: (context, state) {
          if (state.status == TrainingStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = state.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: _statCard(
                //         icon: Icons.emoji_events_outlined,
                //         iconColor: const Color(0xFFFFC107),
                //         title: '${data.prsThisWeek}',
                //         subtitle: localizations.trainingStatsPrsThisWeek,
                //         borderColor: const Color(0xFF936E19),
                //       ),
                //     ),
                //     SizedBox(width: 12.w),
                //     Expanded(
                //       child: _statCard(
                //         icon: Icons.fitness_center_outlined,
                //         iconColor: Colors.blueGrey.shade200,
                //         title: '${data.weeklyVolumeKg} kg',
                //         subtitle: localizations.trainingStatsWeeklyVolume,
                //         borderColor: const Color(0xFF09579A),
                //       ),
                //     ),
                //     SizedBox(width: 12.w),
                //     Expanded(
                //       child: _statCard(
                //         icon: Icons.local_fire_department_outlined,
                //         iconColor: const Color(0xFFFF6D00),
                //         title: '${data.trainingsCount}',
                //         subtitle: localizations.trainingStatsTrainings,
                //         borderColor: const Color(0xFF936E19),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.library_books_outlined,
                        iconColor: const Color(0xFF82C941),
                        title: localizations.trainingMenuExercisesTitle,
                        subtitle: localizations.trainingMenuExercisesSubtitle,
                        onTap: () => context.push(AppRoutes.exercisesPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.calendar_month_outlined,
                        iconColor: const Color(0xFF4A6CF7),
                        title: localizations.trainingMenuPlanTitle,
                        subtitle: localizations.trainingMenuPlanSubtitle,
                        onTap: () => context.push(AppRoutes.trainingPlanPage),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.history,
                        iconColor: const Color(0xFFFF6D00),
                        title: localizations.trainingMenuHistoryTitle,
                        subtitle: localizations.trainingMenuHistorySubtitle,
                        onTap: () =>
                            context.push(AppRoutes.trainingHistoryPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.view_agenda_outlined,
                        iconColor: const Color(0xFFFF6D00),
                        title: localizations.trainingMenuSplitTitle,
                        subtitle: localizations.trainingMenuSplitSubtitle,
                        onTap: () => context.push(AppRoutes.trainingSplitPage),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 110.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1b1b),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor), // ⬅️ এখানে আলাদা রঙ
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.sp),
          ),

          SizedBox(height: 8.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 140.h),
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
