import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final ApiExceptionType type;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.type = ApiExceptionType.unknown,
  });

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout',
          type: ApiExceptionType.timeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Server error';

        if (data is Map && data.containsKey('message')) {
          message = data['message'];
        } else if (data is Map && data.containsKey('error')) {
          message = data['error'];
        }

        if (statusCode == 401) {
          return ApiException(
            message: message,
            statusCode: statusCode,
            data: data,
            type: ApiExceptionType.unauthorized,
          );
        } else if (statusCode == 403) {
          return ApiException(
            message: message,
            statusCode: statusCode,
            data: data,
            type: ApiExceptionType.forbidden,
          );
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          data: data,
          type: ApiExceptionType.server,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          type: ApiExceptionType.cancelled,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection',
          type: ApiExceptionType.network,
        );
      default:
        return ApiException(
          message: 'Unexpected error occurred',
          type: ApiExceptionType.unknown,
        );
    }
  }

  @override
  String toString() =>
      'ApiException: $message (Status: $statusCode, Type: $type)';
}

enum ApiExceptionType {
  network,
  server,
  timeout,
  unauthorized,
  forbidden,
  cancelled,
  unknown,
}
