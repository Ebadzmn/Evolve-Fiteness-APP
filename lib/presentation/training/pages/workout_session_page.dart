import 'dart:async';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/presentation/training/controllers/previous_workout_modal_controller.dart';
import 'package:fitness_app/presentation/training/controllers/workout_session_controller.dart';
import 'package:fitness_app/presentation/training/widgets/workout_history_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/features/training/presentation/bloc/timer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutSessionPage extends StatelessWidget {
  final String planId;
  const WorkoutSessionPage({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(sl<WorkoutSessionController>(), tag: planId);

    // Load session if not already loaded
    if (controller.plan.value == null) {
      controller.loadWorkoutSession(planId);
    }

    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => TimerBloc(planId: planId),
      child: Scaffold(
        backgroundColor: AppColor.primaryColor,
        resizeToAvoidBottomInset: true,
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
          title: Obx(() {
            if (controller.plan.value == null) return Text(localizations.checkInLoadingLabel);
            return Column(
              children: [
                Text(
                  controller.plan.value!.title,
                  style: AppTextStyle.appbarHeading.copyWith(fontSize: 16.sp),
                ),
                Text(
                  localizations.exercisesCount(controller.sessionExercises.length),
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            );
          }),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                if (controller.plan.value == null) return;
                Get.delete<PreviousWorkoutModalController>(
                  tag: controller.plan.value!.title,
                );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  showDragHandle: true,
                  backgroundColor: const Color(0XFF101021),
                  builder: (context) => WorkoutHistoryModal(
                    planTitle: controller.plan.value!.title,
                  ),
                );
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            );
          }

          final exercises = controller.sessionExercises;
          final planComment = (controller.plan.value?.comment ?? '').trim();

          return Column(
            children: [
              _TimerSection(planId: planId),
              SizedBox(height: 10.h),
              Expanded(
                child: exercises.isEmpty
                    ? Center(
                        child: Text(
                          localizations.noExercisesInPlan,
                          style: GoogleFonts.poppins(color: Colors.white54),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        children: [
                          if (planComment.isNotEmpty) ...[
                            _CoachCommentCard(comment: planComment),
                            SizedBox(height: 12.h),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localizations.exercisesTitle,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Obx(
                                () => OutlinedButton.icon(
                                  onPressed: controller.isChangingExercise.value
                                      ? null
                                      : () => controller.changeExercise(
                                          context,
                                          () => _showExercisePicker(
                                            context,
                                            controller,
                                          ),
                                        ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF4CAF50),
                                    ),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  icon: controller.isChangingExercise.value
                                      ? SizedBox(
                                          width: 14.w,
                                          height: 14.w,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF4CAF50),
                                              ),
                                        )
                                      : const Icon(Icons.swap_horiz, size: 16),
                                  label: Text(
                                    controller.isChangingExercise.value
                                        ? localizations.checkInLoadingLabel
                                        : localizations.changeExercise,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ...List.generate(exercises.length, (index) {
                            final exercise = exercises[index];
                            return _ExerciseRow(
                              exercise: exercise,
                              index: index,
                              planId: planId,
                            );
                          }),
                          SizedBox(height: 24.h),
                          _NotesInput(
                            controller: controller.noteController,
                          ),
                          SizedBox(height: 24.h),
                          Builder(
                            builder: (innerContext) => _BottomButtons(
                              onComplete: () =>
                                  controller.onComplete(innerContext),
                              isSaving: controller.isSaving.value,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<ExerciseEntity?> _showExercisePicker(
    BuildContext context,
    WorkoutSessionController controller,
  ) {
    return showModalBottomSheet<ExerciseEntity?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0XFF101021),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (bottomSheetContext) =>
          _ExercisePickerSheet(controller: controller),
    );
  }
}

class _ExercisePickerSheet extends StatefulWidget {
  final WorkoutSessionController controller;

  const _ExercisePickerSheet({required this.controller});

  @override
  State<_ExercisePickerSheet> createState() => _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends State<_ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<ExerciseEntity> _exercises = <ExerciseEntity>[];
  ExerciseEntity? _selectedExercise;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises({String? query}) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final items = await widget.controller.searchExercises(searchTerm: query);
    if (!mounted) return;

    setState(() {
      _exercises = items;
      _selectedExercise = items.isNotEmpty ? items.first : null;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _loadExercises(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: SizedBox(
          height: 0.75.sh,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.changeExercise,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: localizations.searchExerciseHint,
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontSize: 12.sp,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4CAF50),
                      ),
                    )
                  : _exercises.isEmpty
                  ? Center(
                      child: Text(
                        localizations.noExerciseFound,
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 13.sp,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _exercises.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.white12, height: 1.h),
                      itemBuilder: (context, index) {
                        final item = _exercises[index];
                        final isSelected = item.id == _selectedExercise?.id;

                        return ListTile(
                          onTap: () {
                            setState(() {
                              _selectedExercise = item;
                            });
                          },
                          title: Text(
                            item.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                          subtitle: Text(
                            item.category,
                            style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 11.sp,
                            ),
                          ),
                          trailing: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? const Color(0xFF4CAF50)
                                : Colors.white38,
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedExercise == null
                    ? null
                    : () => Navigator.of(context).pop(_selectedExercise),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  disabledBackgroundColor: Colors.white24,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  localizations.changeExercise,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class _CoachCommentCard extends StatelessWidget {
  final String comment;

  const _CoachCommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: const Color(0xFF4CAF50),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.coachComment,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            comment,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerSection extends StatelessWidget {
  final String planId;
  const _TimerSection({required this.planId});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final controller = Get.find<WorkoutSessionController>(tag: planId);
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final d = state.duration;
        final hours = (d ~/ 3600).toString().padLeft(2, '0');
        final minutes = ((d % 3600) ~/ 60).toString().padLeft(2, '0');
        final seconds = (d % 60).toString().padLeft(2, '0');
        final isRunning = state.isRunning;

        // Sync back to controller for submission
        controller.duration.value = d;
        controller.isTimerRunning.value = isRunning;

        return Column(
          children: [
            Text(
              isRunning ? localizations.timerRunning : localizations.timerStart,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF2E2E5D)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _timerItem(hours, localizations.timerHours),
                  _divider(),
                  _timerItem(minutes, localizations.timerMinutes),
                  _divider(),
                  _timerItem(seconds, localizations.timerSeconds),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (isRunning) {
                      context.read<TimerBloc>().add(PauseTimer());
                    } else {
                      context.read<TimerBloc>().add(StartTimer());
                    }
                  },
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2E5B24),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      color: const Color(0xFF2E5B24),
                      size: 32.sp,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () {
                    context.read<TimerBloc>().add(ResetTimer());
                  },
                  borderRadius: BorderRadius.circular(30.r),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.5),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.red.withValues(alpha: 0.8),
                      size: 32.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _timerItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Text(
      ':',
      style: GoogleFonts.poppins(
        color: Colors.white38,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  final TrainingPlanExerciseEntity exercise;
  final int index;
  final String planId;

  const _ExerciseRow({
    required this.exercise,
    required this.index,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final controller = Get.find<WorkoutSessionController>(tag: planId);
    final noteController = controller.exerciseNoteControllers[index];

    return Obx(() {
      final isCompleted = controller.completedExercises[index] ?? false;

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF4CAF50)
                : const Color(0xFF2E2E5D),
            width: isCompleted ? 1.5.w : 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.goToExerciseDetails(
                      exercise.exerciseId,
                      context,
                    ),
                    child: Text(
                      exercise.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  localizations.setsCount(int.tryParse(exercise.sets) ?? 0),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        child: Text(
                          localizations.setsLabel,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          localizations.weightLabel,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10.sp,
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
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          localizations.rirLabel,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () => controller.toggleExerciseCompletion(index),
                        child: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: isCompleted
                              ? const Color(0xFF4CAF50)
                              : Colors.white24,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Column(
                    children: List.generate(
                      controller.exerciseControllers[index]?.length ?? 0,
                      (sIndex) {
                        final setControllers =
                            controller.exerciseControllers[index]![sIndex];
                        final setsDetail =
                            (exercise.exerciseSets as List?) ?? const [];
                        final setModel = setsDetail.length > sIndex
                            ? setsDetail[sIndex]
                            : null;
                        final setLabel = setModel != null
                            ? setModel.sets.toString()
                            : '${sIndex + 1}';
                        final repsHint = setModel != null
                            ? setModel.repRange.toString()
                            : (exercise.range ?? '');
                        final rirHint = setModel != null
                            ? setModel.rir.toString()
                            : (exercise.rir ?? '');

                        final errorMap = controller.fieldErrors[index]![sIndex];

                        final lastWeight = controller.getLastValue(
                          exercise.name,
                          sIndex,
                          'weight',
                        );
                        final lastReps = controller.getLastValue(
                          exercise.name,
                          sIndex,
                          'reps',
                        );
                        final lastRir = controller.getLastValue(
                          exercise.name,
                          sIndex,
                          'rir',
                        );

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40.w,
                                child: Text(
                                  setLabel,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['weight'],
                                hintText: lastWeight.isNotEmpty
                                    ? lastWeight
                                    : '',
                                isError: errorMap['weight']!.value,
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['reps'],
                                hintText: lastReps.isNotEmpty
                                    ? lastReps
                                    : repsHint,
                                isError: errorMap['reps']!.value,
                              ),
                              SizedBox(width: 8.w),
                              _inputBox(
                                setControllers['rir'],
                                hintText: lastRir.isNotEmpty
                                    ? lastRir
                                    : rirHint,
                                isError: errorMap['rir']!.value,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _ExerciseNotesInput(
                    controller: noteController,
                    exerciseName: exercise.name,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _inputBox(
    TextEditingController? controller, {
    String hintText = '',
    bool isError = false,
  }) {
    return Expanded(
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isError ? Colors.red : const Color(0xFF2E2E5D),
          ),
        ),
        child: TextFormField(
          controller: controller,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 10.sp,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}

class _ExerciseNotesInput extends StatelessWidget {
  final TextEditingController? controller;
  final String exerciseName;

  const _ExerciseNotesInput({
    required this.controller,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const SizedBox.shrink();
    }
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.exerciseNotesTitle,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF2E2E5D)),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
            minLines: 2,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: localizations.exerciseNotesHint(exerciseName),
              hintStyle: GoogleFonts.poppins(
                color: Colors.white30,
                fontSize: 12.sp,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotesInput extends StatelessWidget {
  final TextEditingController controller;
  const _NotesInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.workoutNotesTitle,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF2E2E5D)),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: localizations.workoutNotesHint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.white30,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final VoidCallback onComplete;
  final bool isSaving;
  const _BottomButtons({required this.onComplete, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Color(0xFF2E2E5D)),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              localizations.buttonBack,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: isSaving ? null : onComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    localizations.buttonComplete,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
