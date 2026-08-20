import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionPEDsPage extends StatelessWidget {
  const NutritionPEDsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          _NutritionPedsCubit(getProfile: sl(), apiClient: sl())..load(),
      child: const _NutritionPedsView(),
    );
  }
}

class _NutritionPedsView extends StatelessWidget {
  const _NutritionPedsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuPedTitle,
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
      body: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 16.w,
          right: 16.w,
          bottom: 20.h,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(8.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: BlocBuilder<_NutritionPedsCubit, _NutritionPedsState>(
            builder: (context, state) {
              if (state.status == _NutritionPedsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == _NutritionPedsStatus.failure) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Failed to load PED data',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (state.categories.isEmpty) {
                return Center(
                  child: Text(
                    localizations.coachAddedShortly,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: _buildTable(
                    context,
                    weekLabel: state.weekLabel,
                    categories: state.categories,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
    BuildContext context, {
    required String weekLabel,
    required List<_PedsCategory> categories,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final double col1Width = 80.w;
    final double col2Width = 100.w;
    final double colDosageWidth = 60.w;
    final double colFreqWidth = 60.w;
    final double colDayWidth = 50.w;

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FixedColumnWidth(col1Width),
        1: FixedColumnWidth(col2Width),
        2: FixedColumnWidth(colDosageWidth),
        3: FixedColumnWidth(colFreqWidth),
        4: FixedColumnWidth(colDayWidth),
        5: FixedColumnWidth(colDayWidth),
        6: FixedColumnWidth(colDayWidth),
        7: FixedColumnWidth(colDayWidth),
        8: FixedColumnWidth(colDayWidth),
        9: FixedColumnWidth(colDayWidth),
        10: FixedColumnWidth(colDayWidth),
      },
      border: TableBorder.all(color: const Color(0xFF4A3455), width: 1),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            Container(height: 30.h, color: const Color(0XFF101021)),
            Container(
              height: 30.h,
              color: const Color(0XFF101021),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                weekLabel.isEmpty ? 'WEEK' : weekLabel,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _headerCell(localizations.pedsDosage),
            _headerCell(localizations.pedsFrequency),
            _headerCell(localizations.pedsMo),
            _headerCell(localizations.pedsTue),
            _headerCell(localizations.pedsWed),
            _headerCell(localizations.pedsThu),
            _headerCell(localizations.pedsFri),
            _headerCell(localizations.pedsSat),
            _headerCell(localizations.pedsSun),
          ],
        ),
        for (final category in categories) ..._categoryRows(category),
      ],
    );
  }

  List<TableRow> _categoryRows(_PedsCategory category) {
    final subs = category.subCategories;
    final midIndex = subs.isEmpty ? -1 : subs.length ~/ 2;

    return List.generate(subs.length, (index) {
      final sub = subs[index];
      return TableRow(
        decoration: const BoxDecoration(color: Color(0xFF3C2A45)),
        children: [
          Container(
            height: 35.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            color: const Color(0xFF5A4565),
            child: index == midIndex
                ? Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          Container(
            height: 35.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              sub.name,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp),
              textAlign: TextAlign.center,
            ),
          ),
          _dataCell(sub.dosage),
          _dataCell(sub.frequency),
          _dataCell(sub.mon),
          _dataCell(sub.tue),
          _dataCell(sub.wed),
          _dataCell(sub.thu),
          _dataCell(sub.fri),
          _dataCell(sub.sat),
          _dataCell(sub.sun),
        ],
      );
    });
  }

  Widget _headerCell(String text) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dataCell(String text) {
    return Container(
      height: 35.h,
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}

enum _NutritionPedsStatus { loading, success, failure }

class _NutritionPedsState {
  final _NutritionPedsStatus status;
  final String weekLabel;
  final List<_PedsCategory> categories;
  final String? errorMessage;

  const _NutritionPedsState({
    this.status = _NutritionPedsStatus.loading,
    this.weekLabel = '',
    this.categories = const [],
    this.errorMessage,
  });

  _NutritionPedsState copyWith({
    _NutritionPedsStatus? status,
    String? weekLabel,
    List<_PedsCategory>? categories,
    String? errorMessage,
  }) {
    return _NutritionPedsState(
      status: status ?? this.status,
      weekLabel: weekLabel ?? this.weekLabel,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }
}

class _PedAppDataResponse {
  final bool success;
  final String message;
  final List<_PedWeekData> data;

  const _PedAppDataResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory _PedAppDataResponse.fromJson(Map json) {
    final success = json['success'] == true;
    final message = json['message']?.toString() ?? '';
    final dataRaw = json['data'];
    final data = (dataRaw is List ? dataRaw : const [])
        .whereType<Map>()
        .map(_PedWeekData.fromJson)
        .toList();
    return _PedAppDataResponse(success: success, message: message, data: data);
  }
}

class _PedWeekData {
  final String id;
  final String athleteId;
  final String coachId;
  final String week;
  final List<_PedsCategory> categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const _PedWeekData({
    required this.id,
    required this.athleteId,
    required this.coachId,
    required this.week,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _PedWeekData.fromJson(Map json) {
    final categoriesRaw = json['categories'];
    final categories = (categoriesRaw is List ? categoriesRaw : const [])
        .whereType<Map>()
        .map(_PedsCategory.fromJson)
        .toList();

    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value);
    }

    return _PedWeekData(
      id: json['_id']?.toString() ?? '',
      athleteId: json['athleteId']?.toString() ?? '',
      coachId: json['coachId']?.toString() ?? '',
      week: json['week']?.toString() ?? '',
      categories: categories,
      createdAt: parseDate(json['createdAt']?.toString()),
      updatedAt: parseDate(json['updatedAt']?.toString()),
    );
  }
}

class _NutritionPedsCubit extends Cubit<_NutritionPedsState> {
  final GetProfileUseCase getProfile;
  final ApiClient apiClient;

  _NutritionPedsCubit({required this.getProfile, required this.apiClient})
    : super(const _NutritionPedsState());

  Future<void> load() async {
    emit(
      state.copyWith(status: _NutritionPedsStatus.loading, errorMessage: null),
    );

    try {
      final profileResult = await getProfile();
      await profileResult.fold(
        (failure) async {
          emit(
            state.copyWith(
              status: _NutritionPedsStatus.failure,
              errorMessage: 'Failed to load profile',
            ),
          );
        },
        (_) async {
          final response = await apiClient.get(ApiUrls.pedAppData);
          final payload = response.data;
          if (payload is! Map) {
            emit(
              state.copyWith(
                status: _NutritionPedsStatus.failure,
                errorMessage: 'Invalid response',
              ),
            );
            return;
          }

          final parsed = _PedAppDataResponse.fromJson(payload);
          if (!parsed.success || parsed.data.isEmpty) {
            emit(
              state.copyWith(
                status: _NutritionPedsStatus.success,
                weekLabel: '',
                categories: const [],
              ),
            );
            return;
          }

          final latest = parsed.data.last;

          emit(
            state.copyWith(
              status: _NutritionPedsStatus.success,
              weekLabel: _formatWeekLabel(latest.week),
              categories: latest.categories,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: _NutritionPedsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

String _formatWeekLabel(String raw) {
  if (raw.trim().isEmpty) return '';
  final match = RegExp(
    r'week[_\\s-]*(\\d+)',
    caseSensitive: false,
  ).firstMatch(raw);
  if (match != null) {
    return 'WEEK ${match.group(1)}';
  }
  return raw.toUpperCase().replaceAll('_', ' ');
}

class _PedsCategory {
  final String name;
  final List<_PedsSubCategory> subCategories;

  const _PedsCategory({required this.name, required this.subCategories});

  static _PedsCategory fromJson(Map json) {
    final name = json['name']?.toString() ?? '';
    final subsRaw = json['subCategory'];
    final subs = (subsRaw is List ? subsRaw : const [])
        .whereType<Map>()
        .map(_PedsSubCategory.fromJson)
        .toList();
    return _PedsCategory(name: name, subCategories: subs);
  }
}

class _PedsSubCategory {
  final String name;
  final String dosage;
  final String frequency;
  final String mon;
  final String tue;
  final String wed;
  final String thu;
  final String fri;
  final String sat;
  final String sun;

  const _PedsSubCategory({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  static _PedsSubCategory fromJson(Map json) {
    return _PedsSubCategory(
      name: json['name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      mon: json['mon']?.toString() ?? '',
      tue: json['tue']?.toString() ?? '',
      wed: json['wed']?.toString() ?? '',
      thu: json['thu']?.toString() ?? '',
      fri: json['fri']?.toString() ?? '',
      sat: json['sat']?.toString() ?? '',
      sun: json['sun']?.toString() ?? '',
    );
  }
}
