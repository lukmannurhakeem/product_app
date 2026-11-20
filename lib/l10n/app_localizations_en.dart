// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorNetwork => 'No internet connection.';

  @override
  String get errorNetworkDescription =>
      'Please check your network and try again.';

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

  @override
  String get productsTitle => 'Products';

  @override
  String get productsEmpty => 'No products available.';

  @override
  String get retry => 'Retry';

  @override
  String get productsEnd => 'End of products';

  @override
  String get searchHint => 'Search products';

  @override
  String get productsNoResults => 'No products found';

  @override
  String get removeFavourite => 'Remove from favourites';

  @override
  String get addFavourite => 'Add to favourites';

  @override
  String get productDescription => 'Description';

  @override
  String productInStock(int stock) {
    return '$stock in stock';
  }

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get wishlistTitle => 'Wish list';

  @override
  String get wishlistEmpty => 'Wish list is empty';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearRecentSearches => 'Clear';
}
