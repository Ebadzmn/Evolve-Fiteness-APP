import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/checkin_entities/old_check_in_entity.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checkIn_widgets.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checking_tab.dart';
import 'package:fitness_app/presentation/checkIn/widgets/old_checking_tab.dart';
import 'package:fitness_app/presentation/checkIn/widgets/questions_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fitness_app/core/bloc/nav_bloc.dart';

class CheckinPages extends StatelessWidget {
  const CheckinPages({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckInBloc(
        getInitial: sl(),
        saveCheckIn: sl(),
        getHistory: sl(),
        getCheckInDate: sl(),
        getCheckInUser: sl(),
        sharedPreferences: sl(),
      )..add(const CheckInInitRequested()),
      child: const _CheckInView(),
    );
  }
}

class _CheckInView extends StatelessWidget {
  const _CheckInView();

  String _localizedStatusText(AppLocalizations localizations, String status) {
    return status.toLowerCase() == 'completed'
        ? localizations.checkInStatusCompleted
        : localizations.checkInStatusPending;
  }

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
                if (Get.isRegistered<CheckInQuestionsController>()) {
                  Get.delete<CheckInQuestionsController>();
                }
                context.read<NavBloc>().add(const NavEvent(0));
              },
            ),
          ),
        ),
        title: Text(
          localizations.checkInAppBarTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (Get.isRegistered<CheckInQuestionsController>()) {
            final c = Get.find<CheckInQuestionsController>();
            c.isSubmitting.value = state.status == CheckInStatus.saving;
          }
          if (state.status == CheckInStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? localizations.commonError),
              ),
            );
          }
          if (state.status == CheckInStatus.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.checkInSubmittedSuccess)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == CheckInStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final step = state.data!.step;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CheckInBloc>().add(const CheckInRefreshRequested());

              if (Get.isRegistered<CheckInQuestionsController>()) {
                await Get.find<CheckInQuestionsController>().fetchCheckInUser();
              }

              await context.read<CheckInBloc>().stream.firstWhere(
                (state) => state.status != CheckInStatus.loading,
              );
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => context.read<CheckInBloc>().add(
                          const CheckInStepSet(0),
                        ),
                        child: CheckInStep(
                          icon: Icons.person_outline,
                          label: localizations.checkInStepProfile,
                          isActive: step == 0,
                          isCompleted: step > 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.read<CheckInBloc>().add(
                          const CheckInStepSet(1),
                        ),
                        child: CheckInStep(
                          icon: Icons.camera_alt_outlined,
                          label: localizations.checkInStepPhotos,
                          isActive: step == 1,
                          isCompleted: step > 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.read<CheckInBloc>().add(
                          const CheckInStepSet(2),
                        ),
                        child: CheckInStep(
                          icon: Icons.chat_bubble_outline,
                          label: localizations.checkInStepQuestions,
                          isActive: step == 2,
                          isCompleted: step > 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.read<CheckInBloc>().add(
                          const CheckInStepSet(3),
                        ),
                        child: CheckInStep(
                          icon: Icons.check_circle_outline,
                          label: localizations.checkInStepChecking,
                          isActive: step == 3,
                          isCompleted: step > 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Tabs: Weekly Check-In / Old Check-In
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F0F15),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: const Color(0xFF2E2E5D)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<CheckInBloc>().add(
                              const CheckInTabSet('weekly'),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: state.tab == CheckInViewTab.weekly
                                    ? const Color(0xFF446B36)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  localizations.checkInTabWeekly,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<CheckInBloc>().add(
                              const CheckInTabSet('old'),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: state.tab == CheckInViewTab.old
                                    ? const Color(0xFF446B36)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  localizations.checkInTabOld,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Old Check-In view uses API pagination, Weekly shows only date info
                  if (state.tab == CheckInViewTab.old) ...[
                    _oldCheckInView(context, state.oldCheckIn, state.skip),
                  ] else ...[
                    _checkInDateView(localizations, state),
                  ],
                  SizedBox(height: 20.h),

                  if (state.tab == CheckInViewTab.weekly)
                    _bodyForStep(context, step),

                  // Bottom Buttons
                  if (state.tab == CheckInViewTab.weekly && step == 0) ...[
                    SizedBox(height: 40.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.read<CheckInBloc>().add(
                              const CheckInNextPressed(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF446B36),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              localizations.commonNext,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (state.tab == CheckInViewTab.weekly &&
                      step == 3) ...[
                    SizedBox(height: 40.h),
                    Builder(
                      builder: (context) {
                        bool isSubmitted = state.isSubmitted;
                        final isSaving = state.status == CheckInStatus.saving;

                        bool isEnabled = !isSubmitted && !isSaving;

                        String buttonText = localizations.commonSubmit;
                        if (isSaving) {
                          buttonText = localizations.checkInSubmittingButton;
                        }
                        if (isSubmitted) {
                          buttonText =
                              localizations.checkInAlreadySubmittedButton;
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isEnabled) {
                                    if (Get.isRegistered<
                                      CheckInQuestionsController
                                    >()) {
                                      final c =
                                          Get.find<
                                            CheckInQuestionsController
                                          >();
                                      if (c.hasAnyEmptyAnswer()) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                localizations
                                                    .checkInValidationAnswerAllQuestionsBeforeSubmitting,
                                              ),
                                            ),
                                          );
                                        return;
                                      }
                                      context.read<CheckInBloc>().add(
                                        SubmitPressed(
                                          answers: c.buildAnswersPayload(),
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<CheckInBloc>().add(
                                      const SubmitPressed(
                                        answers: <Map<String, String>>[],
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            localizations
                                                .checkInAlreadySubmittedButton,
                                          ),
                                        ),
                                      );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isEnabled
                                      ? const Color(0xFF446B36)
                                      : const Color(0xFF2E2E5D),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: isEnabled
                                        ? Colors.white
                                        : Colors.white60,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ], // Close Column children
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _oldCheckInView(
    BuildContext context,
    OldCheckInEntity? data,
    int skip,
  ) {
    final localizations = AppLocalizations.of(context)!;
    if (data == null) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const Icon(Icons.history, color: Colors.white70),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                localizations.checkInNoPreviousFound,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF101021),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${localizations.checkInLabel} ${data.formattedDate}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: data.checkinCompleted.toLowerCase() == 'completed'
                      ? const Color(0xFF446B36)
                      : const Color(0xFFB87333),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _localizedStatusText(localizations, data.checkinCompleted),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Navigation buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<CheckInBloc>().add(const CheckInHistoryPrev()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C222E),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  localizations.checkInPreviousButton,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: skip > 0
                    ? () => context.read<CheckInBloc>().add(
                        const CheckInHistoryNext(),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF446B36),
                  disabledBackgroundColor: const Color(0xFF2A3A2A),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  localizations.checkInNextButton,
                  style: TextStyle(
                    color: skip > 0 ? Colors.white : Colors.white38,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Use OldCheckingTab widget with exact same design as CheckingTab
        OldCheckingTab(data: data),
      ],
    );
  }

  Widget _checkInDateView(AppLocalizations localizations, CheckInState state) {
    String formattedDate = state.checkInDate?.nextCheckInDate ?? '';
    String dayName = state.checkInDate?.checkInDay ?? '';

    if (formattedDate.isEmpty) {
      formattedDate = localizations.checkInLoadingLabel;
      dayName = localizations.checkInLoadingLabel;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B1B),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E4E2E)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${localizations.checkInDateLabel} $formattedDate',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '${localizations.checkInDayLabel} $dayName',
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyForStep(BuildContext context, int step) {
    final localizations = AppLocalizations.of(context)!;
    if (step == 0) {
      return BlocBuilder<CheckInBloc, CheckInState>(
        builder: (context, state) {
          final checkInDate = state.checkInDate;
          return Column(
            children: [
              CheckInCard(
                title: localizations.checkInProfileCurrentWeightTitle,
                value: checkInDate != null
                    ? "${checkInDate.currentWeight} (kg)"
                    : "0 (kg)",
                showBadge: true,
              ),

              CheckInCard(
                title: localizations.checkInProfileAverageWeightTitle,
                value: checkInDate != null
                    ? "${checkInDate.averageWeight} (%)"
                    : "0 (%)",
                showBadge: true,
              ),
            ],
          );
        },
      );
    } else if (step == 1) {
      final uploads = context.read<CheckInBloc>().state.data?.uploads;
      final picker = ImagePicker();

      return Column(
        children: [
          InstructionText(
            icon: Icons.description_outlined,
            text: localizations.checkInPhotosMultiFileInfo,
          ),
          SizedBox(height: 16.h),
          FileUploadWidget(
            label: localizations.checkInPhotosSelectFileLabel,
            selectedPaths: uploads?.picturePaths ?? [],
            onTap: () async {
              final List<XFile> images = await picker.pickMultiImage();
              if (images.isNotEmpty) {
                context.read<CheckInBloc>().add(
                  PhotoSelected(images.map((e) => e.path).toList()),
                );
              }
            },
            onRemove: (path) {
              context.read<CheckInBloc>().add(PhotoRemoved(path));
            },
          ),
          SizedBox(height: 24.h),
          InstructionText(
            icon: Icons.play_circle_outline,
            text: localizations.checkInPhotosSingleVideoInfo,
          ),
          SizedBox(height: 16.h),
          VideoUploadWidget(
            label: localizations.checkInPhotosVideoDropLabel,
            selectedPath: uploads?.videoPath,
            onTap: () async {
              final XFile? video = await picker.pickVideo(
                source: ImageSource.gallery,
              );
              if (video != null) {
                context.read<CheckInBloc>().add(VideoSelected(video.path));
              }
            },
            onRemove: () {
              context.read<CheckInBloc>().add(const VideoSelected(''));
            },
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<CheckInBloc>().add(const UploadButtonPressed());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizations.checkInPhotosUploadSuccess),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C222E),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                localizations.commonUpload,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CheckInBloc>().add(const CheckInStepSet(0));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C222E),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    localizations.commonBack,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CheckInBloc>().add(const CheckInStepSet(2));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E45),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    localizations.commonNext,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (step == 2) {
      return const QuestionsTab();
    } else if (step == 3) {
      return const CheckingTab();
    }
    return Container();
  }
}
