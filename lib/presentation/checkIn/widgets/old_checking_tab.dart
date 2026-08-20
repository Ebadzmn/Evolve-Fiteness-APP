import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/domain/entities/checkin_entities/old_check_in_entity.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

/// Read-only widget displaying old check-in data with the same design as CheckingTab.
class OldCheckingTab extends StatelessWidget {
  final OldCheckInEntity data;

  const OldCheckingTab({super.key, required this.data});

  String _formatFieldName(String key) {
    if (key.isEmpty) return '';
    final result = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }

  String _localizedMetricLabel(AppLocalizations localizations, String key) {
    switch (key) {
      case 'energyLevel':
        return localizations.checkInWellBeingEnergyLabel;
      case 'stressLevel':
        return localizations.checkInWellBeingStressLabel;
      case 'moodLevel':
        return localizations.checkInWellBeingMoodLabel;
      case 'sleepQuality':
        return localizations.checkInWellBeingSleepLabel;
      case 'hungerLevel':
        return localizations.checkInWellBeingHungerLabel;
      default:
        return _formatFieldName(key);
    }
  }

  String _localizedQuestionText(AppLocalizations localizations, String question) {
    switch (question.trim()) {
      case 'What went well this week?':
        return localizations.checkInQuestion1Title;
      case 'Challenges?':
        return localizations.checkInQuestion2Title;
      case 'What do we need to change, so you can achieve your goals EVEN better?':
      case 'What do we need to change, so you can achieve your goals even better?':
        return localizations.checkInQuestion3Title;
      case 'Something you want to tell me?':
        return localizations.checkInQuestion4Title;
      default:
        return question;
    }
  }

  String _localizedStatusText(AppLocalizations localizations, String status) {
    return status.toLowerCase() == 'completed'
        ? localizations.checkInStatusCompleted
        : localizations.checkInStatusPending;
  }

  String _normalizedMediaUrl(String url) {
    var u = url.trim();
    if (u.isEmpty) return u;

    const apiSegment = '/api/v1';

    if (u.startsWith('http://') || u.startsWith('https://')) {
      if (u.contains(apiSegment)) {
        u = u.replaceFirst(apiSegment, '');
      }
      return u;
    }

    var base = ApiUrls.baseUrl;
    if (base.contains(apiSegment)) {
      base = base.replaceFirst(apiSegment, '');
    }

    if (u.startsWith(apiSegment)) {
      u = u.substring(apiSegment.length);
    }

    if (!u.startsWith('/')) {
      u = '/$u';
    }

    return '$base$u';
  }

  Widget _summaryCard({
    required AppLocalizations localizations,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF69B427), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.white24, size: 18.sp),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF69B427).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: const Color(0xFF69B427),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      localizations.checkInSinceLastBadge,
                      style: TextStyle(
                        color: const Color(0xFF69B427),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelWithValue(String label, int value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 20.h,
            width: 30.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF69B427), width: 1.w),
            ),
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  color: const Color(0xFF69B427),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlySlider(int value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
          trackHeight: 4.h,
          activeTrackColor: const Color(0xFF69B427),
          inactiveTrackColor: const Color(0xFF2A2A3F),
          thumbColor: const Color(0xFF69B427),
          overlayColor: const Color(0xFF69B427).withValues(alpha: 0.2),
        ),
        child: Slider(
          value: value.toDouble().clamp(1, 10),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: null, // Read-only
        ),
      ),
    );
  }

  Widget _ynDisplay(
    AppLocalizations localizations,
    String title,
    bool value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: value
                  ? const Color(0xFF69B427).withValues(alpha: 0.2)
                  : const Color(0xFFB87333).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              value ? localizations.commonYes : localizations.commonNo,
              style: TextStyle(
                color: value
                    ? const Color(0xFF69B427)
                    : const Color(0xFFB87333),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textDisplay(
    AppLocalizations localizations,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: const Color(0xFF27303B),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            value.isNotEmpty ? value : localizations.profileEmpty,
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weight cards
        _summaryCard(
          localizations: localizations,
          icon: Icons.emoji_events_outlined,
          title: localizations.checkInCheckingCurrentWeightTitle,
          value: '${data.currentWeight} (kg)',
        ),
        _summaryCard(
          localizations: localizations,
          icon: Icons.percent,
          title: localizations.checkInCheckingAverageWeightTitle,
          value: '${data.averageWeight} (kg)',
        ),

        // Images/Media section
        if (data.image.isNotEmpty || data.media.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: const Color(0XFF101021),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.checkInUploadedMediaTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                if (data.image.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: data.image.map((url) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Container(
                            height: 70.h,
                            width: 70.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A3F),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                _normalizedMediaUrl(url),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white24,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (data.image.isNotEmpty && data.media.isNotEmpty)
                  SizedBox(height: 12.h),
                if (data.media.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.media.map((url) {
                      final fullUrl = _normalizedMediaUrl(url);
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3F),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.video_library,
                              color: Colors.white70,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                '${localizations.checkInCheckingVideoPlaceholderTitle}: $fullUrl',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],

        // Questions section
        Container(
          margin: EdgeInsets.only(top: 8.h),
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.checkInQuestionsAnswersTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              ...data.questionAndAnswer.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final qa = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q$idx . ${_localizedQuestionText(localizations, qa.question)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27303B),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        'A$idx. ${qa.answer.isNotEmpty ? qa.answer : localizations.commonNoAnswer}',
                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                );
              }),
            ],
          ),
        ),

        // Well-Being section
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(12.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.checkInWellBeingSectionTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ...data.wellBeing.metrics.entries.map((entry) {
                return Column(
                  children: [
                    _labelWithValue(
                      '${_localizedMetricLabel(localizations, entry.key)} (1-10)',
                      entry.value,
                    ),
                    _readOnlySlider(entry.value),
                  ],
                );
              }).toList(),
            ],
          ),
        ),

        // Nutrition section
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(12.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.checkInNutritionSectionTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              _labelWithValue(
                '${localizations.checkInNutritionDietLevelLabel} (1-10)',
                data.nutrition.dietLevel,
              ),
              _readOnlySlider(data.nutrition.dietLevel),
              _labelWithValue(
                '${localizations.checkInNutritionDigestionLabel} (1-10)',
                data.nutrition.digestionLevel,
              ),
              _readOnlySlider(data.nutrition.digestionLevel),
              if (data.nutrition.challengeDiet.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _textDisplay(
                  localizations,
                  localizations.checkInNutritionChallengeTitle,
                  data.nutrition.challengeDiet,
                ),
              ],
            ],
          ),
        ),

        // Training section
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(12.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.checkInTrainingSectionTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              _labelWithValue(
                '${localizations.checkInTrainingFeelStrengthLabel} (1-10)',
                data.training.feelStrength,
              ),
              _readOnlySlider(data.training.feelStrength),
              _labelWithValue(
                '${localizations.checkInTrainingPumpsLabel} (1-10)',
                data.training.pumps,
              ),
              _readOnlySlider(data.training.pumps),
              SizedBox(height: 12.h),
              if (data.trainingFeedback.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _textDisplay(
                  localizations,
                  localizations.checkInTrainingFeedbackTitle,
                  data.trainingFeedback,
                ),
              ],
            ],
          ),
        ),

        // Daily Notes section
        if (data.dailyNote.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0XFF101021),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.dailyNotesSectionTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: const Color(0XFF0A0A1F),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey, width: 1.w),
                  ),
                  child: Text(
                    data.dailyNote,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
