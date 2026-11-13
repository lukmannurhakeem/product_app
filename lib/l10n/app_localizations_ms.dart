// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get errorNetwork =>
      'Tiada sambungan internet. Sila semak rangkaian anda dan cuba lagi.';

  @override
  String get errorTimeout =>
      'Permintaan mengambil masa terlalu lama. Sila cuba lagi.';

  @override
  String get errorSecureConnection =>
      'Sambungan selamat tidak dapat diwujudkan.';

  @override
  String get errorCancelled => 'Permintaan telah dibatalkan.';

  @override
  String get errorBadRequest => 'Permintaan tidak sah.';

  @override
  String get errorUnauthorized =>
      'Anda tidak dibenarkan melakukan tindakan ini.';

  @override
  String get errorNotFound => 'Sumber yang diminta tidak ditemui.';

  @override
  String get errorServer => 'Ralat pelayan. Sila cuba lagi nanti.';

  @override
  String get errorParsing => 'Data yang diterima tidak dapat diproses.';

  @override
  String get errorUnknown => 'Sesuatu telah berlaku. Sila cuba lagi.';
}
