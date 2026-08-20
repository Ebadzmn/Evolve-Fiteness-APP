import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/presentation/nutrition/controllers/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_statistics_entity.dart'
    as stats;
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:get/get.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX controller initialized if not already
    final controller = Get.isRegistered<NutritionController>()
        ? Get.find<NutritionController>()
        : Get.put(sl<NutritionController>());

    return _NutritionView(controller: controller);
  }
}

class _NutritionView extends StatelessWidget {
  final NutritionController controller;
  const _NutritionView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionAppBarTitle,
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
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.homePage);
                }
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.nutritionData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.nutritionData.value;
        if (data == null) {
          return const Center(
            child: Text(
              'No Data Available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final showPeds =
            controller.athleteStatus.value.trim().toLowerCase() == 'enhanced';

        return RefreshIndicator(
          onRefresh: () => controller.fetchNutritionData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                _macrosCard(
                  localizations: localizations,
                  totals: stats.NutritionTotalsEntity(
                    totalCalories: data.caloriesConsumed.toDouble(),
                    totalProtein: data.proteinConsumed.toDouble(),
                    totalFats: data.fatConsumed.toDouble(),
                    totalCarbs: data.carbsConsumed.toDouble(),
                  ),
                  goals: data,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.restaurant_menu,
                        iconColor: const Color(0xFF82C941),
                        title: localizations.nutritionMenuFoodItemsTitle,
                        subtitle: localizations.nutritionMenuFoodItemsSubtitle,
                        borderColor: const Color(0xFF294328),
                        onTap: () =>
                            context.push(AppRoutes.nutritionFoodItemsPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.calendar_month_outlined,
                        iconColor: const Color(0xFF4A6CF7),
                        title: localizations.nutritionMenuPlanTitle,
                        subtitle: localizations.nutritionMenuPlanSubtitle,
                        borderColor: const Color(0xFF1D89E47A).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionPlanPage),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.add_circle_outline,
                        iconColor: const Color(0xFFFF6D00),
                        title: localizations.nutritionMenuTrackMealsTitle,
                        subtitle: localizations.nutritionMenuTrackMealsSubtitle,
                        borderColor: const Color(0xFFFF6D00).withOpacity(0.4),
                        onTap: () =>
                            context.push(AppRoutes.nutritionTrackMealsPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.stacked_line_chart,
                        iconColor: const Color(0xFFFF6D00),
                        title: localizations.nutritionMenuStatisticsTitle,
                        subtitle: localizations.nutritionMenuStatisticsSubtitle,
                        borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                        onTap: () =>
                            context.push(AppRoutes.nutritionStatisticsPage),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.medication_liquid,
                        iconColor: const Color(0xFF4A6CF7),
                        title: localizations.nutritionMenuSupplementTitle,
                        subtitle: '',
                        borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                        onTap: () =>
                            context.push(AppRoutes.nutritionSupplementPage),
                      ),
                    ),
                    if (showPeds) ...[
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _menuTile(
                          icon: Icons.science_outlined,
                          iconColor: const Color(0xFFFF6D00),
                          title: localizations.nutritionMenuPedTitle,
                          subtitle: localizations.nutritionMenuPedSubtitle,
                          borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                          onTap: () =>
                              context.push(AppRoutes.nutritionPEDsPage),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _macrosCard({
    required AppLocalizations localizations,
    required stats.NutritionTotalsEntity totals,
    required NutritionDashboardEntity goals,
  }) {
    final proteinStr = totals.totalProtein.toStringAsFixed(2);
    final carbsStr = totals.totalCarbs.toStringAsFixed(2);
    final fatsStr = totals.totalFats.toStringAsFixed(2);

    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF212021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF838383)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.nutritionTodayMacrosTitle,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${totals.totalCalories.toInt()} kcal',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF82C941),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _macroRow(
            label: localizations.nutritionMacroProteinLabel,
            valueText: '${proteinStr}g',
            color: const Color(0xFF4A6CF7),
            progress: goals.proteinGoal > 0
                ? totals.totalProtein / goals.proteinGoal
                : 0,
          ),
          SizedBox(height: 8.h),
          _macroRow(
            label: localizations.nutritionMacroCarbsLabel,
            valueText: '${carbsStr}g',
            color: const Color(0xFF82C941),
            progress: goals.carbsGoal > 0
                ? totals.totalCarbs / goals.carbsGoal
                : 0,
          ),
          SizedBox(height: 8.h),
          _macroRow(
            label: localizations.nutritionMacroFatsLabel,
            valueText: '${fatsStr}g',
            color: const Color(0xFFFF6D00),
            progress: goals.fatGoal > 0 ? totals.totalFats / goals.fatGoal : 0,
          ),
        ],
      ),
    );
  }

  Widget _macroRow({
    required String label,
    required String valueText,
    required Color color,
    required double progress,
  }) {
    progress = progress.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
            ),
            Text(
              valueText,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            minHeight: 6.h,
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    required Color borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 140.h),
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
