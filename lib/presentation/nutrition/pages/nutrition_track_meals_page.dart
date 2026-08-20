import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_suggestion_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NutritionTrackMealsPage extends StatelessWidget {
  const NutritionTrackMealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final initialDate = DateTime.now();
    return BlocProvider(
      create: (_) =>
          sl<TrackMealsBloc>()..add(TrackMealsLoadRequested(initialDate)),
      child: const _TrackMealsView(),
    );
  }
}

class _TrackMealsView extends StatelessWidget {
  const _TrackMealsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuTrackMealsTitle,
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
      body: BlocBuilder<TrackMealsBloc, TrackMealsState>(
        builder: (context, state) {
          if (state.status == TrackMealsStatus.failure) {
            return Center(
              child: Text(
                localizations.trainingExerciseGenericError,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      final bloc = context.read<TrackMealsBloc>();
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => BlocProvider.value(
                          value: bloc,
                          child: _AddMealDialog(date: state.date),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFF82C941)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      child: Text(
                        '+ ${localizations.nutritionTrackAddMeal}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _datePicker(context, state.date),
                SizedBox(height: 12.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child:
                      state.status == TrackMealsStatus.loading &&
                          state.trackingData == null
                      ? _PlanHeaderSkeleton()
                      : (state.trackingData != null
                            ? _planHeader(
                                context,
                                state.trackingData!,
                                state.plan,
                              )
                            : const SizedBox()),
                ),
                if (state.trackingData != null) SizedBox(height: 12.h),
                if (state.trackingData != null)
                  _macroCircles(context, state.trackingData!.totals),
                SizedBox(height: 12.h),
                if (state.status == TrackMealsStatus.loading &&
                    state.trackingData == null)
                  const _MealsSkeletonList()
                else if (state.trackingData != null &&
                    state.trackingData!.data.isNotEmpty)
                  ...state.trackingData!.data.first.meals.map(
                    (m) => _MealTile(meal: m),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _datePicker(BuildContext context, DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    String label() {
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return localizations.dailyDateToday;
      }
      return DateFormat('dd.MM.yyyy').format(date);
    }

    void changeBy(int days) {
      final newDate = date.add(Duration(days: days));
      context.read<TrackMealsBloc>().add(TrackMealsDateChanged(newDate));
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 0.5.w, color: const Color(0xFF82C941)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => changeBy(-1),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Center(
                  child: Text(
                    label(),
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
          IconButton(
            onPressed: () => changeBy(1),
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _planHeader(
    BuildContext context,
    NutritionDailyTrackingEntity trackingData,
    NutritionPlanEntity? plan,
  ) {
    final currentWater = trackingData.water;
    final goalWater = ((plan?.waterLiters ?? 4.0) * 1000).toInt();
    final currentCalories = trackingData.totals.totalCalories;
    final goalCalories = plan?.calories ?? 2500;

    final trackMealsState = context.read<TrackMealsBloc>().state;

    return _DailyGoalSection(
      currentWaterMl: currentWater,
      goalWaterMl: goalWater,
      currentCalories: currentCalories,
      goalCalories: goalCalories,
      bottleAmountMl: trackMealsState.bottleAmountMl,
      glassAmountMl: trackMealsState.glassAmountMl,
    );
  }

  Widget _macroCircles(BuildContext context, NutritionTotalsEntity totals) {
    final totalProtein = totals.totalProtein;
    final totalCarbs = totals.totalCarbs;
    final totalFats = totals.totalFats;

    Widget macroItem(String text, String label, Color color, Color fillcolor) {
      return Column(
        children: [
          Container(
            height: 50.r,
            width: 50.r,
            decoration: BoxDecoration(
              color: fillcolor,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          macroItem(
            '${totalProtein.toStringAsFixed(2)}g',
            AppLocalizations.of(context)!.dailyNutritionProteinLabel,
            const Color(0xFF2287DD),
            const Color(0xFF1B3043),
          ),
          macroItem(
            '${totalCarbs.toStringAsFixed(2)}g',
            AppLocalizations.of(context)!.dailyNutritionCarbsLabel,
            const Color(0xFF43A047),
            const Color(0xFF224225),
          ),
          macroItem(
            '${totalFats.toStringAsFixed(2)}g',
            AppLocalizations.of(context)!.dailyNutritionFatsLabel,
            const Color(0xFFFF6D00),
            const Color(0xFF42291A),
          ),
        ],
      ),
    );
  }
}

class _PlanHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _skeletonStatCard()),
              SizedBox(width: 12.w),
              Expanded(child: _skeletonStatCard()),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: 120.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _skeletonWaterCard()),
              SizedBox(width: 12.w),
              Expanded(child: _skeletonWaterCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _skeletonStatCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonWaterCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 32.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealsSkeletonList extends StatelessWidget {
  const _MealsSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(3, (index) => _item(context)));
  }

  Widget _item(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 100.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 60.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyGoalSection extends StatelessWidget {
  final int currentWaterMl;
  final int goalWaterMl;
  final int currentCalories;
  final int goalCalories;
  final int bottleAmountMl;
  final int glassAmountMl;

  const _DailyGoalSection({
    required this.currentWaterMl,
    required this.goalWaterMl,
    required this.currentCalories,
    required this.goalCalories,
    required this.bottleAmountMl,
    required this.glassAmountMl,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final waterPercentage = goalWaterMl > 0
        ? ((currentWaterMl / goalWaterMl) * 100).clamp(0, 100).toInt()
        : 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Main card background
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY GOAL',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  title: localizations.dailyCalories,
                  value: '$currentCalories kcal',
                  icon: Icons.local_fire_department_outlined,
                  iconColor: const Color(0xFF00D180),
                  backgroundColor: const Color(0xFF2C2C2E),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _statCard(
                  title: localizations.nutritionWaterGoal,
                  value: '$waterPercentage%',
                  icon: Icons.water_drop_outlined,
                  iconColor: const Color(0xFF4A90E2),
                  backgroundColor: const Color(0xFF2C2C2E),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'Water Intake',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _waterIntakeCard(
                  context,
                  unit: 'bottle',
                  totalAmount: bottleAmountMl,
                  stepAmount: 500,
                  icon: FontAwesomeIcons.bottleWater,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _waterIntakeCard(
                  context,
                  unit: 'glass',
                  totalAmount: glassAmountMl,
                  stepAmount: 2000,
                  icon: FontAwesomeIcons.glassWater,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waterIntakeCard(
    BuildContext context, {
    required String unit,
    required int totalAmount,
    required int stepAmount,
    required dynamic icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    icon is IconData 
                        ? Icon(icon, color: const Color(0xFF00D180), size: 20.sp)
                        : FaIcon(icon, color: const Color(0xFF00D180), size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      '$totalAmount ml',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (unit == 'glass') {
                    _showCustomWaterDeleteDialog(
                      context,
                      unit: unit,
                      initialAmount: stepAmount,
                    );
                    return;
                  }

                  final bloc = context.read<TrackMealsBloc>();
                  bloc.add(
                    TrackMealsLogWater(
                      date: bloc.state.date,
                      unit: unit,
                      amount: -stepAmount,
                    ),
                  );

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$stepAmount ml removed',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF1E1E2C),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white54,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              if (unit == 'glass') {
                _showCustomWaterDialog(
                  context,
                  unit: unit,
                  initialAmount: stepAmount,
                );
                return;
              }

              final bloc = context.read<TrackMealsBloc>();
              bloc.add(
                TrackMealsLogWater(
                  date: bloc.state.date,
                  unit: unit,
                  amount: stepAmount,
                ),
              );

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '$stepAmount ml added',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF1E1E2C),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00D180),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  '+ Add',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomWaterDialog(
    BuildContext context, {
    required String unit,
    required int initialAmount,
  }) async {
    final controller = TextEditingController(text: initialAmount.toString());
    final amount = await showDialog<int>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Water (ml)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter amount',
              hintStyle: GoogleFonts.poppins(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF00D180)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                if (parsed == null || parsed <= 0) {
                  Navigator.of(dialogCtx).pop(-1);
                  return;
                }
                Navigator.of(dialogCtx).pop(parsed);
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF00D180),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (amount == null) return;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid amount',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1E1E2C),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    final bloc = context.read<TrackMealsBloc>();
    bloc.add(
      TrackMealsLogWater(date: bloc.state.date, unit: unit, amount: amount),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$amount ml added',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E2C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _showCustomWaterDeleteDialog(
    BuildContext context, {
    required String unit,
    required int initialAmount,
  }) async {
    final controller = TextEditingController(text: initialAmount.toString());
    final amount = await showDialog<int>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Remove Water (ml)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter amount',
              hintStyle: GoogleFonts.poppins(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFF00D180)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                if (parsed == null || parsed <= 0) {
                  Navigator.of(dialogCtx).pop(-1);
                  return;
                }
                Navigator.of(dialogCtx).pop(parsed);
              },
              child: Text(
                'Remove',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF00D180),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (amount == null) return;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid amount',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1E1E2C),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    final bloc = context.read<TrackMealsBloc>();
    bloc.add(
      TrackMealsLogWater(date: bloc.state.date, unit: unit, amount: -amount),
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$amount ml removed',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E2C),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _MealTile extends StatefulWidget {
  final TrackingMealEntity meal;
  const _MealTile({required this.meal});

  @override
  State<_MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<_MealTile> {
  bool _expanded =
      true; // Default expanded as per typical UX for active meal tracking

  @override
  Widget build(BuildContext context) {
    final m = widget.meal;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F15), // Dark background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    m.mealNumber, // changed from title
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {
                      final bloc = context.read<TrackMealsBloc>();
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => BlocProvider.value(
                          value: bloc,
                          child: _AddFoodItemsToMealDialog(
                            date: bloc.state.date,
                            mealId: m.id,
                            mealTitle: m.mealNumber,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: const Color(0xFF82C941),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Macros Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  '${m.totalCalories} kcal', // changed from calories
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF43A047), // Green color for calories
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16.w),
                _macroBadge(
                  'P: ${m.totalProtein.toInt()}g', // changed from proteinG
                  const Color(0xFF1B3043),
                  const Color(0xFF2287DD),
                ),
                SizedBox(width: 8.w),
                _macroBadge(
                  'C: ${m.totalCarbs.toInt()}g', // changed from carbsG
                  const Color(0xFF224225),
                  const Color(0xFF43A047),
                ),
                SizedBox(width: 8.w),
                _macroBadge(
                  'F: ${m.totalFats.toInt()}g', // changed from fatsG
                  const Color(0xFF42291A),
                  const Color(0xFFFF6D00),
                ),
              ],
            ),
          ),

          // Expandable Content (Table)
          // Expandable Content
          _expandableContent(context, m),
        ],
      ),
    );
  }

  Widget _expandableContent(BuildContext context, TrackingMealEntity m) {
    final localizations = AppLocalizations.of(context)!;
    if (!_expanded) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackFoodNameLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20.h,
                  color: const Color(0xFF2E2E5D),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackFoodQuantityLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20.h,
                  color: const Color(0xFF2E2E5D),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackTableActionLabel,
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

          if (m.food.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  localizations.nutritionTrackNoItemsLogged,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),

          // Items list
          if (m.food.isNotEmpty)
            ...m.food.map(
              (item) => Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 8.w,
                          ),
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: const Color(0xFF2E2E5D),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            item.quantity,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: const Color(0xFF2E2E5D),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              if (item.id != null) {
                                context.read<TrackMealsBloc>().add(
                                  TrackMealsDeleteFoodItem(
                                    mealId: m.id,
                                    foodId: item.id!,
                                    date: context
                                        .read<TrackMealsBloc>()
                                        .state
                                        .date,
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: const Color(0xFFFDD835),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _macroBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _AddMealDialog extends StatefulWidget {
  final DateTime date;
  const _AddMealDialog({required this.date});
  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final _mealCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final List<TextEditingController> _foodCtrls = [];
  final List<TextEditingController> _qtyCtrls = [];
  @override
  void initState() {
    super.initState();
    _addRow();
  }

  void _addRow() {
    _foodCtrls.add(TextEditingController());
    _qtyCtrls.add(TextEditingController());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: const Color(0xFF0F0F15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _inputField(
                      localizations.nutritionTrackMealNameLabel,
                      localizations.nutritionTrackFoodNameHint,
                      controller: _mealCtrl,
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              SizedBox(height: 16.h),
              Column(
                children: [
                  for (int i = 0; i < _foodCtrls.length; i++) ...[
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _foodNameWithSuggestions(
                                context,
                                rowIndex: i,
                                label:
                                    localizations.nutritionTrackFoodNameLabel,
                                hint: localizations.nutritionTrackFoodNameHint,
                                controller: _foodCtrls[i],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _inputField(
                                localizations.nutritionTrackFoodQuantityLabel,
                                localizations.nutritionTrackFoodQuantityHint,
                                controller: _qtyCtrls[i],
                                onChanged: (_) {
                                  context.read<TrackMealsBloc>().add(
                                    TrackMealsSuggestionsCleared(rowIndex: i),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _addRow,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFF82C941)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 6.w),
                            Text(
                              localizations.nutritionTrackAddItem,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _button(
                      localizations.nutritionTrackCancel,
                      const Color(0xFF1C222E),
                      Colors.white,
                      () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _button(
                      localizations.nutritionTrackAddMeal,
                      const Color(0xFF1A1A50),
                      Colors.white,
                      () {
                        final mealName = _mealCtrl.text.trim();
                        final timeLabel = _timeCtrl.text.trim().isEmpty
                            ? 'Custom'
                            : _timeCtrl.text.trim();
                        final items = <MealFoodItemEntity>[];
                        for (int i = 0; i < _foodCtrls.length; i++) {
                          final food = _foodCtrls[i].text.trim();
                          final qty = _qtyCtrls[i].text.trim();
                          if (food.isEmpty || qty.isEmpty) continue;
                          items.add(
                            MealFoodItemEntity(name: food, quantity: qty),
                          );
                        }
                        if (mealName.isEmpty || items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localizations
                                    .nutritionTrackValidationMealRequired,
                              ),
                            ),
                          );
                          return;
                        }
                        final meal = NutritionMealEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          timeLabel: timeLabel,
                          title: mealName,
                          calories: 0,
                          proteinG: 0,
                          carbsG: 0,
                          fatsG: 0,
                          items: items,
                          trainingDay:
                              localizations.nutritionTrackTrainingDayLabel,
                        );
                        context.read<TrackMealsBloc>().add(
                          TrackMealsAddMeal(widget.date, meal),
                        );
                        Navigator.pop(context);
                      },
                      borderColor: const Color(0xFF3F3F9F),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    String hint, {
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF13131F),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFF82C941)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodNameWithSuggestions(
    BuildContext context, {
    required int rowIndex,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return BlocBuilder<TrackMealsBloc, TrackMealsState>(
      buildWhen: (prev, curr) =>
          prev.suggestionsRowIndex != curr.suggestionsRowIndex ||
          prev.suggestionsLoading != curr.suggestionsLoading ||
          prev.suggestionsByRow[rowIndex] != curr.suggestionsByRow[rowIndex],
      builder: (context, state) {
        final suggestions =
            state.suggestionsByRow[rowIndex] ?? const <MealSuggestionEntity>[];
        final isActiveRow = state.suggestionsRowIndex == rowIndex;
        final showSuggestions = isActiveRow && suggestions.isNotEmpty;
        final showLoading = isActiveRow && state.suggestionsLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputField(
              label,
              hint,
              controller: controller,
              onChanged: (v) {
                context.read<TrackMealsBloc>().add(
                  TrackMealsSuggestionQueryChanged(
                    rowIndex: rowIndex,
                    query: v,
                  ),
                );
              },
            ),
            if (showLoading || showSuggestions) ...[
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF13131F),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    if (showLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: const LinearProgressIndicator(
                          minHeight: 2,
                          color: Color(0xFF82C941),
                          backgroundColor: Color(0xFF2C2C3E),
                        ),
                      ),
                    if (showSuggestions)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 180.h),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = suggestions[index];
                            return InkWell(
                              onTap: () {
                                controller.text = item.name;
                                controller.selection = TextSelection.collapsed(
                                  offset: controller.text.length,
                                );
                                context.read<TrackMealsBloc>().add(
                                  TrackMealsSuggestionsCleared(
                                    rowIndex: rowIndex,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                child: Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.white10),
                          itemCount: suggestions.length > 6
                              ? 6
                              : suggestions.length,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _button(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap, {
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null
              ? Border.all(color: borderColor)
              : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _AddFoodItemsToMealDialog extends StatefulWidget {
  final DateTime date;
  final String mealId;
  final String mealTitle;
  const _AddFoodItemsToMealDialog({
    required this.date,
    required this.mealId,
    required this.mealTitle,
  });

  @override
  State<_AddFoodItemsToMealDialog> createState() =>
      _AddFoodItemsToMealDialogState();
}

class _AddFoodItemsToMealDialogState extends State<_AddFoodItemsToMealDialog> {
  final List<TextEditingController> _foodCtrls = [];
  final List<TextEditingController> _qtyCtrls = [];

  @override
  void initState() {
    super.initState();
    _addRow();
  }

  void _addRow() {
    _foodCtrls.add(TextEditingController());
    _qtyCtrls.add(TextEditingController());
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _foodCtrls) {
      c.dispose();
    }
    for (final c in _qtyCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF13131F),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFF82C941)),
            ),
          ),
        ),
      ],
    );
  }

  Widget actionButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null
              ? Border.all(color: borderColor)
              : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget foodNameWithSuggestions({
    required int rowIndex,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return BlocBuilder<TrackMealsBloc, TrackMealsState>(
      buildWhen: (prev, curr) =>
          prev.suggestionsRowIndex != curr.suggestionsRowIndex ||
          prev.suggestionsLoading != curr.suggestionsLoading ||
          prev.suggestionsByRow[rowIndex] != curr.suggestionsByRow[rowIndex],
      builder: (context, state) {
        final suggestions =
            state.suggestionsByRow[rowIndex] ?? const <MealSuggestionEntity>[];
        final isActiveRow = state.suggestionsRowIndex == rowIndex;
        final showSuggestions = isActiveRow && suggestions.isNotEmpty;
        final showLoading = isActiveRow && state.suggestionsLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            inputField(
              label: label,
              hint: hint,
              controller: controller,
              onChanged: (v) {
                context.read<TrackMealsBloc>().add(
                  TrackMealsSuggestionQueryChanged(
                    rowIndex: rowIndex,
                    query: v,
                  ),
                );
              },
            ),
            if (showLoading || showSuggestions) ...[
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF13131F),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    if (showLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: const LinearProgressIndicator(
                          minHeight: 2,
                          color: Color(0xFF82C941),
                          backgroundColor: Color(0xFF2C2C3E),
                        ),
                      ),
                    if (showSuggestions)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 180.h),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = suggestions[index];
                            return InkWell(
                              onTap: () {
                                controller.text = item.name;
                                controller.selection = TextSelection.collapsed(
                                  offset: controller.text.length,
                                );
                                context.read<TrackMealsBloc>().add(
                                  TrackMealsSuggestionsCleared(
                                    rowIndex: rowIndex,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                                child: Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) =>
                              Divider(height: 1, color: Colors.white10),
                          itemCount: suggestions.length > 6
                              ? 6
                              : suggestions.length,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: const Color(0xFF0F0F15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.mealTitle,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Column(
                children: [
                  for (int i = 0; i < _foodCtrls.length; i++) ...[
                    Row(
                      children: [
                        Expanded(
                          child: foodNameWithSuggestions(
                            rowIndex: i,
                            label: localizations.nutritionTrackFoodNameLabel,
                            hint: localizations.nutritionTrackFoodNameHint,
                            controller: _foodCtrls[i],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: inputField(
                            label:
                                localizations.nutritionTrackFoodQuantityLabel,
                            hint: localizations.nutritionTrackFoodQuantityHint,
                            controller: _qtyCtrls[i],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _addRow,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFF82C941)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 6.w),
                            Text(
                              localizations.nutritionTrackAddItem,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: actionButton(
                      text: localizations.nutritionTrackCancel,
                      bgColor: const Color(0xFF1C222E),
                      textColor: Colors.white,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: actionButton(
                      text: localizations.nutritionTrackAddItem,
                      bgColor: const Color(0xFF1A1A50),
                      textColor: Colors.white,
                      borderColor: const Color(0xFF3F3F9F),
                      onTap: () {
                        final items = <MealFoodItemEntity>[];
                        for (int i = 0; i < _foodCtrls.length; i++) {
                          final food = _foodCtrls[i].text.trim();
                          final qtyRaw = _qtyCtrls[i].text.trim();
                          if (food.isEmpty || qtyRaw.isEmpty) continue;
                          final qtyStr = qtyRaw.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );
                          final qty = int.tryParse(qtyStr);
                          if (qty == null || qty <= 0) continue;
                          items.add(
                            MealFoodItemEntity(name: food, quantity: qtyStr),
                          );
                        }
                        if (items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localizations.nutritionTrackNoItemsLogged,
                              ),
                            ),
                          );
                          return;
                        }

                        context.read<TrackMealsBloc>().add(
                          TrackMealsAddFoodItemsToMeal(
                            date: widget.date,
                            mealId: widget.mealId,
                            food: items,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
