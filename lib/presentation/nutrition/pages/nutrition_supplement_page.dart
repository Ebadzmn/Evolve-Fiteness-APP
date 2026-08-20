import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionSupplementPage extends StatelessWidget {
  const NutritionSupplementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NutritionSupplementBloc>()
            ..add(const NutritionSupplementLoadRequested()),
      child: const _NutritionSupplementView(),
    );
  }
}

class _NutritionSupplementView extends StatelessWidget {
  const _NutritionSupplementView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuSupplementTitle,
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
      body: BlocBuilder<NutritionSupplementBloc, NutritionSupplementState>(
        builder: (context, state) {
          if (state.status == NutritionSupplementStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NutritionSupplementStatus.failure) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state.status == NutritionSupplementStatus.success &&
              state.data != null) {
            final supplements = state.data!.items;
            if (supplements.isEmpty) {
              return Center(
                child: Text(
                  localizations.coachAddedShortly,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF13131F),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF2E2E5D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.nutritionSupplementsHeaderTitle,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: const Color(0xFF2E2E5D), height: 1),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: 940.w),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.2), // Name
                            1: FlexColumnWidth(1.2), // Brand
                            2: FlexColumnWidth(1.0), // Dosage
                            3: FlexColumnWidth(1.0), // Frequency
                            4: FlexColumnWidth(0.8), // Time
                            5: FlexColumnWidth(1.0), // Purpose
                            6: FlexColumnWidth(1.6), // Note
                            7: FlexColumnWidth(1.4), // Product Link
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF2E2E5D)),
                                ),
                              ),
                              children: [
                                _headerCell(
                                  localizations.nutritionSupplementsTableName,
                                ),
                                _headerCell(
                                  localizations.nutritionSupplementsTableBrand,
                                ),
                                _headerCell(
                                  localizations.nutritionSupplementsTableDosage,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTableFrequency,
                                ),
                                _headerCell(
                                  localizations.nutritionSupplementsTableTime,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTablePurpose,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTableComment,
                                ),
                                _headerCell(
                                  localizations.supplementProductLink,
                                ),
                              ],
                            ),
                            ...supplements.map(
                              (supplement) => _dataRow(
                                context,
                                supplement.name,
                                supplement.brand,
                                supplement.dosage,
                                supplement.frequency,
                                supplement.time,
                                supplement.purpose,
                                supplement.note,
                                supplement.productLink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Text(
              localizations.coachAddedShortly,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  TableRow _dataRow(
    BuildContext context,
    String name,
    String brand,
    String dosage,
    String frequency,
    String time,
    String purpose,
    String note,
    String productLink,
  ) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
      ),
      children: [
        _dataCell(name),
        _dataCell(brand),
        _dataCell(dosage),
        _dataCell(frequency),
        _dataCell(time),
        _dataCell(purpose),
        _dataCell(note),
        _linkCell(context, name, productLink),
      ],
    );
  }

  Widget _dataCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _linkCell(BuildContext context, String name, String link) {
    final normalizedLink = _normalizeUrl(link);
    final hasLink = normalizedLink.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: GestureDetector(
        onTap: hasLink
            ? () {
                context.push(
                  AppRoutes.webViewScreen,
                  extra: {
                    'url': normalizedLink,
                    'title': name,
                  },
                );
              }
            : null,
        child: Text(
          hasLink ? normalizedLink : '-',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: hasLink ? const Color(0xFF69B427) : Colors.white70,
            fontSize: 12.sp,
            fontWeight: hasLink ? FontWeight.w500 : FontWeight.w400,
            decoration: hasLink ? TextDecoration.underline : null,
            decorationColor: const Color(0xFF69B427),
          ),
        ),
      ),
    );
  }

  String _normalizeUrl(String link) {
    final value = link.trim();
    if (value.isEmpty) return '';
    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) return value;
    return 'https://$value';
  }
}
