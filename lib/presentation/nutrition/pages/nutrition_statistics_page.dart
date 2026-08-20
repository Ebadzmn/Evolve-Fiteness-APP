import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_statistics_entity.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_statistics/nutrition_statistics_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_statistics/nutrition_statistics_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_statistics/nutrition_statistics_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionStatisticsPage extends StatelessWidget {
  const NutritionStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NutritionStatisticsBloc>()
            ..add(NutritionStatisticsLoadRequested(DateTime.now())),
      child: const _NutritionStatisticsView(),
    );
  }
}

class _NutritionStatisticsView extends StatelessWidget {
  const _NutritionStatisticsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuStatisticsTitle,
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
      body: BlocBuilder<NutritionStatisticsBloc, NutritionStatisticsState>(
        builder: (context, state) {
          if (state.status == NutritionStatisticsStatus.loading &&
              state.statistics == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NutritionStatisticsStatus.failure &&
              state.statistics == null) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final stats = state.statistics;
          if (stats == null) return const SizedBox();

          return Column(
            children: [
              if (state.status == NutritionStatisticsStatus.loading)
                const LinearProgressIndicator(
                  backgroundColor: AppColor.primaryColor,
                  color: Color(0xFF82C941),
                  minHeight: 2,
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Macros',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildMacrosSection(localizations, stats),
                      SizedBox(height: 30.h),
                      Text(
                        localizations.dailyNutritionCaloriesLabel,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildCaloriesChart(context, stats),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMacrosSection(
    AppLocalizations localizations,
    NutritionStatisticsEntity stats,
  ) {
    final protein = stats.percentages.proteinPercent;
    final carbs = stats.percentages.carbsPercent;
    final fats = stats.percentages.fatsPercent;

    final proteinG = '${stats.totals.totalProtein.toStringAsFixed(2)}g';
    final carbsG = '${stats.totals.totalCarbs.toStringAsFixed(2)}g';
    final fatsG = '${stats.totals.totalFats.toStringAsFixed(2)}g';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 120.r,
          width: 120.r,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40.r,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: const Color(0xFF43A047), // Green (Protein)
                  value: protein,
                  title: '',
                  radius: 20.r,
                  showTitle: false,
                ),
                PieChartSectionData(
                  color: const Color(0xFF4A6CF7), // Blue (Carbs)
                  value: carbs,
                  title: '',
                  radius: 20.r,
                  showTitle: false,
                ),
                PieChartSectionData(
                  color: const Color(0xFFFF6D00), // Orange (Fats)
                  value: fats,
                  title: '',
                  radius: 20.r,
                  showTitle: false,
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _legendItem(
              const Color(0xFF43A047),
              '${localizations.dailyNutritionProteinLabel} ${protein.toStringAsFixed(0)}%',
              proteinG,
            ),
            SizedBox(height: 12.h),
            _legendItem(
              const Color(0xFF4A6CF7),
              '${localizations.dailyNutritionCarbsLabel} ${carbs.toStringAsFixed(0)}%',
              carbsG,
            ),
            SizedBox(height: 12.h),
            _legendItem(
              const Color(0xFFFF6D00),
              '${localizations.dailyNutritionFatsLabel} ${fats.toStringAsFixed(0)}%',
              fatsG,
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: const Color(0xFFB0B0B0),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesChart(
    BuildContext context,
    NutritionStatisticsEntity stats,
  ) {
    // stats.caloriesByDate is a list of DailyCaloriesEntity
    // We expect 7 days max for the chart? Or partial.
    // Let's assume the API returns sorted list.
    final spots = <FlSpot>[];
    double maxCal = 500;

    // Map data to x indices (0..N)
    for (int i = 0; i < stats.caloriesByDate.length; i++) {
      final val = stats.caloriesByDate[i].totalCalories;
      if (val > maxCal) maxCal = val;
      spots.add(FlSpot(i.toDouble(), val));
    }

    // Dynamic Max Y (round up to nearest 500)
    double maxY = ((maxCal / 500).ceil() * 500).toDouble();
    if (maxY == 0) maxY = 500;

    return Container(
      height: 220.h,
      width: double.infinity,
      padding: EdgeInsets.only(right: 16.w, top: 10.h),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchCallback:
                (FlTouchEvent event, LineTouchResponse? touchResponse) {
                  if (event is FlTapUpEvent &&
                      touchResponse != null &&
                      touchResponse.lineBarSpots != null &&
                      touchResponse.lineBarSpots!.isNotEmpty) {
                    final spotIndex =
                        touchResponse.lineBarSpots!.first.spotIndex;
                    if (spotIndex >= 0 &&
                        spotIndex < stats.caloriesByDate.length) {
                      final dateStr = stats.caloriesByDate[spotIndex].date;
                      try {
                        // Assuming dateStr is in YYYY-MM-DD format
                        final date = DateTime.parse(dateStr);
                        context.read<NutritionStatisticsBloc>().add(
                          NutritionStatisticsLoadRequested(date),
                        );
                      } catch (e) {
                        debugPrint('Error parsing date: $e');
                      }
                    }
                  }
                },
            handleBuiltInTouches: true,
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 500,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white10,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= stats.caloriesByDate.length)
                    return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      stats
                          .caloriesByDate[index]
                          .day, // Use the day form API (e.g. "Thu")
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 500,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value > maxY) return const SizedBox();
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFB0B0B0),
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (stats.caloriesByDate.length - 1).toDouble(), // Dynamic range
          minY: 0,
          maxY: maxY, // Dynamic Y
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF4A6CF7),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4A6CF7).withValues(alpha: 0.5),
                    const Color(0xFF4A6CF7).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
