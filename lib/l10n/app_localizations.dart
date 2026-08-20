import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fitness App'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get navTraining;

  /// No description provided for @navDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get navDaily;

  /// No description provided for @navNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get navNutrition;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAppBarTitle;

  /// No description provided for @loginHeadline.
  ///
  /// In en, this message translates to:
  /// **'Evolve today.'**
  String get loginHeadline;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgetPasswordAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPasswordAppBarTitle;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgetPasswordTitle;

  /// No description provided for @forgetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email or phone your account and we’ll send a code to reset your password'**
  String get forgetPasswordDescription;

  /// No description provided for @forgetPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgetPasswordEmailLabel;

  /// No description provided for @forgetPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgetPasswordEmailHint;

  /// No description provided for @forgetPasswordSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get forgetPasswordSending;

  /// No description provided for @forgetPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get forgetPasswordSendCode;

  /// No description provided for @forgetPasswordEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgetPasswordEmailRequired;

  /// No description provided for @dailyTrackingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Tracking'**
  String get dailyTrackingAppBarTitle;

  /// No description provided for @dailyTrackingError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get dailyTrackingError;

  /// No description provided for @dailyTrackingSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get dailyTrackingSaved;

  /// No description provided for @dailyTrackingNoDataForDate.
  ///
  /// In en, this message translates to:
  /// **'No data found for this date'**
  String get dailyTrackingNoDataForDate;

  /// No description provided for @dailyDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dailyDateLabel;

  /// No description provided for @dailyDateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dailyDateToday;

  /// No description provided for @dailyWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight:'**
  String get dailyWeightLabel;

  /// No description provided for @dailyWeightHint.
  ///
  /// In en, this message translates to:
  /// **'(kg)'**
  String get dailyWeightHint;

  /// No description provided for @dailySleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep:'**
  String get dailySleepLabel;

  /// No description provided for @dailySleepDurationHint.
  ///
  /// In en, this message translates to:
  /// **'08 : 30'**
  String get dailySleepDurationHint;

  /// No description provided for @dailySleepQualityLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep quality'**
  String get dailySleepQualityLabel;

  /// No description provided for @dailySickLabel.
  ///
  /// In en, this message translates to:
  /// **'Sick:'**
  String get dailySickLabel;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @dailyWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water:'**
  String get dailyWaterLabel;

  /// No description provided for @dailyWaterHint.
  ///
  /// In en, this message translates to:
  /// **'1.2 (Lit)'**
  String get dailyWaterHint;

  /// No description provided for @dailyWaterAdvice.
  ///
  /// In en, this message translates to:
  /// **'At least 2.5 liters recommended.'**
  String get dailyWaterAdvice;

  /// No description provided for @dailyEnergySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Energy & Well-Being'**
  String get dailyEnergySectionTitle;

  /// No description provided for @dailyEnergyLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy Level (1-10)'**
  String get dailyEnergyLevelLabel;

  /// No description provided for @dailyStressLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level (1-10)'**
  String get dailyStressLevelLabel;

  /// No description provided for @dailyMuscleSorenessLabel.
  ///
  /// In en, this message translates to:
  /// **'Muscle Soreness (1-10)'**
  String get dailyMuscleSorenessLabel;

  /// No description provided for @dailyMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood (1-10)'**
  String get dailyMoodLabel;

  /// No description provided for @dailyMotivationLabel.
  ///
  /// In en, this message translates to:
  /// **'Motivation (1-10)'**
  String get dailyMotivationLabel;

  /// No description provided for @dailyBodyTempLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Temperature'**
  String get dailyBodyTempLabel;

  /// No description provided for @dailyGenericTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type...'**
  String get dailyGenericTypeHint;

  /// No description provided for @trainingHistoryAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Training History'**
  String get trainingHistoryAppBarTitle;

  /// No description provided for @trainingHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please complete a training first. After that, the history will be added.'**
  String get trainingHistoryEmpty;

  /// No description provided for @coachAddedShortly.
  ///
  /// In en, this message translates to:
  /// **'No customized plan has been created for you yet.'**
  String get coachAddedShortly;

  /// No description provided for @trainingSplitAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Split'**
  String get trainingSplitAppBarTitle;

  /// No description provided for @dailyTrainingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get dailyTrainingSectionTitle;

  /// No description provided for @dailyTrainingCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Completed?'**
  String get dailyTrainingCompletedTitle;

  /// No description provided for @dailyTrainingPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Plan?'**
  String get dailyTrainingPlanTitle;

  /// No description provided for @dailyTrainingPlanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get dailyTrainingPlanPlaceholder;

  /// No description provided for @dailyTrainingPlanPushFullbody.
  ///
  /// In en, this message translates to:
  /// **'Push Fullbody'**
  String get dailyTrainingPlanPushFullbody;

  /// No description provided for @dailyTrainingPlanLegDayAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Leg Day Advanced'**
  String get dailyTrainingPlanLegDayAdvanced;

  /// No description provided for @dailyTrainingPlanPlan1.
  ///
  /// In en, this message translates to:
  /// **'Training plan 1'**
  String get dailyTrainingPlanPlan1;

  /// No description provided for @dailyCardioCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio Completed?'**
  String get dailyCardioCompletedTitle;

  /// No description provided for @dailyCardioTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Cardio Type ?'**
  String get dailyCardioTypeTitle;

  /// No description provided for @dailyCardioWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get dailyCardioWalking;

  /// No description provided for @dailyCardioCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get dailyCardioCycling;

  /// No description provided for @dailyCardioRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get dailyCardioRunning;

  /// No description provided for @dailyCardioSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get dailyCardioSwimming;

  /// No description provided for @dailyCardioRowing.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get dailyCardioRowing;

  /// No description provided for @dailyCardioHiking.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get dailyCardioHiking;

  /// No description provided for @dailyCardioJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump Rope'**
  String get dailyCardioJumpRope;

  /// No description provided for @dailyCardioCrosstrainer.
  ///
  /// In en, this message translates to:
  /// **'Crosstrainer'**
  String get dailyCardioCrosstrainer;

  /// No description provided for @dailyCardioStairmaster.
  ///
  /// In en, this message translates to:
  /// **'Stairmaster'**
  String get dailyCardioStairmaster;

  /// No description provided for @dailyCardioOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dailyCardioOther;

  /// No description provided for @dailyDurationHint.
  ///
  /// In en, this message translates to:
  /// **'Duration  (Minutes)'**
  String get dailyDurationHint;

  /// No description provided for @dailyActivityStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Steps:'**
  String get dailyActivityStepsLabel;

  /// No description provided for @dailyActivityStepsHint.
  ///
  /// In en, this message translates to:
  /// **'10000'**
  String get dailyActivityStepsHint;

  /// No description provided for @dailyNutritionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get dailyNutritionSectionTitle;

  /// No description provided for @dailyNutritionSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'Select Nutrition Plan'**
  String get dailyNutritionSelectPlan;

  /// No description provided for @dailyNutritionCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get dailyNutritionCaloriesLabel;

  /// No description provided for @dailyNutritionCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get dailyNutritionCarbsLabel;

  /// No description provided for @dailyNutritionProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get dailyNutritionProteinLabel;

  /// No description provided for @dailyNutritionFatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get dailyNutritionFatsLabel;

  /// No description provided for @dailyNutritionHungerLabel.
  ///
  /// In en, this message translates to:
  /// **'Hunger  (1-10)'**
  String get dailyNutritionHungerLabel;

  /// No description provided for @dailyNutritionDigestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Digestion  (1-10)'**
  String get dailyNutritionDigestionLabel;

  /// No description provided for @dailyNutritionSaltLabel.
  ///
  /// In en, this message translates to:
  /// **'Salt (g)'**
  String get dailyNutritionSaltLabel;

  /// No description provided for @dailyWomenSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get dailyWomenSectionTitle;

  /// No description provided for @dailyWomenCyclePhaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Phase?'**
  String get dailyWomenCyclePhaseTitle;

  /// No description provided for @dailyWomenCycleDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Day'**
  String get dailyWomenCycleDayTitle;

  /// No description provided for @dailyWomenPmsLabel.
  ///
  /// In en, this message translates to:
  /// **'PMS Symptoms (1-10)'**
  String get dailyWomenPmsLabel;

  /// No description provided for @dailyWomenCrampsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cramps  (1-10)'**
  String get dailyWomenCrampsLabel;

  /// No description provided for @dailyWomenSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get dailyWomenSymptomsTitle;

  /// No description provided for @dailyWomenSelectSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Select Symptoms'**
  String get dailyWomenSelectSymptoms;

  /// No description provided for @dailyPedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'PED'**
  String get dailyPedSectionTitle;

  /// No description provided for @dailyPedDosageTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Dosage Taken'**
  String get dailyPedDosageTitle;

  /// No description provided for @dailyPedSideEffectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Side Effects Notes'**
  String get dailyPedSideEffectsTitle;

  /// No description provided for @dailyBpSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get dailyBpSectionTitle;

  /// No description provided for @dailyBpSystolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get dailyBpSystolicLabel;

  /// No description provided for @dailyBpDiastolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get dailyBpDiastolicLabel;

  /// No description provided for @dailyBpRestingHrLabel.
  ///
  /// In en, this message translates to:
  /// **'Resting Heart Rate'**
  String get dailyBpRestingHrLabel;

  /// No description provided for @dailyBpGlucoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Glucose'**
  String get dailyBpGlucoseLabel;

  /// No description provided for @dailyNotesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Notes'**
  String get dailyNotesSectionTitle;

  /// No description provided for @dailySubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get dailySubmitButton;

  /// No description provided for @nutritionMenuPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Plan'**
  String get nutritionMenuPlanTitle;

  /// No description provided for @trainingPlanAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Plan'**
  String get trainingPlanAppBarTitle;

  /// No description provided for @trainingSplitHeaderDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get trainingSplitHeaderDay;

  /// No description provided for @trainingSplitHeaderWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get trainingSplitHeaderWork;

  /// No description provided for @nutritionMenuFoodItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Items'**
  String get nutritionMenuFoodItemsTitle;

  /// No description provided for @trainingExerciseGenericError.
  ///
  /// In en, this message translates to:
  /// **'Error loading items'**
  String get trainingExerciseGenericError;

  /// No description provided for @nutritionFoodItemsCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get nutritionFoodItemsCategoryAll;

  /// No description provided for @nutritionFoodItemsCategoryProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionFoodItemsCategoryProtein;

  /// No description provided for @nutritionFoodItemsCategoryCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutritionFoodItemsCategoryCarbs;

  /// No description provided for @nutritionFoodItemsCategoryFats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get nutritionFoodItemsCategoryFats;

  /// No description provided for @nutritionFoodItemsCategoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get nutritionFoodItemsCategoryFruits;

  /// No description provided for @nutritionFoodItemsCategorySupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get nutritionFoodItemsCategorySupplements;

  /// No description provided for @nutritionFoodItemsCategoryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get nutritionFoodItemsCategoryVegetables;

  /// No description provided for @nutritionFoodItemsEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy ({quantity})'**
  String nutritionFoodItemsEnergyLabel(String quantity);

  /// No description provided for @nutritionFoodItemsSatFatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sat. Fats'**
  String get nutritionFoodItemsSatFatsLabel;

  /// No description provided for @nutritionFoodItemsUnsatFatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Unsat. Fats'**
  String get nutritionFoodItemsUnsatFatsLabel;

  /// No description provided for @nutritionFoodItemsSugarLabel.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get nutritionFoodItemsSugarLabel;

  /// No description provided for @trainingExerciseAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get trainingExerciseAppBarTitle;

  /// No description provided for @trainingExerciseSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search exercises...'**
  String get trainingExerciseSearchHint;

  /// No description provided for @trainingAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get trainingAppBarTitle;

  /// No description provided for @trainingMenuExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get trainingMenuExercisesTitle;

  /// No description provided for @trainingMenuExercisesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all exercises'**
  String get trainingMenuExercisesSubtitle;

  /// No description provided for @trainingMenuPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Plan'**
  String get trainingMenuPlanTitle;

  /// No description provided for @trainingMenuPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your plan'**
  String get trainingMenuPlanSubtitle;

  /// No description provided for @trainingMenuHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get trainingMenuHistoryTitle;

  /// No description provided for @trainingMenuHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get trainingMenuHistorySubtitle;

  /// No description provided for @trainingMenuSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get trainingMenuSplitTitle;

  /// No description provided for @trainingMenuSplitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View split'**
  String get trainingMenuSplitSubtitle;

  /// No description provided for @profileAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileAppBarTitle;

  /// No description provided for @profileSectionStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get profileSectionStats;

  /// No description provided for @profileLabelWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get profileLabelWeight;

  /// No description provided for @profileLabelHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileLabelHeight;

  /// No description provided for @profileLabelFat.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get profileLabelFat;

  /// No description provided for @profileLabelMuscle.
  ///
  /// In en, this message translates to:
  /// **'Muscle Mass'**
  String get profileLabelMuscle;

  /// No description provided for @profileLabelTrainingDaySteps.
  ///
  /// In en, this message translates to:
  /// **'Training Steps'**
  String get profileLabelTrainingDaySteps;

  /// No description provided for @profileLabelRestDaySteps.
  ///
  /// In en, this message translates to:
  /// **'Rest Steps'**
  String get profileLabelRestDaySteps;

  /// No description provided for @profileLabelStepsSuffix.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get profileLabelStepsSuffix;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileLabelRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get profileLabelRole;

  /// No description provided for @profileLabelCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get profileLabelCoach;

  /// No description provided for @profileLabelMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profileLabelMemberSince;

  /// No description provided for @profileSectionShowInfo.
  ///
  /// In en, this message translates to:
  /// **'Show Info'**
  String get profileSectionShowInfo;

  /// No description provided for @profileLabelShowName.
  ///
  /// In en, this message translates to:
  /// **'Show Name'**
  String get profileLabelShowName;

  /// No description provided for @profileLabelShowDate.
  ///
  /// In en, this message translates to:
  /// **'Show Date'**
  String get profileLabelShowDate;

  /// No description provided for @profileLabelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileLabelLocation;

  /// No description provided for @profileLabelDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get profileLabelDivision;

  /// No description provided for @profileLabelCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get profileLabelCountdown;

  /// No description provided for @profileLabelDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profileLabelDaysSuffix;

  /// No description provided for @profileTimelineHeaderWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get profileTimelineHeaderWeek;

  /// No description provided for @profileTimelineHeaderDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get profileTimelineHeaderDate;

  /// No description provided for @profileTimelineHeaderPhase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get profileTimelineHeaderPhase;

  /// No description provided for @profileEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get profileEmpty;

  /// No description provided for @nutritionTrackPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Meal'**
  String get nutritionTrackPageTitle;

  /// No description provided for @nutritionTrackMealNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get nutritionTrackMealNameLabel;

  /// No description provided for @nutritionTrackMealNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Breakfast'**
  String get nutritionTrackMealNameHint;

  /// No description provided for @nutritionTrackFoodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get nutritionTrackFoodNameLabel;

  /// No description provided for @nutritionTrackFoodNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Chicken Breast'**
  String get nutritionTrackFoodNameHint;

  /// No description provided for @nutritionTrackFoodQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get nutritionTrackFoodQuantityLabel;

  /// No description provided for @nutritionTrackFoodQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100g'**
  String get nutritionTrackFoodQuantityHint;

  /// No description provided for @nutritionTrackTableFoodHeader.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get nutritionTrackTableFoodHeader;

  /// No description provided for @nutritionTrackTableQtyHeader.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get nutritionTrackTableQtyHeader;

  /// No description provided for @nutritionTrackTableCaloriesHeader.
  ///
  /// In en, this message translates to:
  /// **'Kcal'**
  String get nutritionTrackTableCaloriesHeader;

  /// No description provided for @nutritionTrackTableActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get nutritionTrackTableActionLabel;

  /// No description provided for @nutritionTrackNoItemsLogged.
  ///
  /// In en, this message translates to:
  /// **'No items logged'**
  String get nutritionTrackNoItemsLogged;

  /// No description provided for @nutritionTrackAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get nutritionTrackAddItem;

  /// No description provided for @nutritionTrackCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get nutritionTrackCancel;

  /// No description provided for @nutritionTrackAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Save Meal'**
  String get nutritionTrackAddMeal;

  /// No description provided for @nutritionTrackValidationMealRequired.
  ///
  /// In en, this message translates to:
  /// **'Meal name is required'**
  String get nutritionTrackValidationMealRequired;

  /// No description provided for @nutritionTrackTrainingDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Day'**
  String get nutritionTrackTrainingDayLabel;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profileLogoutMessage;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutConfirm;

  /// No description provided for @profileSectionPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get profileSectionPersonalData;

  /// No description provided for @profileLabelFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileLabelFullName;

  /// No description provided for @profileLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileLabelEmail;

  /// No description provided for @profileLabelGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileLabelGender;

  /// No description provided for @profileSectionAthleteInfo.
  ///
  /// In en, this message translates to:
  /// **'Athlete Info'**
  String get profileSectionAthleteInfo;

  /// No description provided for @profileLabelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profileLabelStatus;

  /// No description provided for @profileLabelCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get profileLabelCategory;

  /// No description provided for @profileLabelCheckInDay.
  ///
  /// In en, this message translates to:
  /// **'Check-in Day'**
  String get profileLabelCheckInDay;

  /// No description provided for @profileLabelAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileLabelAge;

  /// No description provided for @profileLabelAgeYearsSuffix.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get profileLabelAgeYearsSuffix;

  /// No description provided for @profileLabelGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profileLabelGoal;

  /// No description provided for @nutritionMenuSupplementTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get nutritionMenuSupplementTitle;

  /// No description provided for @nutritionMenuPedTitle.
  ///
  /// In en, this message translates to:
  /// **'PEDs'**
  String get nutritionMenuPedTitle;

  /// No description provided for @nutritionMenuPedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Enhancers'**
  String get nutritionMenuPedSubtitle;

  /// No description provided for @nutritionTodayMacrosTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Macros'**
  String get nutritionTodayMacrosTitle;

  /// No description provided for @nutritionMacroProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionMacroProteinLabel;

  /// No description provided for @nutritionMacroCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutritionMacroCarbsLabel;

  /// No description provided for @nutritionMacroFatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get nutritionMacroFatsLabel;

  /// No description provided for @nutritionMenuStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get nutritionMenuStatisticsTitle;

  /// No description provided for @nutritionSupplementsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Supplements'**
  String get nutritionSupplementsHeaderTitle;

  /// No description provided for @nutritionSupplementsTableName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nutritionSupplementsTableName;

  /// No description provided for @nutritionSupplementsTableDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get nutritionSupplementsTableDosage;

  /// No description provided for @nutritionSupplementsTableFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get nutritionSupplementsTableFrequency;

  /// No description provided for @nutritionSupplementsTableTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get nutritionSupplementsTableTime;

  /// No description provided for @nutritionSupplementsTablePurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get nutritionSupplementsTablePurpose;

  /// No description provided for @nutritionSupplementsTableBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get nutritionSupplementsTableBrand;

  /// No description provided for @nutritionSupplementsTableComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get nutritionSupplementsTableComment;

  /// No description provided for @nutritionSupplementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements added'**
  String get nutritionSupplementsEmpty;

  /// No description provided for @nutritionMenuTrackMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Meals'**
  String get nutritionMenuTrackMealsTitle;

  /// No description provided for @nutritionTrackDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get nutritionTrackDailyGoalTitle;

  /// No description provided for @nutritionTrackDailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calories and Macros'**
  String get nutritionTrackDailyGoalSubtitle;

  /// No description provided for @nutritionAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionAppBarTitle;

  /// No description provided for @nutritionMenuFoodItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search database'**
  String get nutritionMenuFoodItemsSubtitle;

  /// No description provided for @nutritionMenuPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View meal plan'**
  String get nutritionMenuPlanSubtitle;

  /// No description provided for @nutritionMenuTrackMealsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log your daily meals'**
  String get nutritionMenuTrackMealsSubtitle;

  /// No description provided for @nutritionMenuStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View progress'**
  String get nutritionMenuStatisticsSubtitle;

  /// No description provided for @checkInAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkInAppBarTitle;

  /// No description provided for @checkInStepProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get checkInStepProfile;

  /// No description provided for @checkInStepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get checkInStepPhotos;

  /// No description provided for @checkInStepQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get checkInStepQuestions;

  /// No description provided for @checkInStepChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get checkInStepChecking;

  /// No description provided for @checkInTabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly Check-in'**
  String get checkInTabWeekly;

  /// No description provided for @checkInTabOld.
  ///
  /// In en, this message translates to:
  /// **'Old Check-ins'**
  String get checkInTabOld;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @checkInNoPreviousFound.
  ///
  /// In en, this message translates to:
  /// **'No previous check-ins found.'**
  String get checkInNoPreviousFound;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkInLabel;

  /// No description provided for @checkInDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get checkInDateLabel;

  /// No description provided for @checkInDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get checkInDayLabel;

  /// No description provided for @checkInProfileCurrentWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get checkInProfileCurrentWeightTitle;

  /// No description provided for @checkInProfileAverageWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Average Weight'**
  String get checkInProfileAverageWeightTitle;

  /// No description provided for @checkInPhotosMultiFileInfo.
  ///
  /// In en, this message translates to:
  /// **'Select multiple photos'**
  String get checkInPhotosMultiFileInfo;

  /// No description provided for @checkInPhotosSelectFileLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Photos'**
  String get checkInPhotosSelectFileLabel;

  /// No description provided for @checkInPhotosSingleVideoInfo.
  ///
  /// In en, this message translates to:
  /// **'Select a single video'**
  String get checkInPhotosSingleVideoInfo;

  /// No description provided for @checkInPhotosVideoDropLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload Video'**
  String get checkInPhotosVideoDropLabel;

  /// No description provided for @checkInPhotosUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Successfully'**
  String get checkInPhotosUploadSuccess;

  /// No description provided for @commonUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get commonUpload;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @checkInSinceLastBadge.
  ///
  /// In en, this message translates to:
  /// **'Since Last Check-in'**
  String get checkInSinceLastBadge;

  /// No description provided for @checkInCheckingBasicDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Data'**
  String get checkInCheckingBasicDataTitle;

  /// No description provided for @checkInCheckingPicturesUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos Uploaded'**
  String get checkInCheckingPicturesUploadedLabel;

  /// No description provided for @checkInCheckingVideoUploadedLabel.
  ///
  /// In en, this message translates to:
  /// **'Video Uploaded'**
  String get checkInCheckingVideoUploadedLabel;

  /// No description provided for @checkInCheckingVideoPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get checkInCheckingVideoPlaceholderTitle;

  /// No description provided for @checkInCheckingVideoUploadedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Video uploaded'**
  String get checkInCheckingVideoUploadedSubtitle;

  /// No description provided for @checkInCheckingVideoDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No video uploaded'**
  String get checkInCheckingVideoDefaultSubtitle;

  /// No description provided for @checkInCheckingQuestionCountDescription.
  ///
  /// In en, this message translates to:
  /// **'Questions Answered'**
  String get checkInCheckingQuestionCountDescription;

  /// No description provided for @checkInQuestion1Title.
  ///
  /// In en, this message translates to:
  /// **'How was your week?'**
  String get checkInQuestion1Title;

  /// No description provided for @commonNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No Answer'**
  String get commonNoAnswer;

  /// No description provided for @checkInQuestion2Title.
  ///
  /// In en, this message translates to:
  /// **'Any issues?'**
  String get checkInQuestion2Title;

  /// No description provided for @checkInQuestion3Title.
  ///
  /// In en, this message translates to:
  /// **'What do we need to change, so you can achieve your goals even better?'**
  String get checkInQuestion3Title;

  /// No description provided for @checkInQuestion4Title.
  ///
  /// In en, this message translates to:
  /// **'Something you want to tell me?'**
  String get checkInQuestion4Title;

  /// No description provided for @checkInWellBeingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Well-Being'**
  String get checkInWellBeingSectionTitle;

  /// No description provided for @checkInWellBeingEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get checkInWellBeingEnergyLabel;

  /// No description provided for @checkInWellBeingStressLabel.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get checkInWellBeingStressLabel;

  /// No description provided for @checkInWellBeingMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get checkInWellBeingMoodLabel;

  /// No description provided for @checkInWellBeingSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get checkInWellBeingSleepLabel;

  /// No description provided for @checkInWellBeingHungerLabel.
  ///
  /// In en, this message translates to:
  /// **'Hunger'**
  String get checkInWellBeingHungerLabel;

  /// No description provided for @checkInNutritionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get checkInNutritionSectionTitle;

  /// No description provided for @checkInNutritionDietLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Diet Adherence'**
  String get checkInNutritionDietLevelLabel;

  /// No description provided for @checkInNutritionDigestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Digestion'**
  String get checkInNutritionDigestionLabel;

  /// No description provided for @checkInNutritionChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get checkInNutritionChallengeTitle;

  /// No description provided for @commonTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type here...'**
  String get commonTypeHint;

  /// No description provided for @checkInTrainingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get checkInTrainingSectionTitle;

  /// No description provided for @checkInTrainingFeelStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get checkInTrainingFeelStrengthLabel;

  /// No description provided for @checkInTrainingPumpsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pump'**
  String get checkInTrainingPumpsLabel;

  /// No description provided for @checkInTrainingCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Training Completed'**
  String get checkInTrainingCompletedLabel;

  /// No description provided for @checkInTrainingCardioCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Cardio Completed'**
  String get checkInTrainingCardioCompletedLabel;

  /// No description provided for @checkInTrainingFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get checkInTrainingFeedbackTitle;

  /// No description provided for @checkInAthleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Athlete Note'**
  String get checkInAthleteNoteTitle;

  /// No description provided for @checkInAthleteNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your note here...'**
  String get checkInAthleteNoteHint;

  /// No description provided for @commonAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get commonAnswer;

  /// No description provided for @checkInCheckingCurrentWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get checkInCheckingCurrentWeightTitle;

  /// No description provided for @checkInCheckingAverageWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Avg Weight'**
  String get checkInCheckingAverageWeightTitle;

  /// No description provided for @checkInSubmittingButton.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get checkInSubmittingButton;

  /// No description provided for @checkInAlreadySubmittedButton.
  ///
  /// In en, this message translates to:
  /// **'Already submitted'**
  String get checkInAlreadySubmittedButton;

  /// No description provided for @checkInValidationAnswerAllQuestionsBeforeSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions before submitting.'**
  String get checkInValidationAnswerAllQuestionsBeforeSubmitting;

  /// No description provided for @checkInValidationAnswerAllQuestionsBeforeContinuing.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions before continuing.'**
  String get checkInValidationAnswerAllQuestionsBeforeContinuing;

  /// No description provided for @checkInSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get checkInSubmittedSuccess;

  /// No description provided for @checkInStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get checkInStatusCompleted;

  /// No description provided for @checkInStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get checkInStatusPending;

  /// No description provided for @checkInPreviousButton.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get checkInPreviousButton;

  /// No description provided for @checkInNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get checkInNextButton;

  /// No description provided for @checkInLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get checkInLoadingLabel;

  /// No description provided for @checkInUploadedMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Photos/Videos'**
  String get checkInUploadedMediaTitle;

  /// No description provided for @checkInQuestionsAnswersTitle.
  ///
  /// In en, this message translates to:
  /// **'Questions & Answers'**
  String get checkInQuestionsAnswersTitle;

  /// No description provided for @checkInCoachFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach Feedback'**
  String get checkInCoachFeedbackTitle;

  /// No description provided for @dailyTrainingNoPlan.
  ///
  /// In en, this message translates to:
  /// **'No Training plan add here'**
  String get dailyTrainingNoPlan;

  /// No description provided for @applyHereText.
  ///
  /// In en, this message translates to:
  /// **'Not part of coaching program? Apply Here'**
  String get applyHereText;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @coachComment.
  ///
  /// In en, this message translates to:
  /// **'Coach Comment'**
  String get coachComment;

  /// No description provided for @noExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found for this training plan.'**
  String get noExercisesFound;

  /// No description provided for @noExercisesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No Exercises'**
  String get noExercisesSubtitle;

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get setLabel;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get repsLabel;

  /// No description provided for @rirLabel.
  ///
  /// In en, this message translates to:
  /// **'RIR'**
  String get rirLabel;

  /// No description provided for @noSetsDefined.
  ///
  /// In en, this message translates to:
  /// **'No sets defined for this exercise.'**
  String get noSetsDefined;

  /// No description provided for @exercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Exercise} other{{count} Exercises}}'**
  String exercisesCount(int count);

  /// No description provided for @exerciseDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseDetailTitle;

  /// No description provided for @errorLoadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error loading video'**
  String get errorLoadingVideo;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get filterNeck;

  /// No description provided for @filterBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get filterBack;

  /// No description provided for @filterArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get filterArms;

  /// No description provided for @filterCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get filterCore;

  /// No description provided for @filterLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get filterLegs;

  /// No description provided for @filterShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get filterShoulders;

  /// No description provided for @filterChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get filterChest;

  /// No description provided for @filterTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get filterTriceps;

  /// No description provided for @filterBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get filterBiceps;

  /// No description provided for @filterLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower Back'**
  String get filterLowerBack;

  /// No description provided for @filterGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get filterGlutes;

  /// No description provided for @filterQuadriceps.
  ///
  /// In en, this message translates to:
  /// **'Quadriceps'**
  String get filterQuadriceps;

  /// No description provided for @filterHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get filterHamstrings;

  /// No description provided for @filterCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get filterCalves;

  /// No description provided for @filterOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get filterOther;

  /// No description provided for @noExercisesInPlan.
  ///
  /// In en, this message translates to:
  /// **'No exercises in this plan'**
  String get noExercisesInPlan;

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @changeExercise.
  ///
  /// In en, this message translates to:
  /// **'Change Exercise'**
  String get changeExercise;

  /// No description provided for @searchExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'Search exercise...'**
  String get searchExerciseHint;

  /// No description provided for @noExerciseFound.
  ///
  /// In en, this message translates to:
  /// **'No exercise found'**
  String get noExerciseFound;

  /// No description provided for @timerRunning.
  ///
  /// In en, this message translates to:
  /// **'Running...'**
  String get timerRunning;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start!'**
  String get timerStart;

  /// No description provided for @timerHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get timerHours;

  /// No description provided for @timerMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get timerMinutes;

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get timerSeconds;

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Set} other{{count} Sets}}'**
  String setsCount(int count);

  /// No description provided for @setsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get setsLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @exerciseNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Notes'**
  String get exerciseNotesTitle;

  /// No description provided for @exerciseNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes for {exerciseName}...'**
  String exerciseNotesHint(String exerciseName);

  /// No description provided for @workoutNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get workoutNotesTitle;

  /// No description provided for @workoutNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add your workout notes here...'**
  String get workoutNotesHint;

  /// No description provided for @buttonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get buttonBack;

  /// No description provided for @buttonComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get buttonComplete;

  /// No description provided for @previousWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Previous Workout'**
  String get previousWorkoutTitle;

  /// No description provided for @noPreviousWorkoutRecords.
  ///
  /// In en, this message translates to:
  /// **'No previous records for this plan.'**
  String get noPreviousWorkoutRecords;

  /// No description provided for @setsBestSetLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets / Best Set'**
  String get setsBestSetLabel;

  /// No description provided for @bestSetPrefix.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestSetPrefix;

  /// No description provided for @atLabel.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get atLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @oneWorkout.
  ///
  /// In en, this message translates to:
  /// **'1 Workout'**
  String get oneWorkout;

  /// No description provided for @profileCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profileCamera;

  /// No description provided for @profileGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profileGallery;

  /// No description provided for @authFillBothPasswordFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in both password fields'**
  String get authFillBothPasswordFields;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authCreateNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get authCreateNewPassword;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get authEnterNewPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authReEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get authReEnterNewPassword;

  /// No description provided for @authOtpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get authOtpVerification;

  /// No description provided for @authCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckYourEmail;

  /// No description provided for @authOtp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get authOtp;

  /// No description provided for @authEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get authEnterOtp;

  /// No description provided for @authPleaseEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP'**
  String get authPleaseEnterOtp;

  /// No description provided for @dailyTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Tracking'**
  String get dailyTrackingTitle;

  /// No description provided for @dailyEnterWaterLit.
  ///
  /// In en, this message translates to:
  /// **'Enter Water (Lit)'**
  String get dailyEnterWaterLit;

  /// No description provided for @dailyEnterWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Enter Weight (kg)'**
  String get dailyEnterWeightKg;

  /// No description provided for @dailyTrainingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Training Completed?'**
  String get dailyTrainingCompleted;

  /// No description provided for @dailyCardioCompleted.
  ///
  /// In en, this message translates to:
  /// **'Cardio Completed?'**
  String get dailyCardioCompleted;

  /// No description provided for @dailyDosageTaken.
  ///
  /// In en, this message translates to:
  /// **'Daily Dosage Taken'**
  String get dailyDosageTaken;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get dailyCalories;

  /// No description provided for @dailyCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get dailyCarbs;

  /// No description provided for @dailyProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get dailyProtein;

  /// No description provided for @dailyFats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get dailyFats;

  /// No description provided for @dailyEnterTemp.
  ///
  /// In en, this message translates to:
  /// **'Enter Temp'**
  String get dailyEnterTemp;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @pedsDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get pedsDosage;

  /// No description provided for @pedsFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get pedsFrequency;

  /// No description provided for @pedsMo.
  ///
  /// In en, this message translates to:
  /// **'MO'**
  String get pedsMo;

  /// No description provided for @pedsTue.
  ///
  /// In en, this message translates to:
  /// **'TUE'**
  String get pedsTue;

  /// No description provided for @pedsWed.
  ///
  /// In en, this message translates to:
  /// **'WED'**
  String get pedsWed;

  /// No description provided for @pedsThu.
  ///
  /// In en, this message translates to:
  /// **'THU'**
  String get pedsThu;

  /// No description provided for @pedsFri.
  ///
  /// In en, this message translates to:
  /// **'FRI'**
  String get pedsFri;

  /// No description provided for @pedsSat.
  ///
  /// In en, this message translates to:
  /// **'SAT'**
  String get pedsSat;

  /// No description provided for @pedsSun.
  ///
  /// In en, this message translates to:
  /// **'SUN'**
  String get pedsSun;

  /// No description provided for @supplementProductLink.
  ///
  /// In en, this message translates to:
  /// **'Product Link'**
  String get supplementProductLink;

  /// No description provided for @nutritionWaterGoal.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get nutritionWaterGoal;

  /// No description provided for @nutritionEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get nutritionEnterAmount;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get notificationRecent;

  /// No description provided for @notificationNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get notificationNoteTitle;

  /// No description provided for @notificationCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get notificationCloseButton;

  /// No description provided for @notificationFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get notificationFailedToLoad;

  /// No description provided for @notificationNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get notificationNoNotifications;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
