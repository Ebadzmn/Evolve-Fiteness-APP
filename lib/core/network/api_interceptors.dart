import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../storage/token_storage.dart';
import '../session/session_manager.dart';

final Logger _networkLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 90,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

const int _logChunkSize = 800;

void _logFullMessage(String message) {
  for (int i = 0; i < message.length; i += _logChunkSize) {
    final end = (i + _logChunkSize < message.length)
        ? i + _logChunkSize
        : message.length;
    debugPrintSynchronously(message.substring(i, end));
  }
}

String _prettyJson(dynamic value) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  } catch (_) {
    return value.toString();
  }
}

Map<String, dynamic> _serializeFormData(FormData formData) {
  return {
    'fields': {
      for (final field in formData.fields) field.key: field.value,
    },
    'files': [
      for (final file in formData.files)
        {
          'field': file.key,
          'filename': file.value.filename,
          'contentType': file.value.contentType?.toString(),
          'length': file.value.length,
        },
    ],
  };
}

String _stringifyForLog(dynamic value) {
  if (value == null) return 'null';
  if (value is FormData) {
    return _prettyJson(_serializeFormData(value));
  }
  if (value is Map || value is List) {
    return _prettyJson(value);
  }
  if (value is String) {
    return value;
  }
  try {
    return _prettyJson(value);
  } catch (_) {
    return value.toString();
  }
}

void _logSection(String title, dynamic value) {
  _logFullMessage('$title\n${_stringifyForLog(value)}');
}

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _networkLogger.i('➡️  ${options.method} ${options.uri}');
    _logSection('Headers:', options.headers);
    if (options.queryParameters.isNotEmpty) {
      _logSection('Query Parameters:', options.queryParameters);
    }
    if (options.data != null) {
      _logSection('Body:', options.data);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _networkLogger.i(
      '⬅️  ${response.statusCode} ${response.requestOptions.uri}',
    );
    _logSection('Response:', response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _networkLogger.e(
      '⛔ ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
    if (err.response?.data != null) {
      _logSection('Error Data:', err.response?.data);
    }
    super.onError(err, handler);
  }
}

class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final SessionManager? _sessionManager;
  final Future<String?> Function()? onRefreshToken;

  TokenRefreshInterceptor({
    required Dio dio,
    SessionManager? sessionManager,
    this.onRefreshToken,
  }) : _dio = dio,
       _sessionManager = sessionManager;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      if (onRefreshToken != null) {
        try {
          final newToken = await onRefreshToken!();
          if (newToken != null) {
            // Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          // Token refresh failed, force logout
          await _sessionManager?.forceLogout();
          return handler.next(err);
        }
      }
      // No refresh callback or refresh returned null, force logout
      await _sessionManager?.forceLogout();
    }
    super.onError(err, handler);
  }
}
