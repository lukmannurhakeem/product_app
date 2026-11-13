// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorSecureConnection =>
      'A secure connection could not be established.';

  @override
  String get errorCancelled => 'The request was cancelled.';

  @override
  String get errorBadRequest => 'Invalid request.';

  @override
  String get errorUnauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorParsing => 'We couldn\'t process the data received.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';
}
