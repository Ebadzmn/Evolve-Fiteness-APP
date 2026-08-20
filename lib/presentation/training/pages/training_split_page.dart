import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_spilt2/training_split_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_spilt2/training_split_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_spilt2/training_split_state.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../injection_container.dart';

class TrainingSplitPage extends StatelessWidget {
  const TrainingSplitPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TrainingSplitBloc>()..add(const TrainingSplitInitRequested()),
      child: const _TrainingSplitView(),
    );
  }
}

class _TrainingSplitView extends StatelessWidget {
  const _TrainingSplitView();
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
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          localizations.trainingSplitAppBarTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TrainingSplitBloc, TrainingSplitState>(
        builder: (context, state) {
          if (state.status == TrainingSplitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return Center(
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
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: _splitTable(context, state.items),
          );
        },
      ),
    );
  }

  Widget _splitTable(BuildContext context, List items) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E2E5D)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.sp),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      localizations.trainingSplitHeaderDay,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      localizations.trainingSplitHeaderWork,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF2E2E5D), height: 1),
            for (final row in items) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.dayLabel,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.work,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF2E2E5D), height: 1),
            ],
          ],
        ),
      ),
    );
  }
}
