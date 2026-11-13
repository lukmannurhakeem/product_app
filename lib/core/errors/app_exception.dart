enum AppErrorCode {
  network,
  timeout,
  secureConnection,
  cancelled,
  badRequest,
  unauthorized,
  notFound,
  server,
  parsing,
  unknown,
}

sealed class AppException implements Exception {
  const AppException({
    required this.code,
    this.serverMessage,
    this.statusCode,
  });

  final AppErrorCode code;

  /// Raw message from the backend. Only shown to the user for validation
  /// errors ([BadRequestException]); otherwise used for logging.
  final String? serverMessage;
  final int? statusCode;

  @override
  String toString() =>
      '$runtimeType(${code.name}, status: $statusCode, server: $serverMessage)';
}

final class NetworkException extends AppException {
  const NetworkException({super.code = AppErrorCode.network});
}

final class TimeoutException extends AppException {
  const TimeoutException() : super(code: AppErrorCode.timeout);
}

final class BadRequestException extends AppException {
  const BadRequestException({super.serverMessage, super.statusCode})
      : super(code: AppErrorCode.badRequest);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.statusCode})
      : super(code: AppErrorCode.unauthorized);
}

final class NotFoundException extends AppException {
  const NotFoundException() : super(code: AppErrorCode.notFound);
}

final class ServerException extends AppException {
  const ServerException({super.statusCode})
      : super(code: AppErrorCode.server);
}

final class DataParsingException extends AppException {
  const DataParsingException() : super(code: AppErrorCode.parsing);
}

final class UnknownException extends AppException {
  const UnknownException({super.code = AppErrorCode.unknown, super.statusCode});
}