class ApiUrls {
  // static const String baseUrl =
  //     'https://valium-bumper-towards-stands.trycloudflare.com/api/v1';
  static const String baseUrl = 'https://api.evolveapp.fit/api/v1';
  static const String loginUrl = '$baseUrl/auth/athlete/login';
  static const String updateFcmTokenUrl = '$baseUrl/auth/athlete/fcm-token';
  static const String updateProfileUrl = '$baseUrl/auth/athlete/profile';
  static const String dailyTrackingPost = '$baseUrl/daily/tracking';
  static const String dailyTrackingPut = '$baseUrl/daily/tracking';
  static const String dailyTrackingByDate = '$baseUrl/daily/tracking/by-date';
  static const String checkInDate = '$baseUrl/check-in/date';
  static const String checkInPost = '$baseUrl/check-in';
  static const String checkInQuestions = '$baseUrl/check-in/questions';
  static const String oldCheckInData = '$baseUrl/check-in/old-data';
  static const String checkInUser = '$baseUrl/check-in';
  static const String nutritionFood = '$baseUrl/food/nutrition';
  static const String exercise = '$baseUrl/exercise';
  static String exerciseById(String id) => '$baseUrl/exercise/$id';
  static const String trainingSplit = '$baseUrl/training/splite';
  static const String trackMeal = '$baseUrl/track/meal';
  static const String trackMealSuggestions = '$baseUrl/track/meal/suggestions';
  static const String water = '$baseUrl/water';
  static const String pedAppData = '$baseUrl/ped/app-data';
  static String pedByAthlete(String athleteId) => '$baseUrl/ped/$athleteId';
  static const String forgetPasswordUrl =
      '$baseUrl/auth/athlete/forget-password';
  static const String resetPasswordUrl = '$baseUrl/auth/athlete/reset-password';
  static const String verifyEmailUrl = '$baseUrl/auth/athlete/verify-email';
  static String athleteNotes(String athleteId) =>
      '$baseUrl/notes/athlete/$athleteId';
}
