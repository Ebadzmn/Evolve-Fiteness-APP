import 'package:fitness_app/core/config/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_app/core/coreWidget/dropdown_yes_no_tile.dart';
import 'package:fitness_app/core/coreWidget/dropdown_tile.dart';
import 'package:fitness_app/core/storage/token_storage.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/presentation/daily/controllers/daily_nutrition_controller.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:get/get.dart';

class DailyPages extends StatefulWidget {
  const DailyPages({super.key});

  @override
  State<DailyPages> createState() => _DailyPagesState();
}

class _DailyPagesState extends State<DailyPages> {
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _activityTimeController = TextEditingController();

  String get _formattedDate {
    final now = DateTime.now();
    return "${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _waterController.dispose();
    _activityTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(localizations.dailyTrackingTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                // Add action
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Color(0XFF1211E),
                child: SvgPicture.asset(AssetsPath.AbCalender),
              ),
            ),
          ),
        ],
      ),

      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.all(10.h),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
            children: [
              SizedBox(height: 12.h),
              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Color(0XFF101021),
                  color: Color(0XFF101021),
                  borderRadius: BorderRadius.circular(12.r),
                ),

                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formattedDate,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 27.h,
                        width: 74.w,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(89, 76, 154, 79),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white, width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            'Today',
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
              ),

              SizedBox(height: 12.h),

              weightcard(),
              SizedBox(height: 12.h),
              sleepcard(),
              SizedBox(height: 12.h),
              sickCard(),
              SizedBox(height: 12.h),

              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF101021),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AssetsPath.water),
                          SizedBox(width: 8.w),
                          Text(
                            'Water:',
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
                        controller: _waterController,
                        style: GoogleFonts.poppins(
                          color: Colors.white, // ← input text will be white
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Water (Lit)',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: const Color(0XFF0A0A1F),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      Text(
                        'At least 2.5 liters recommended.',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),
              EnergyWellBeingCard(),
              SizedBox(height: 12.h),
              TrainingCard(),
              SizedBox(height: 12.h),

              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0XFF101021),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AssetsPath.Clock),
                          SizedBox(width: 8.w),
                          Text(
                            'Activity Time:',
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
                        controller: _activityTimeController,
                        style: GoogleFonts.poppins(
                          color: Colors.white, // ← input text will be white
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'hh:mm',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: const Color(0XFF0A0A1F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              NutritionCard(),
              SizedBox(height: 12.h),
              if ((sl<TokenStorage>().getUserGender() ?? '').toLowerCase() ==
                  'female') ...[
                WomenCard(),
                SizedBox(height: 12.h),
              ],
              PedCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class sickCard extends StatelessWidget {
  const sickCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Color(0XFF101021),
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
                  'Sick:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SickOptions(),
          ],
        ),
      ),
    );
  }
}

class SickOptions extends StatefulWidget {
  const SickOptions({super.key});

  @override
  State<SickOptions> createState() => _SickOptionsState();
}

class _SickOptionsState extends State<SickOptions> {
  bool _isSick = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _circleOption(
          text: 'Yes',
          selected: _isSick,
          onTap: () => setState(() => _isSick = true),
        ),
        SizedBox(height: 12.h),
        _circleOption(
          text: 'No',
          selected: !_isSick,
          onTap: () => setState(() => _isSick = false),
        ),
      ],
    );
  }

  Widget _circleOption({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
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
}

class weightcard extends StatefulWidget {
  const weightcard({super.key});

  @override
  State<weightcard> createState() => _weightcardState();
}

class _weightcardState extends State<weightcard> {
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFF101021),
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
                  'Weight:',
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
              controller: _weightController,
              style: GoogleFonts.poppins(
                color: Colors.white, // ← input text will be white
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Weight (kg)',
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
            ),
          ],
        ),
      ),
    );
  }
}

class sleepcard extends StatefulWidget {
  const sleepcard({super.key});

  @override
  State<sleepcard> createState() => _sleepcardState();
}

class _sleepcardState extends State<sleepcard> {
  final TextEditingController _sleepDurationController =
      TextEditingController();
  double _sleepQuality = 4.0;

  @override
  void dispose() {
    _sleepDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFF101021),
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
                  'Sleep:',
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
              controller: _sleepDurationController,
              style: GoogleFonts.poppins(
                color: Colors.white, // ← input text will be white
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'hh:mm',
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
            ),

            SizedBox(height: 12.h),

            Row(
              children: [
                Text(
                  'Sleep Quality (1 - 10 )',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Spacer(),

                Container(
                  height: 20.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.green, width: 1.w),
                  ),
                  child: Center(
                    child: Text(
                      '${_sleepQuality.round()}',
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
            FullWidthSlider(
              value: _sleepQuality,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              onChanged: (v) => setState(() => _sleepQuality = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingCard extends StatefulWidget {
  const TrainingCard({super.key});

  @override
  State<TrainingCard> createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> {
  bool _trainingCompleted = false;
  bool _cardioCompleted = false;
  bool _planPullWorkout = false;
  bool _planPushFullbody = false;
  bool _planLegDayAdvanced = false;
  bool _planUpperBody = false;
  String _cardioType = 'Walking';
  final TextEditingController _durationCtrl = TextEditingController();

  @override
  void dispose() {
    _durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Training',
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
              title: 'Training Completed?',
              value: _trainingCompleted,
              onChanged: (v) => setState(() => _trainingCompleted = v),
            ),
            if (_trainingCompleted) ...[
              SizedBox(height: 12.h),
              _titledBox('Training Plan?'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _checkboxTile(
                      'Pull Workout',
                      _planPullWorkout,
                      (v) => setState(() => _planPullWorkout = v ?? false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _checkboxTile(
                      'Push Fullbody',
                      _planPushFullbody,
                      (v) => setState(() => _planPushFullbody = v ?? false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _checkboxTile(
                      'Leg Day Advanced',
                      _planLegDayAdvanced,
                      (v) => setState(() => _planLegDayAdvanced = v ?? false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _checkboxTile(
                      'Upper Body',
                      _planUpperBody,
                      (v) => setState(() => _planUpperBody = v ?? false),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: 'Cardio Completed?',
              value: _cardioCompleted,
              onChanged: (v) => setState(() => _cardioCompleted = v),
            ),

            SizedBox(height: 12.h),
            _titledBox('Cardio Type ?'),
            SizedBox(height: 12.h),
            _radioOption('Walking'),
            SizedBox(height: 8.h),
            _radioOption('Cycling'),

            SizedBox(height: 12.h),
            _durationField(),
          ],
        ),
      ),
    );
  }

  Widget _titledBox(String title) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _checkboxTile(
    String title,
    bool checked,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            onChanged: onChanged,
            side: const BorderSide(color: Colors.white54),
            checkColor: Colors.white,
            activeColor: Colors.green,
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(String label) {
    final selected = _cardioType == label;
    return InkWell(
      onTap: () => setState(() => _cardioType = label),
      child: Row(
        children: [
          Container(
            height: 16.h,
            width: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.green : Colors.transparent,
              border: Border.all(
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF0A0A1F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: _durationCtrl,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Duration  (Minutes)',
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
      ),
    );
  }
}

class WomenCard extends StatefulWidget {
  const WomenCard({super.key});

  @override
  State<WomenCard> createState() => _WomenCardState();
}

class _WomenCardState extends State<WomenCard> {
  String? _cyclePhase;
  double _pms = 6;
  double _cramps = 6;
  final Set<String> _symptoms = {};
  final TextEditingController _cycleDayCtrl = TextEditingController();

  @override
  void dispose() {
    _cycleDayCtrl.dispose();
    super.dispose();
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

  Widget _titledBox(String title) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              value: _cyclePhase,
              options: const [
                'Follicular',
                'Ovulation',
                'Luteal',
                'Menstruation',
              ],
              onChanged: (v) => setState(() => _cyclePhase = v),
              hint: 'Select Phase',
            ),
            SizedBox(height: 12.h),
            _titledBox(localizations.dailyWomenCycleDayTitle),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _cycleDayCtrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Day',
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
              ),
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
                _pillValue(_pms.round()),
              ],
            ),
            FullWidthSlider(
              value: _pms,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _pms = v),
              overlayColor: Colors.green.withOpacity(0.2),
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
                _pillValue(_cramps.round()),
              ],
            ),
            FullWidthSlider(
              value: _cramps,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _cramps = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),
            SizedBox(height: 12.h),
            DropdownMultiSelectTile(
              title: localizations.dailyWomenSymptomsTitle,
              selected: _symptoms,
              options: const [
                'Everything Fine',
                'Cramps',
                'Breast Tenderness',
                'Headache',
                'Acne',
                'Lower Back Pain',
                'Tiredness',
                'Cravings',
                'Sleepless',
                'Abdominal Pain',
                'Vaginal Itching',
                'Vaginal Dryness',
              ],
              onChanged: (s) => setState(
                () => _symptoms
                  ..clear()
                  ..addAll(s),
              ),
              hint: localizations.dailyWomenSelectSymptoms,
            ),
          ],
        ),
      ),
    );
  }
}

class PedCard extends StatefulWidget {
  const PedCard({super.key});

  @override
  State<PedCard> createState() => _PedCardState();
}

class _PedCardState extends State<PedCard> {
  bool _dailyDosageTaken = false;
  final _sideEffectsCtrl = TextEditingController();
  final _systolicCtrl = TextEditingController();
  final _diastolicCtrl = TextEditingController();
  final _restingHrCtrl = TextEditingController();
  final _glucoseCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _sideEffectsCtrl.dispose();
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    _restingHrCtrl.dispose();
    _glucoseCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'PED',
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
              title: 'Daily Dosage Taken',
              value: _dailyDosageTaken,
              onChanged: (v) => setState(() => _dailyDosageTaken = v),
            ),
            SizedBox(height: 12.h),
            Text(
              'Side Effects Notes',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _textArea(_sideEffectsCtrl, hint: 'Enter side effects...'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.bloodtype_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Blood Pressure (Everybody)',
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
                    'Systolic',
                    _systolicCtrl,
                    hint: 'Enter Systolic',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _labeledField(
                    'Diastolic',
                    _diastolicCtrl,
                    hint: 'Enter Diastolic',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _labeledField(
              'Resting Heart Rate',
              _restingHrCtrl,
              hint: 'Enter Heart Rate',
            ),
            SizedBox(height: 12.h),
            _labeledField('Blood Glucose', _glucoseCtrl, hint: 'Enter Glucose'),
            SizedBox(height: 12.h),
            Text(
              'Daily Notes',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _textArea(_notesCtrl, hint: 'Enter notes...'),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textArea(TextEditingController ctrl, {required String hint}) {
    return TextFormField(
      controller: ctrl,
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
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl, {
    String hint = 'Enter Value',
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
        TextFormField(
          controller: ctrl,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }
}

class NutritionCard extends StatelessWidget {
  const NutritionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      sl<DailyNutritionController>(),
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
                  'Nutrition',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // ── Nutrition Plan Dropdown ──
            Obx(() => _NutritionPlanDropdown(
              selectedPlan: controller.selectedPlan.value,
              plans: controller.plans,
              onChanged: controller.onPlanChanged,
            )),
            SizedBox(height: 12.h),

            // ── Macro Summary ──
            Obx(() => controller.isLoading.value
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : _MacroSummaryRow(
                    calories: controller.calories.value,
                    carbs: controller.carbs.value,
                    protein: controller.protein.value,
                    fats: controller.fats.value,
                  ),
            ),
            SizedBox(height: 12.h),

            // ── Manual Input Fields ──
            _NutritionInputFields(),
          ],
        ),
      ),
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
          value: (selectedPlan == null || selectedPlan!.isEmpty) ? null : selectedPlan,
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
              .map((plan) => DropdownMenuItem<String>(
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
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}


class _MacroSummaryRow extends StatelessWidget {
  final int calories;
  final double carbs;
  final double protein;
  final double fats;

  const _MacroSummaryRow({
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A1F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Column(
        children: [
          Text(
            'Macro Summary',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MacroItem(
                label: 'Calories',
                value: '$calories',
                unit: 'kcal',
                color: const Color(0xFF82C941),
                bgColor: const Color(0xFF1A2E1A),
              ),
              _MacroItem(
                label: 'Carbs',
                value: carbs.toStringAsFixed(1),
                unit: 'g',
                color: const Color(0xFF43A047),
                bgColor: const Color(0xFF1A2E1A),
              ),
              _MacroItem(
                label: 'Protein',
                value: protein.toStringAsFixed(1),
                unit: 'g',
                color: const Color(0xFF2287DD),
                bgColor: const Color(0xFF1A2536),
              ),
              _MacroItem(
                label: 'Fats',
                value: fats.toStringAsFixed(1),
                unit: 'g',
                color: const Color(0xFFFF6D00),
                bgColor: const Color(0xFF2E1F12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final Color bgColor;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50.r,
          width: 50.r,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$value$unit',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _NutritionInputFields extends StatefulWidget {
  const _NutritionInputFields();

  @override
  State<_NutritionInputFields> createState() => _NutritionInputFieldsState();
}

class _NutritionInputFieldsState extends State<_NutritionInputFields> {
  double _hunger = 6;
  double _digestion = 6;
  final TextEditingController _caloriesCtrl = TextEditingController();
  final TextEditingController _carbsCtrl = TextEditingController();
  final TextEditingController _proteinCtrl = TextEditingController();
  final TextEditingController _fatsCtrl = TextEditingController();
  final TextEditingController _saltCtrl = TextEditingController();

  @override
  void dispose() {
    _caloriesCtrl.dispose();
    _carbsCtrl.dispose();
    _proteinCtrl.dispose();
    _fatsCtrl.dispose();
    _saltCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
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

  Widget _filledInput(String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Calories'),
                  SizedBox(height: 8.h),
                  _filledInput('Enter (kcal)', _caloriesCtrl),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Carbs'),
                  SizedBox(height: 8.h),
                  _filledInput('Enter (g)', _carbsCtrl),
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
                  _label('Protein'),
                  SizedBox(height: 8.h),
                  _filledInput('Enter (g)', _proteinCtrl),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Fats'),
                  SizedBox(height: 8.h),
                  _filledInput('Enter (g)', _fatsCtrl),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _label('Hunger  (1-10)')),
            _pillValue(_hunger.round()),
          ],
        ),
        FullWidthSlider(
          value: _hunger,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _hunger = v),
          overlayColor: const Color.fromARGB(
            255,
            8,
            241,
            16,
          ).withOpacity(0.2),
        ),

        Row(
          children: [
            Expanded(child: _label('Digestion  (1-10)')),
            _pillValue(_digestion.round()),
          ],
        ),
        FullWidthSlider(
          value: _digestion,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (v) => setState(() => _digestion = v),
          overlayColor: Colors.green.withOpacity(0.2),
        ),

        SizedBox(height: 12.h),
        _label('Salt (g)'),
        SizedBox(height: 8.h),
        _filledInput('Enter Salt (g)', _saltCtrl),
      ],
    );
  }
}

class EnergyWellBeingCard extends StatefulWidget {
  const EnergyWellBeingCard({super.key});

  @override
  State<EnergyWellBeingCard> createState() => _EnergyWellBeingCardState();
}

class _EnergyWellBeingCardState extends State<EnergyWellBeingCard> {
  double _energy = 6;
  double _stress = 6;
  double _muscleSoreness = 6;
  double _mood = 6;
  double _motivation = 6;
  final TextEditingController _bodyTempCtrl = TextEditingController();

  @override
  void dispose() {
    _bodyTempCtrl.dispose();
    super.dispose();
  }

  Widget _labelWithValue(String label, int value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
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
            border: Border.all(color: Colors.green, width: 1.w),
          ),
          child: Center(
            child: Text(
              '$value',
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Energy & Well-Being',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            _labelWithValue('Energy Level (1-10)', _energy.round()),
            FullWidthSlider(
              value: _energy,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _energy = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),

            _labelWithValue('Stress Level (1-10)', _stress.round()),
            FullWidthSlider(
              value: _stress,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _stress = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),

            _labelWithValue('Muscle Soreness (1-10)', _muscleSoreness.round()),
            FullWidthSlider(
              value: _muscleSoreness,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _muscleSoreness = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),

            _labelWithValue('Mood (1-10)', _mood.round()),
            FullWidthSlider(
              value: _mood,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _mood = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),

            _labelWithValue('Motivation (1-10)', _motivation.round()),
            FullWidthSlider(
              value: _motivation,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() => _motivation = v),
              overlayColor: Colors.green.withOpacity(0.2),
            ),

            SizedBox(height: 12.h),
            Text(
              'Body Temperature',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _bodyTempCtrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Temp',
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
            ),
          ],
        ),
      ),
    );
  }
}
