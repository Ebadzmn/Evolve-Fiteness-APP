import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/presentation/training/controllers/exercise_controller.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import '../../../../../../injection_container.dart';
import 'package:get/get.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller using GetX
    Get.put(ExerciseController(getExercisesUseCase: sl()));
    return const _ExerciseView();
  }
}

class _ExerciseView extends StatelessWidget {
  const _ExerciseView();

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
          localizations.trainingExerciseAppBarTitle,
          style: AppTextStyle.appbarHeading,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final controller = Get.find<ExerciseController>();
        return SingleChildScrollView(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchField(controller, localizations),
              SizedBox(height: 16.h),
              _filters(controller, localizations),
              SizedBox(height: 20.h),
              if (controller.isLoading.value)
                SizedBox(
                  height: 400.h,
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (controller.errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
              else
                ...[
                  ...controller.visibleExercises.map(
                    (e) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _exerciseCard(context, e),
                    ),
                  ),
                  if (controller.isFetchingMore.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
            ],
          ),
        );
      }),
    );
  }

  Widget _searchField(
    ExerciseController controller,
    AppLocalizations localizations,
  ) {
    return TextFormField(
      controller: controller.searchController,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: localizations.trainingExerciseSearchHint,
        hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0XFF101021),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
      ),
      onChanged: controller.onSearchChanged,
    );
  }

  Widget _filters(
    ExerciseController controller,
    AppLocalizations localizations,
  ) {
    final filterMap = {
      'All': localizations.filterAll,
      'Neck': localizations.filterNeck,
      'Back': localizations.filterBack,
      'Arms': localizations.filterArms,
      'Core': localizations.filterCore,
      'Legs': localizations.filterLegs,
      'Shoulders': localizations.filterShoulders,
      'Chest': localizations.filterChest,
      'Triceps': localizations.filterTriceps,
      'Biceps': localizations.filterBiceps,
      'Lower Back': localizations.filterLowerBack,
      'Glutes': localizations.filterGlutes,
      'Quadriceps': localizations.filterQuadriceps,
      'Hamstrings': localizations.filterHamstrings,
      'Calves': localizations.filterCalves,
      'Other': localizations.filterOther,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in filterMap.entries) ...[
            _filterChip(
              label: entry.value,
              selected: controller.currentFilter.value == entry.key,
              onTap: () => controller.setFilter(entry.key),
            ),
            SizedBox(width: 12.w),
          ],
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF43A047) : const Color(0xFF3A3A55),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, ExerciseEntity e) {
    return InkWell(
      onTap: () => context.push(AppRoutes.exerciseDetailPage, extra: e),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        padding: EdgeInsets.all(10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2B2D3F),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 28.sp,
              ),
            ),

            SizedBox(width: 12.w),

            // RIGHT SIDE CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      _smallChip(e.category, color: const Color(0xFF223522)),
                      SizedBox(width: 8.w),
                      const Icon(
                        Icons.fitness_center,
                        color: Colors.white70,
                        size: 14,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          e.equipment,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      for (final t in e.tags)
                        _smallChip(t, color: const Color(0xFF3A3A55)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallChip(String label, {required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
