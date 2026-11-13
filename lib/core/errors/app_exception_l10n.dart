import 'package:product_app/l10n/app_localizations.dart';
import 'app_exception.dart';

extension AppExceptionL10n on AppException {
  String localized(AppLocalizations l10n) => switch (code) {
    AppErrorCode.network => l10n.errorNetwork,
    AppErrorCode.timeout => l10n.errorTimeout,
    AppErrorCode.secureConnection => l10n.errorSecureConnection,
    AppErrorCode.cancelled => l10n.errorCancelled,
    AppErrorCode.badRequest => serverMessage ?? l10n.errorBadRequest,
    AppErrorCode.unauthorized => l10n.errorUnauthorized,
    AppErrorCode.notFound => l10n.errorNotFound,
    AppErrorCode.server => l10n.errorServer,
    AppErrorCode.parsing => l10n.errorParsing,
    AppErrorCode.unknown => l10n.errorUnknown,
  };
}