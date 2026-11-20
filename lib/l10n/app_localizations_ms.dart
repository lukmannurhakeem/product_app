// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get errorNetwork => 'Tiada sambungan internet.';

  @override
  String get errorNetworkDescription =>
      'Sila semak rangkaian anda dan cuba lagi.';

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

  @override
  String get productsTitle => 'Produk';

  @override
  String get productsEmpty => 'Tiada produk tersedia.';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get productsEnd => 'Produk tamat';

  @override
  String get searchHint => 'Carian produk';

  @override
  String get productsNoResults => 'Tiada produk dijumpai';

  @override
  String get removeFavourite => 'Buang daripada kegemaran';

  @override
  String get addFavourite => 'Tambah ke kegemaran';

  @override
  String get productDescription => 'Penerangan';

  @override
  String productInStock(int stock) {
    return '$stock dalam stok';
  }

  @override
  String get productOutOfStock => 'Tiada stok';

  @override
  String get wishlistTitle => 'Kegemaran';

  @override
  String get wishlistEmpty => 'Tiada kegemaran';

  @override
  String get recentSearches => 'Cari terakhir';

  @override
  String get clearRecentSearches => 'Padam';
}
