import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_interceptors.dart';
import '../storage/token_storage.dart';
import '../session/session_manager.dart';

class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Map<String, dynamic>? defaultHeaders;

  NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.defaultHeaders,
  });
}

/// A comprehensive network client built on top of Dio.
/// Supports GET, POST, PUT, PATCH, DELETE and multipart uploads.
/// Includes automatic token injection and refresh logic via interceptors.
class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  final NetworkConfig _config;

  ApiClient({
    required NetworkConfig config,
    required TokenStorage tokenStorage,
    SessionManager? sessionManager,
    Future<String?> Function()? onRefreshToken,
  }) : _config = config,
       _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: _config.connectTimeout,
        receiveTimeout: _config.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?_config.defaultHeaders,
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_tokenStorage),
      TokenRefreshInterceptor(
        dio: _dio,
        sessionManager: sessionManager,
        onRefreshToken: onRefreshToken,
      ),
      LoggingInterceptor(),
    ]);
  }

  /// Performs a GET request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.get('/users', queryParameters: {'id': 1});
  /// ```
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Performs a POST request.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.post('/users', data: {'name': 'John'});
  /// ```
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Performs a PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Performs a PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Performs a DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Uploads a file using multipart form data.
  ///
  /// [file] The file to upload.
  /// [fieldName] The key name for the file in the form data.
  /// [additionalData] Optional extra fields to include in the request.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.uploadFile('/profile/avatar', file: File('path/to/img.png'), fieldName: 'avatar');
  /// ```
  Future<Response<T>> uploadFile<T>(
    String path, {
    required File file,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        ...?additionalData,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<MultipartFile> createMultipartFile(String path) async {
    return await MultipartFile.fromFile(path, filename: path.split('/').last);
  }
}
