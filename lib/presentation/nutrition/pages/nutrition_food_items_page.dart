import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';
import 'package:fitness_app/presentation/nutrition/controllers/food_items_controller.dart';
import 'package:get/get.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionFoodItemsPage extends StatelessWidget {
  const NutritionFoodItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FoodItemsController(getFoodItemsUseCase: sl()));
    return const _FoodItemsView();
  }
}

class _FoodItemsView extends StatelessWidget {
  const _FoodItemsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuFoodItemsTitle,
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
      body: Obx(() {
        final controller = Get.find<FoodItemsController>();
        if (controller.isLoading.value && controller.foodItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              localizations.trainingExerciseGenericError,
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return SingleChildScrollView(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              _searchField(controller),
              SizedBox(height: 12.h),
              _filterRow(controller),
              SizedBox(height: 12.h),
              if (controller.visibleItems.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      'No items found',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              else
                ...controller.visibleItems.map((it) => _FoodItemTile(item: it)),
              if (controller.isFetchingMore.value)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _searchField(FoodItemsController controller) {
    final localizations = AppLocalizations.of(Get.context!)!;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: localizations.dailyGenericTypeHint,
          hintStyle: GoogleFonts.poppins(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _filterRow(FoodItemsController controller) {
    final localizations = AppLocalizations.of(Get.context!)!;
    Widget chip(String label, FoodCategory cat, {Color? color}) {
      final isSelected = controller.currentFilter.value == cat;
      return UnconstrainedBox(
        child: InkWell(
          onTap: () => controller.setFilter(cat),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2F6D2F)
                  : const Color(0XFF101021),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF82C941)
                    : const Color(0xFF2E2E5D),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(localizations.nutritionFoodItemsCategoryAll, FoodCategory.all),
          chip(
            localizations.nutritionFoodItemsCategoryProtein,
            FoodCategory.protein,
          ),
          chip(
            localizations.nutritionFoodItemsCategoryCarbs,
            FoodCategory.carbs,
          ),
          chip(localizations.nutritionFoodItemsCategoryFats, FoodCategory.fats),
          chip(
            localizations.nutritionFoodItemsCategoryFruits,
            FoodCategory.fruits,
          ),
          chip(
            localizations.nutritionFoodItemsCategoryVegetables,
            FoodCategory.vegetables,
          ),
          chip('Dairy', FoodCategory.dairy),
          chip(
            localizations.nutritionFoodItemsCategorySupplements,
            FoodCategory.supplements,
          ),
        ],
      ),
    );
  }
}

class _FoodItemTile extends StatelessWidget {
  final FoodItemEntity item;
  const _FoodItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    Color catColor(FoodCategory c) {
      switch (c) {
        case FoodCategory.protein:
          return const Color(0xFF82C941);
        case FoodCategory.carbs:
          return const Color(0xFF4A6CF7);
        case FoodCategory.fats:
          return const Color(0xFFFF6D00);
        case FoodCategory.supplements:
          return const Color(0xFF82C941);
        case FoodCategory.fruits:
          return const Color(0xFFE04F5F); // Reddish for fruits
        case FoodCategory.vegetables:
          return const Color(0xFF4CAF50);
        case FoodCategory.all:
          return Colors.white70;
        case FoodCategory.dairy:
          return const Color(0xFF82C941);
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF2E2E5D)),
                  ),
                  child: Text(
                    _catLabel(item.category, localizations),
                    style: GoogleFonts.poppins(
                      color: catColor(item.category),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.nutritionFoodItemsEnergyLabel(
                    item.defaultQuantity,
                  ),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF82C941),
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  '${item.calories} kcal',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF82C941),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _macroChip(
                    '${localizations.dailyNutritionProteinLabel}: ${item.protein.toStringAsFixed(2)}g',
                    const Color(0xFF4A6CF7),
                  ),
                  _macroChip(
                    '${localizations.dailyNutritionCarbsLabel}: ${item.carbs.toStringAsFixed(2)}g',
                    const Color(0xFF82C941),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip(
                    '${localizations.dailyNutritionFatsLabel}: ${item.fats.toStringAsFixed(2)}g',
                    const Color(0xFFFF6D00),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip(
                    '${localizations.nutritionFoodItemsSatFatsLabel}: ${item.saturatedFats.toStringAsFixed(2)}g',
                    const Color(0xFF2E2E5D),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip(
                    '${localizations.nutritionFoodItemsUnsatFatsLabel}: ${item.unsaturatedFats.toStringAsFixed(2)}g',
                    const Color(0xFF82C941),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip(
                    '${localizations.nutritionFoodItemsSugarLabel}: ${item.sugar.toStringAsFixed(2)}g',
                    const Color(0xFFE04F5F),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _catLabel(FoodCategory c, AppLocalizations localizations) {
    switch (c) {
      case FoodCategory.protein:
        return localizations.nutritionFoodItemsCategoryProtein;
      case FoodCategory.carbs:
        return localizations.nutritionFoodItemsCategoryCarbs;
      case FoodCategory.fats:
        return localizations.nutritionFoodItemsCategoryFats;
      case FoodCategory.supplements:
        return localizations.nutritionFoodItemsCategorySupplements;
      case FoodCategory.fruits:
        return localizations.nutritionFoodItemsCategoryFruits;
      case FoodCategory.vegetables:
        return localizations.nutritionFoodItemsCategoryVegetables;
      case FoodCategory.all:
        return localizations.nutritionFoodItemsCategoryAll;
      case FoodCategory.dairy:
        return 'Dairy';
    }
  }

  Widget _macroChip(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}
