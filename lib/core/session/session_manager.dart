import 'dart:async';
import 'package:flutter/material.dart';
import '../storage/token_storage.dart';

/// A singleton class that manages user session state globally.
/// Handles session expiration by clearing tokens and notifying listeners.
class SessionManager {
  static SessionManager? _instance;

  final TokenStorage _tokenStorage;
  final _sessionExpiredController = StreamController<void>.broadcast();

  /// Global navigator key for navigation from anywhere in the app.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  SessionManager._internal(this._tokenStorage);

  /// Factory constructor to get the singleton instance.
  factory SessionManager({required TokenStorage tokenStorage}) {
    _instance ??= SessionManager._internal(tokenStorage);
    return _instance!;
  }

  /// Stream that emits when session expires.
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  /// Call this when session expires (e.g., 401 error with no refresh possible).
  /// Clears tokens and notifies listeners to navigate to login.
  Future<void> forceLogout() async {
    await _tokenStorage.clearTokens();
    _sessionExpiredController.add(null);
  }

  /// Dispose the stream controller when no longer needed.
  void dispose() {
    _sessionExpiredController.close();
  }
}
