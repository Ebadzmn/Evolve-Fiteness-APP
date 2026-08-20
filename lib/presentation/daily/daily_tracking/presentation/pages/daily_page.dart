import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitness_app/core/config/assets_path.dart';
import 'package:fitness_app/core/coreWidget/dropdown_yes_no_tile.dart';
import 'package:fitness_app/core/coreWidget/dropdown_tile.dart';
import 'package:fitness_app/core/storage/token_storage.dart';
import 'package:fitness_app/injection_container.dart' as di;
import 'controller/daily_tracking_controller.dart';
import 'package:fitness_app/core/constants/daily_tracking_constants.dart';
import 'package:fitness_app/presentation/daily/controllers/daily_nutrition_controller.dart';
import 'package:intl/intl.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => di.sl<DailyTrackingController>());
    return const _DailyView();
  }
}

class _DailyView extends GetView<DailyTrackingController> {
  const _DailyView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(localizations.dailyTrackingAppBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                final initial = _parseDateLabel(
                  controller.data.value?.vital.dateLabel,
                );
                final selected = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    final theme = Theme.of(context);
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFF82C941),
                          onPrimary: Colors.black,
                          surface: Color(0xFF0F0F15),
                          onSurface: Colors.white,
                        ),
                        dialogTheme: const DialogThemeData(
                          backgroundColor: Color(0xFF0F0F15),
                        ),
                      ),
                      child: child ?? const SizedBox.shrink(),
                    );
                  },
                );
                if (selected == null) return;
                controller.onDateChanged(selected);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF0F0F15),
                child: SvgPicture.asset(AssetsPath.AbCalender),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.status.value == DailyStatus.loading ||
            controller.data.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = controller.data.value!;
        final tokenStorage = di.sl<TokenStorage>();
        final gender = (tokenStorage.getUserGender() ?? '')
            .trim()
            .toLowerCase();
        final status = (tokenStorage.getUserStatus() ?? '')
            .trim()
            .toLowerCase();
        return Padding(
          padding: EdgeInsets.all(10.h),
          child: KeyedSubtree(
            key: ValueKey(data.vital.dateLabel),
            child: SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: controller.isReadOnly.value,
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    _dateTodayHeader(
                      context,
                      data.vital.dateLabel,
                      controller.isReadOnly.value,
                    ),
                    SizedBox(height: 12.h),
                    _weightCard(context, data.vital.weightText),
                    SizedBox(height: 12.h),
                    _sleepCard(
                      context,
                      data.sleep.durationText,
                      data.sleep.quality,
                    ),
                    SizedBox(height: 12.h),
                    _sickCard(context, data.isSick),
                    SizedBox(height: 12.h),
                    _waterCard(context, data.vital.waterText),
                    SizedBox(height: 12.h),
                    _bloodPressureCard(context, data),
                    SizedBox(height: 12.h),
                    _energyWellBeingCard(context, data),
                    SizedBox(height: 12.h),
                    _trainingCard(context, data),
                    SizedBox(height: 12.h),
                    _activityTimeCard(context, data.vital.activityStepCount),
                    SizedBox(height: 20.h),
                    _nutritionCard(context, data),
                    SizedBox(height: 12.h),
                    if (gender == 'female' || gender == 'f') ...[
                      _womenCard(context, data),
                      SizedBox(height: 12.h),
                    ],
                    if (status != 'natural') ...[
                      _pedCard(context, data),
                      SizedBox(height: 12.h),
                    ],
                    _dailyNotesCard(context, data.notes),
                    SizedBox(height: 16.h),
                    _submitButton(context, controller.isUpdate.value),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  DateTime _parseDateLabel(String? label) {
    if (label == null || label.trim().isEmpty) return DateTime.now();
    final parts = label.split('.');
    if (parts.length != 3) return DateTime.now();
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return DateTime.now();
    return DateTime(y, m, d);
  }

  String? _relativeDateChipLabel(
    BuildContext context,
    String dateLabel,
    bool isReadOnly,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final selected = _parseDateLabel(dateLabel);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selected.year, selected.month, selected.day);
    final diff = selectedDay.difference(today).inDays;

    // Current date selected -> always show "Today"
    if (diff == 0) {
      return localizations.dailyDateToday;
    }

    // Non-today date with no data loaded -> show "no tracking" message
    if (!isReadOnly) {
      return localizations.dailyTrackingNoDataForDate;
    }

    if (diff == -1) {
      return 'Yesterday';
    }
    if (diff == 1) {
      return 'Tomorrow';
    }
    if (diff < 0 && diff >= -6) {
      return DateFormat('EEEE').format(selectedDay);
    }
    if (diff > 0 && diff <= 6) {
      return DateFormat('EEEE').format(selectedDay);
    }
    return null;
  }

  Widget _pillValue(int v) {
    return Container(
      height: 20.h,
      width: 30.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.green, width: 1.w),
      ),
      child: Center(
        child: Text(
          '$v',
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _dateTodayHeader(
    BuildContext context,
    String dateLabel,
    bool isReadOnly,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final chipLabel = _relativeDateChipLabel(context, dateLabel, isReadOnly);
    return Container(
      constraints: BoxConstraints(minHeight: 60.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.dailyDateLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('dd MMMM yyyy').format(_parseDateLabel(dateLabel)),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (chipLabel != null)
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(89, 76, 154, 79),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white, width: 1.w),
                  ),
                  child: Text(
                    chipLabel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _weightCard(BuildContext context, String initial) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minHeight: 110.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.weight),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyWeightLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: initial,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: localizations.dailyWeightHint,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => controller.onVitalTextChanged('weightText', v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sleepCard(BuildContext context, String durationText, double quality) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minHeight: 170.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.sleep),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailySleepLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: durationText,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: localizations.dailySleepDurationHint,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => controller.onSleepDurationChanged(v),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  localizations.dailySleepQualityLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _pillValue(quality.round()),
              ],
            ),
            FullWidthSlider(
              value: quality,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onSleepQualityChanged(v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sickCard(BuildContext context, bool? isSick) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minHeight: 120.h),
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.sick),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailySickLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _circleOption(
              context,
              localizations.commonYes,
              isSick == true,
              () => controller.onSickChanged(true),
            ),
            SizedBox(height: 12.h),
            _circleOption(
              context,
              localizations.commonNo,
              isSick == false,
              () => controller.onSickChanged(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleOption(
    BuildContext context,
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    final Color fillColor = selected ? Colors.green : Colors.grey;
    final Color borderColor = selected ? Colors.white : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: Border.all(color: borderColor, width: 2.w),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _waterCard(BuildContext context, String initial) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minHeight: 120.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.water),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyWaterLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: initial,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: localizations.dailyWaterHint,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => controller.onVitalTextChanged('waterText', v),
            ),
            SizedBox(height: 6.h),
            Text(
              localizations.dailyWaterAdvice,
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _energyWellBeingCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyEnergySectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyEnergyLevelLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.energy.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.energy,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWellBeingChanged('energy', v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyStressLevelLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.stress.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.stress,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWellBeingChanged('stress', v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyMuscleSorenessLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.muscleSoreness.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.muscleSoreness,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) =>
                  controller.onWellBeingChanged('muscleSoreness', v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyMoodLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.mood.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.mood,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWellBeingChanged('mood', v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyMotivationLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.motivation.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.motivation,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWellBeingChanged('motivation', v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.dailyBodyTempLabel,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              initialValue: data.vital.bodyTempText,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: localizations.dailyGenericTypeHint,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) =>
                  controller.onVitalTextChanged('bodyTempText', v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trainingCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    final trainingPlans = controller.trainingPlans;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyTrainingSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: localizations.dailyTrainingCompletedTitle,
              value: data.training.trainingCompleted,
              onChanged: (v) =>
                  controller.onTrainingToggleChanged('trainingCompleted', v),
            ),
            if (data.training.trainingCompleted == true) ...[
              SizedBox(height: 12.h),
              _titledBox(localizations.dailyTrainingPlanTitle),
              SizedBox(height: 12.h),
              _trainingPlanOptions(context, data, trainingPlans),
            ],
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: localizations.dailyCardioCompletedTitle,
              value: data.training.cardioCompleted,
              onChanged: (v) =>
                  controller.onTrainingToggleChanged('cardioCompleted', v),
            ),
            if (data.training.cardioCompleted == true) ...[
              SizedBox(height: 12.h),
              _titledBox(localizations.dailyCardioTypeTitle),
              SizedBox(height: 12.h),
              _cardioOptionsRow(context, data.training.cardioType),
              SizedBox(height: 12.h),
              _durationField(context, data.training.duration),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _trainingPlanOptions(
    BuildContext context,
    DailyTrackingEntity data,
    List<TrainingPlanEntity> plans,
  ) {
    final selectedNames = data.training.plans;

    TrainingPlanEntity? selectedPlan;
    if (selectedNames.isNotEmpty) {
      for (final p in plans) {
        if (selectedNames.contains(p.title)) {
          selectedPlan = p;
          break;
        }
      }
    }

    String? formattedDate;
    if (selectedPlan != null && selectedPlan.date.isNotEmpty) {
      try {
        final parsed = DateTime.parse(selectedPlan.date);
        formattedDate = DateFormat('d MMMM yyyy').format(parsed);
      } catch (_) {
        formattedDate = null;
      }
    }

    if (plans.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.dailyTrainingNoPlan,
        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12.sp),
      );
    }

    final tiles = plans.map((plan) {
      final title = plan.title;
      final isSelected = selectedNames.contains(title);
      return Expanded(
        child: _checkboxTile(
          context,
          title,
          isSelected,
          valueToDispatch: title,
        ),
      );
    }).toList();

    final rows = <Widget>[];
    for (int i = 0; i < tiles.length; i += 2) {
      rows.add(
        Row(
          children: [
            tiles[i],
            if (i + 1 < tiles.length) ...[SizedBox(width: 12.w), tiles[i + 1]],
          ],
        ),
      );
      if (i + 2 < tiles.length) {
        rows.add(SizedBox(height: 12.h));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (formattedDate != null) ...[
          Text(
            formattedDate,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        ...rows,
      ],
    );
  }

  Widget _titledBox(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF152133),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _cardioOptionsRow(BuildContext context, String selectedType) {
    final localizations = AppLocalizations.of(context)!;
    final opts = DailyTrackingConstants.cardioTypeValues;
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: opts.map((label) {
        final isSelected = selectedType == label;
        String displayLabel;
        if (label == 'WALKING') {
          displayLabel = localizations.dailyCardioWalking;
        } else if (label == 'CYCLING') {
          displayLabel = localizations.dailyCardioCycling;
        } else if (label == 'RUNNING') {
          displayLabel = localizations.dailyCardioRunning;
        } else if (label == 'SWIMMING') {
          displayLabel = localizations.dailyCardioSwimming;
        } else if (label == 'ROWING') {
          displayLabel = localizations.dailyCardioRowing;
        } else if (label == 'HIKING') {
          displayLabel = localizations.dailyCardioHiking;
        } else if (label == 'JUMP_ROPE') {
          displayLabel = localizations.dailyCardioJumpRope;
        } else if (label == 'CROSSTRAINER') {
          displayLabel = localizations.dailyCardioCrosstrainer;
        } else if (label == 'STAIRMASTER') {
          displayLabel = localizations.dailyCardioStairmaster;
        } else if (label == 'OTHER') {
          displayLabel = localizations.dailyCardioOther;
        } else {
          displayLabel = label[0] + label.substring(1).toLowerCase();
        }
        return InkWell(
          onTap: () => controller.onTrainingCardioTypeChanged(label),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20.w,
                width: 20.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF69B427) : Colors.white,
                    width: 2.w,
                  ),
                ),
                child: isSelected
                    ? Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF69B427),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 8.w),
              Text(
                displayLabel,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _checkboxTile(
    BuildContext context,
    String label,
    bool value, {
    String? valueToDispatch,
  }) {
    final dispatchValue = valueToDispatch ?? label;
    return InkWell(
      onTap: () => controller.onTrainingPlanToggled(dispatchValue, !value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20.w,
              width: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: value ? const Color(0xFF69B427) : Colors.white54,
                  width: 1.5.w,
                ),
                color: value
                    ? const Color(0xFF69B427).withValues(alpha: 0.15)
                    : Colors.transparent,
              ),
              child: value
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: value ? const Color(0xFF69B427) : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationField(BuildContext context, String initial) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF0A0A1F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: localizations.dailyDurationHint,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
        onChanged: (v) => controller.onTrainingDurationChanged(v),
      ),
    );
  }

  Widget _activityTimeCard(BuildContext context, String initial) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      constraints: BoxConstraints(minHeight: 120.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.Clock),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyActivityStepsLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              initialValue: initial,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: localizations.dailyActivityStepsHint,
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) =>
                  controller.onVitalTextChanged('activityStepCount', v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    final dailyNutrition = Get.put(
      di.sl<DailyNutritionController>(),
      tag: 'dailyNutrition',
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyNutritionSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Obx(
              () => _NutritionPlanDropdown(
                selectedPlan: dailyNutrition.selectedPlan.value,
                plans: dailyNutrition.plans,
                onChanged: (val) {
                  dailyNutrition.onPlanChanged(val);
                  controller.onNutritionTextChanged(
                    'caloriesText',
                    dailyNutrition.calories.value.toString(),
                  );
                  controller.onNutritionTextChanged(
                    'carbsText',
                    dailyNutrition.carbs.value.toStringAsFixed(1),
                  );
                  controller.onNutritionTextChanged(
                    'proteinText',
                    dailyNutrition.protein.value.toStringAsFixed(1),
                  );
                  controller.onNutritionTextChanged(
                    'fatsText',
                    dailyNutrition.fats.value.toStringAsFixed(1),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.dailyNutritionCaloriesLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        data.nutrition.caloriesText,
                        localizations.dailyGenericTypeHint,
                        (v) => controller.onNutritionTextChanged(
                          'caloriesText',
                          v,
                        ),
                        key: ValueKey(
                          'cal_${dailyNutrition.selectedPlan.value}',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.dailyNutritionCarbsLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        data.nutrition.carbsText,
                        localizations.dailyGenericTypeHint,
                        (v) =>
                            controller.onNutritionTextChanged('carbsText', v),
                        key: ValueKey(
                          'carbs_${dailyNutrition.selectedPlan.value}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.dailyNutritionProteinLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        data.nutrition.proteinText,
                        localizations.dailyGenericTypeHint,
                        (v) =>
                            controller.onNutritionTextChanged('proteinText', v),
                        key: ValueKey(
                          'prot_${dailyNutrition.selectedPlan.value}',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.dailyNutritionFatsLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        data.nutrition.fatsText,
                        localizations.dailyGenericTypeHint,
                        (v) => controller.onNutritionTextChanged('fatsText', v),
                        key: ValueKey(
                          'fats_${dailyNutrition.selectedPlan.value}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyNutritionHungerLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.nutrition.hunger.round()),
              ],
            ),
            FullWidthSlider(
              value: data.nutrition.hunger,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) =>
                  controller.onNutritionChanged('hunger', numberValue: v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyNutritionDigestionLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.nutrition.digestion.round()),
              ],
            ),
            FullWidthSlider(
              value: data.nutrition.digestion,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) =>
                  controller.onNutritionChanged('digestion', numberValue: v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.dailyNutritionSaltLabel,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _filledInput(
              data.nutrition.saltText,
              localizations.dailyGenericTypeHint,
              (v) => controller.onNutritionTextChanged('saltText', v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filledInput(
    String initialValue,
    String hint,
    ValueChanged<String> onChanged, {
    Key? key,
  }) {
    return TextFormField(
      key: key,
      initialValue: initialValue,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }

  Widget _labeledField(
    String label,
    String initialValue,
    ValueChanged<String> onChanged, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        _filledInput(initialValue, hint ?? 'Type..', onChanged),
      ],
    );
  }

  Widget _womenCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.woman_2_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyWomenSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownTile(
              title: localizations.dailyWomenCyclePhaseTitle,
              value: data.women.cyclePhase,
              options: DailyTrackingConstants.cyclePhaseValues,
              onChanged: (v) => controller.onWomenCyclePhaseChanged(v),
            ),
            SizedBox(height: 12.h),
            _labeledField(
              localizations.dailyWomenCycleDayTitle,
              data.women.cycleDayLabel,
              (v) => controller.onWomenCycleDayChanged(v),
              hint: localizations.dailyGenericTypeHint,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyWomenPmsLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.women.pms.round()),
              ],
            ),
            FullWidthSlider(
              value: data.women.pms,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWomenPmsChanged(v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    localizations.dailyWomenCrampsLabel,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.women.cramps.round()),
              ],
            ),
            FullWidthSlider(
              value: data.women.cramps,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (v) => controller.onWomenCrampsChanged(v),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
            ),
            SizedBox(height: 12.h),
            DropdownMultiSelectTile(
              title: localizations.dailyWomenSymptomsTitle,
              selected: data.women.symptoms,
              options: DailyTrackingConstants.womenSymptomsValues,
              onChanged: (s) => controller.onWomenSymptomsChanged(s),
              hint: localizations.dailyWomenSelectSymptoms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pedCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyPedSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: localizations.dailyPedDosageTitle,
              value: data.pedHealth.dosageTaken,
              onChanged: (v) => controller.onPedDosageChanged(v),
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.dailyPedSideEffectsTitle,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _textArea(
              data.pedHealth.sideEffects,
              hint: localizations.dailyGenericTypeHint,
              onChanged: (v) => controller.onPedSideEffectsChanged(v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloodPressureCard(BuildContext context, DailyTrackingEntity data) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bloodtype_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyBpSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _labeledField(
                    localizations.dailyBpSystolicLabel,
                    data.pedHealth.systolicText,
                    (v) => controller.onPedBpChanged('systolicText', v),
                    hint: localizations.dailyGenericTypeHint,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _labeledField(
                    localizations.dailyBpDiastolicLabel,
                    data.pedHealth.diastolicText,
                    (v) => controller.onPedBpChanged('diastolicText', v),
                    hint: localizations.dailyGenericTypeHint,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _labeledField(
              localizations.dailyBpRestingHrLabel,
              data.pedHealth.restingHrText,
              (v) => controller.onPedBpChanged('restingHrText', v),
              hint: localizations.dailyGenericTypeHint,
            ),
            SizedBox(height: 12.h),
            _labeledField(
              localizations.dailyBpGlucoseLabel,
              data.pedHealth.glucoseText,
              (v) => controller.onPedBpChanged('glucoseText', v),
              hint: localizations.dailyGenericTypeHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyNotesCard(BuildContext context, String notes) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_alt_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  localizations.dailyNotesSectionTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _textArea(
              notes,
              hint: localizations.dailyGenericTypeHint,
              onChanged: (v) => controller.onDailyNotesChanged(v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context, bool isUpdate) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(20, 20, 255, 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () => controller.onSavePressed(),
        child: Text(
          isUpdate ? 'Update' : AppLocalizations.of(context)!.dailySubmitButton,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _textArea(
    String initialValue, {
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 4,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }
}

class _NutritionPlanDropdown extends StatelessWidget {
  final String? selectedPlan;
  final List<String> plans;
  final ValueChanged<String> onChanged;

  const _NutritionPlanDropdown({
    required this.selectedPlan,
    required this.plans,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: (selectedPlan == null || selectedPlan!.isEmpty)
              ? null
              : selectedPlan,
          isExpanded: true,
          dropdownColor: const Color(0XFF152032),
          icon: Icon(Icons.expand_more, color: Colors.white70, size: 20.sp),
          hint: Text(
            localizations.dailyNutritionSelectPlan,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          items: plans
              .map(
                (plan) => DropdownMenuItem<String>(
                  value: plan,
                  child: Row(
                    children: [
                      Icon(
                        plan == 'Training Day'
                            ? Icons.fitness_center
                            : plan == 'Rest Day'
                            ? Icons.bed_outlined
                            : Icons.star_outline,
                        color: plan == selectedPlan
                            ? Colors.green
                            : Colors.white54,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        plan,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
