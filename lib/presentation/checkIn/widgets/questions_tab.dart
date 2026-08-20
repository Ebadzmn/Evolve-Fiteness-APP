import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:get/get.dart';

class CheckInQuestion {
  final String question;
  final bool isScale;
  final bool isMandatory;
  final RxBool status;
  final RxString answer;
  final RxDouble scaleValue;
  final TextEditingController? controller;

  CheckInQuestion({
    required this.question,
    this.isScale = false,
    this.isMandatory = false,
    String answer = '',
    double scaleValue = 0,
  }) : status = false.obs,
       answer = (isScale ? scaleValue.round().toString() : answer).obs,
       scaleValue = scaleValue.clamp(0.0, 10.0).toDouble().obs,
       controller = isScale ? null : TextEditingController(text: answer) {
    if (isScale) {
      status.value = true;
    } else {
      status.value = this.answer.value.trim().isNotEmpty;
    }
  }
}

class CheckInQuestionsController extends GetxController {
  final FakeCheckInRepository repository = sl<FakeCheckInRepository>();

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<CheckInQuestion> questionList = <CheckInQuestion>[].obs;

  // Dynamic Well-being state
  final RxMap<String, RxDouble> wellBeingMetrics = <String, RxDouble>{}.obs;

  // Athlete Note
  final RxString coachNote = ''.obs;
  final RxString athleteNote = ''.obs;
  late final TextEditingController noteController;

  @override
  void onInit() {
    super.onInit();
    noteController = TextEditingController();
    _loadDefaultWellBeing();
    _loadStaticQuestions();
    fetchCheckInUser();
  }

  void _loadDefaultWellBeing() {
    final defaults = {
      'energyLevel': 1.0,
      'stressLevel': 1.0,
      'moodLevel': 1.0,
      'sleepQuality': 1.0,
      'hungerLevel': 1.0,
    };
    wellBeingMetrics.clear();
    defaults.forEach((key, value) {
      wellBeingMetrics[key] = value.obs;
    });
  }

  void _loadStaticQuestions() {
    questionList.assignAll(<CheckInQuestion>[
      CheckInQuestion(question: 'What went well this week?', isMandatory: false),
      CheckInQuestion(question: 'Challenges?', isMandatory: false),
      CheckInQuestion(
        question:
            'What do we need to change, so you can achieve your goals EVEN better?',
        isMandatory: false,
      ),
      CheckInQuestion(question: 'Something you want to tell me?', isMandatory: false),
    ]);
  }

  Future<void> fetchCheckInUser() async {
    isLoading.value = true;
    try {
      final data = await repository.getCheckInUser();
      if (data != null) {
        // Use questions from API as the new "default", but keep answers empty
        if (data.questionAndAnswer.isNotEmpty) {
          questionList.assignAll(
            data.questionAndAnswer.map((e) {
              return CheckInQuestion(
                question: e.question,
                answer: '',
                isMandatory: e.status,
              );
            }).toList(),
          );
        }

        // Dynamic well-being metrics from API
        final apiMetrics = data.wellBeing.metrics;
        if (apiMetrics.isNotEmpty) {
          wellBeingMetrics.clear();
          apiMetrics.forEach((key, _) {
            // Adopt the key but ignore the value from API, reset to 1.0
            wellBeingMetrics[key] = 1.0.obs;
          });
        }
        
        // Update coachNote
        coachNote.value = data.coachNote;
        
        // Clear note (answers not pre-filled)
        athleteNote.value = '';
        noteController.text = '';
      }
    } catch (e) {
      debugPrint('Error fetching check-in user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setAnswer(CheckInQuestion q, String value) {
    if (q.isScale) return;
    q.answer.value = value;
    q.status.value = value.trim().isNotEmpty;
  }

  void setScale(CheckInQuestion q, double value) {
    if (!q.isScale) return;
    final v = value.clamp(0.0, 10.0).toDouble();
    q.scaleValue.value = v;
    q.answer.value = v.round().toString();
    q.status.value = true;
  }

  bool hasAnyEmptyAnswer() {
    for (final q in questionList) {
      if (q.isMandatory && !q.isScale && q.answer.value.trim().isEmpty) {
        return true;
      }
    }
    return false;
  }

  List<Map<String, String>> buildAnswersPayload() {
    return questionList
        .map(
          (q) => <String, String>{
            'question': q.question,
            'answer': q.answer.value,
          },
        )
        .toList();
  }

  @override
  void onClose() {
    for (final q in questionList) {
      q.controller?.dispose();
    }
    noteController.dispose();
    super.onClose();
  }
}

class QuestionsTab extends StatefulWidget {
  const QuestionsTab({super.key});

  @override
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab> {
  bool _showValidationErrors = false;
  late final CheckInQuestionsController _checkInQuestionsController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<CheckInQuestionsController>()) {
      _checkInQuestionsController = Get.find<CheckInQuestionsController>();
    } else {
      _checkInQuestionsController = Get.put(
        CheckInQuestionsController(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _formatFieldName(String key) {
    if (key.isEmpty) return '';
    // camelCase to space separated, capitalizing first letters
    final result = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }

  String _localizedQuestionText(
    AppLocalizations localizations,
    String question,
  ) {
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

  String _localizedMetricLabel(
    AppLocalizations localizations,
    String key,
  ) {
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

  Widget _titleValueItem({
    required String title,
    required Widget input,
    bool isMandatory = false,
    RxDouble? numericValue,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      if (isMandatory)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (numericValue != null)
                Obx(() {
                  final v = numericValue.value.round();
                  return Container(
                    height: 22.h,
                    width: 38.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFF69B427),
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$v',
                        style: TextStyle(
                          color: const Color(0xFF69B427),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
          SizedBox(height: 12.h),
          input,
        ],
      ),
    );
  }

  Widget _coachNoteSection(AppLocalizations localizations) {
    return Obx(() {
      final note = _checkInQuestionsController.coachNote.value;
      if (note.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF69B427).withOpacity(0.15),
              const Color(0XFF101021),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF69B427).withOpacity(0.3),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: const Color(0xFF69B427),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  localizations.checkInCoachFeedbackTitle,
                  style: TextStyle(
                    color: const Color(0xFF69B427),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              note,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _checkInQuestionsSection(AppLocalizations localizations) {
    return Obx(() {
      if (_checkInQuestionsController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF69B427)),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 0. Coach Feedback Section
          _coachNoteSection(localizations),

          // 1. Wellbeing Section (Dynamic Sliders)
          Obx(() => Column(
            children: _checkInQuestionsController.wellBeingMetrics.entries.map((entry) {
              return _titleValueItem(
                title: '${_localizedMetricLabel(localizations, entry.key)} (1-10)',
                numericValue: entry.value,
                input: Obx(() => FullWidthSlider(
                  value: entry.value.value,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (nv) => entry.value.value = nv,
                  overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                )),
              );
            }).toList(),
          )),

          // 2. Questions Section (from API)
          ..._checkInQuestionsController.questionList.map((q) {
            return _titleValueItem(
              title: _localizedQuestionText(localizations, q.question),
              isMandatory: q.isMandatory,
              input: q.isScale
              ? Obx(() => Column(
                  children: [
                    FullWidthSlider(
                      value: q.scaleValue.value,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (nv) => _checkInQuestionsController.setScale(q, nv),
                      overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                    ),
                  ],
                ))
              : TextFormField(
                controller: q.controller!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: localizations.commonAnswer,
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0XFF0A0A1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: _showValidationErrors && q.answer.value.trim().isEmpty
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: _showValidationErrors && q.answer.value.trim().isEmpty
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF69B427)),
                  ),
                ),
                onChanged: (v) => _checkInQuestionsController.setAnswer(q, v),
              ),
              numericValue: q.isScale ? q.scaleValue : null,
            );
          }),

          // 3. Athlete Note
          _titleValueItem(
            title: localizations.checkInAthleteNoteTitle,
            input: TextFormField(
              controller: _checkInQuestionsController.noteController,
              maxLines: 4,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: localizations.checkInAthleteNoteHint,
                hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Color(0xFF69B427)),
                ),
              ),
              onChanged: (v) => _checkInQuestionsController.athleteNote.value = v,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context)!;
        final data = state.data;
        if (data == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _checkInQuestionsSection(localizations),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.read<CheckInBloc>().add(
                      const CheckInStepSet(1),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF101021),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Color(0xFF2E2E5D)),
                      ),
                    ),
                    child: Text(
                      localizations.commonBack,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final bloc = context.read<CheckInBloc>();
                      final data = bloc.state.data;
                      if (data == null) return;

                      final questionsEmpty = _checkInQuestionsController
                          .hasAnyEmptyAnswer();

                      final hasEmpty = questionsEmpty;

                      if (hasEmpty) {
                        setState(() {
                          _showValidationErrors = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations
                                  .checkInValidationAnswerAllQuestionsBeforeContinuing,
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _showValidationErrors = false;
                      });

                      // Sync all dynamic well-being metrics to bloc data
                      _checkInQuestionsController.wellBeingMetrics.forEach((key, rxVal) {
                        bloc.add(WellBeingChanged(key, rxVal.value));
                      });
                      
                      bloc.add(AthleteNoteChanged(_checkInQuestionsController.athleteNote.value));

                      bloc.add(const CheckInStepSet(3));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1448),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Color(0xFF2E2E5D)),
                      ),
                    ),
                    child: Text(
                      localizations.commonNext,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}
