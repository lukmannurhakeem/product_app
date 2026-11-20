import 'package:flutter/material.dart';
import 'package:product_app/screens/product/product_screen.dart';
import 'package:product_app/screens/product/product_details_screen.dart';
import 'package:product_app/screens/route_not_found_screen.dart';
import 'package:product_app/screens/splash_screen.dart';
import 'package:product_app/screens/wishlist/wishlist_screen.dart';

/// To add a new screen:
///   1. Add a `static const String` route name below.
///   2. Add a matching `case` in [getBuilder].
///   3. Navigate with `locator<NavigationService>().navigateTo(NavigationRoutes.yourRoute)`.

class NavigationRoutes {
  NavigationRoutes._();

  static const String splash = '/splash';
  static const String productScreen = '/productScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String wishlistScreen = '/wishlistScreen';


  static WidgetBuilder getBuilder(String routeName, Object? arguments) {
    switch (routeName) {
      case splash:
        return (_) => const SplashScreen();

      case productScreen:
        return (_) => const ProductScreen();

      case productDetailsScreen:
        return (_) => const ProductDetailsScreen();

        case wishlistScreen:
          return (_) => const WishlistScreen();


      default:
        return (_) => const RouteNotFoundScreen();
    }
  }
}
