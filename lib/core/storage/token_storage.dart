import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _resetTokenKey = 'reset_token';
  static const String _userGenderKey = 'user_gender';
  static const String _userStatusKey = 'user_status';
  static const String _lastNotifiedNoteTimeKey = 'last_notified_note_time';

  // Check-in related keys
  static const String _lastCheckInUpdatedAtKey = 'lastCheckInUpdatedAt';
  static const String _nextCheckInDateKey = 'nextCheckInDate';
  static const String _cachedWeightKey = 'cached_weight';
  static const String _weeklyCheckInEntriesKey = 'weekly_checkin_entries';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  String? getAccessToken() {
    return _prefs.getString(_accessTokenKey);
  }

  String? getRefreshToken() {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveFcmToken(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
  }

  String? getFcmToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  Future<void> saveResetToken(String token) async {
    await _prefs.setString(_resetTokenKey, token);
  }

  String? getResetToken() {
    return _prefs.getString(_resetTokenKey);
  }

  Future<void> saveUserGender(String gender) async {
    await _prefs.setString(_userGenderKey, gender);
  }

  String? getUserGender() {
    return _prefs.getString(_userGenderKey);
  }

  Future<void> saveUserStatus(String status) async {
    await _prefs.setString(_userStatusKey, status);
  }

  String? getUserStatus() {
    return _prefs.getString(_userStatusKey);
  }

  Future<void> saveLastNotifiedNoteTime(String createdAt) async {
    await _prefs.setString(_lastNotifiedNoteTimeKey, createdAt);
  }

  String? getLastNotifiedNoteTime() {
    return _prefs.getString(_lastNotifiedNoteTimeKey);
  }

  Future<void> clearAll() async {
    // These keys are critical for session/check-in separation
    final keysToClear = [
      _accessTokenKey,
      _refreshTokenKey,
      _fcmTokenKey,
      _userGenderKey,
      _userStatusKey,
      _lastNotifiedNoteTimeKey,
      _lastCheckInUpdatedAtKey,
      _nextCheckInDateKey,
      _cachedWeightKey,
      _weeklyCheckInEntriesKey,
    ];

    for (final key in keysToClear) {
      await _prefs.remove(key);
    }
  }

  Future<void> clearTokens() async {
    await clearAll();
  }
}
