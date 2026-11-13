import 'package:flutter/material.dart';
import 'package:product_app/core/errors/app_exception_l10n.dart';
import 'package:product_app/core/errors/error_handler.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/l10n/app_localizations.dart';

class SnackbarService {
  SnackbarService._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  /// Must be the same key passed to `MaterialApp.navigatorKey`. Its context
  /// sits below the app's Theme and Localizations.
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static void showError(
      Object error, {
        StackTrace? stackTrace,
        SnackBarAction? action,
        Duration duration = const Duration(seconds: 4),
      }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final exception = ErrorHandler.handle(error, stackTrace);
    final message = exception.localized(AppLocalizations.of(context));

    _show(message, _SnackType.error, action: action, duration: duration);
  }

  static void showSuccess(
      String message, {
        SnackBarAction? action,
        Duration duration = const Duration(seconds: 3),
      }) =>
      _show(message, _SnackType.success, action: action, duration: duration);

  static void showInfo(
      String message, {
        SnackBarAction? action,
        Duration duration = const Duration(seconds: 3),
      }) =>
      _show(message, _SnackType.info, action: action, duration: duration);

  static void hide() => scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

  static void _show(
      String message,
      _SnackType type, {
        required Duration duration,
        SnackBarAction? action,
      }) {
    final messenger = scaffoldMessengerKey.currentState;
    final context = navigatorKey.currentContext;
    if (messenger == null || context == null) return;

    final theme = Theme.of(context);
    final (background, foreground) = type.colors(theme.brightness);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(type.icon, color: foreground, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: background,
          action: action,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          showCloseIcon: action == null,
          closeIconColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
  }
}

enum _SnackType {
  error(Icons.error_outline),
  success(Icons.check_circle_outline),
  info(Icons.info_outline);

  const _SnackType(this.icon);

  final IconData icon;

  (Color background, Color foreground) colors(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = isLight ? AppColors.lightTheme : AppColors.darkTheme;

    return switch (this) {
      _SnackType.error => (scheme.error, scheme.onError),
      _SnackType.success => (AppColors.successFor(brightness), scheme.onSuccess),
      _SnackType.info => (AppColors.infoFor(brightness), scheme.onInfo),
    };
  }
}