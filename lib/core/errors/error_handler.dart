import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Central, single place that turns *anything* thrown into a typed
/// [AppException]. It never builds user-facing text; the UI resolves that
/// via `AppException.localized(l10n)`.
class ErrorHandler {
  ErrorHandler._();

  static const _messageKeys = ['message', 'error', 'detail'];

  static AppException handle(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        'Unhandled error',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return switch (error) {
      AppException() => error,
      DioException() => _fromDioException(error),
      FormatException() || TypeError() => const DataParsingException(),
      _ => const UnknownException(),
    };
  }

  static AppException _fromDioException(DioException error) {
    final inner = error.error;
    if (inner is AppException) return inner;

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout =>
      const TimeoutException(),
      DioExceptionType.connectionError ||
      DioExceptionType.unknown =>
      const NetworkException(),
      DioExceptionType.badCertificate =>
      const NetworkException(code: AppErrorCode.secureConnection),
      DioExceptionType.cancel =>
      const UnknownException(code: AppErrorCode.cancelled),
      DioExceptionType.badResponse => _fromStatusCode(
        error.response?.statusCode,
        error.response?.data,
      ),
    };
  }

  static AppException _fromStatusCode(int? code, dynamic data) {
    return switch (code) {
      400 || 422 => BadRequestException(
        serverMessage: _extractMessage(data),
        statusCode: code,
      ),
      401 || 403 => UnauthorizedException(statusCode: code),
      404 => const NotFoundException(),
      int c when c >= 500 => ServerException(statusCode: c),
      _ => UnknownException(statusCode: code),
    };
  }

  static String? _extractMessage(dynamic data) {
    if (data is String && data.isNotEmpty) return data;
    if (data is Map) {
      for (final key in _messageKeys) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
      }
    }
    return null;
  }
}