import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

// ============================================================
// APP COLORS
// ============================================================

class AppColors {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color divider;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.divider,
  });

  // ------------------------------------------------------------
  // LIGHT THEME — palette: #934761 / #AD5C71 / #72BAA9 / #D5E7B5
  // Background switched to white.
  // ------------------------------------------------------------
  const AppColors.light()
    : primary = const Color(0xFF2C3E50),
      onPrimary = const Color(0xFFFFFFFF),
      secondary = const Color(0xFF84B3CE),
      onSecondary = const Color(0xFFFFFFFF),
      background = const Color(0xFFFFFFFF),
      onBackground = const Color(0xFF2C2416),
      surface = Colors.white,
      onSurface = Colors.black,
      error = const Color(0xFFB00020),
      onError = Colors.white,
      success = const Color(0xFF72BAA9),
      onSuccess = Colors.white,
      warning = const Color(0xFFD5E7B5),
      onWarning = const Color(0xFF2C2416),
      info = const Color(0xFF72BAA9),
      onInfo = Colors.white,
      divider = Colors.grey;

  // ------------------------------------------------------------
  // DARK THEME — palette: #222831 / #393E46 / #948979 / #DFD0B8
  // ------------------------------------------------------------
  const AppColors.dark()
    : primary = const Color(0xFFDFD0B8),
      onPrimary = const Color(0xFF222831),
      secondary = const Color(0xFF948979),
      onSecondary = const Color(0xFF222831),
      background = const Color(0xFF222831),
      onBackground = const Color(0xFFDFD0B8),
      surface = const Color(0xFF393E46),
      onSurface = const Color(0xFFDFD0B8),
      error = const Color(0xFFB00020),
      onError = Colors.black,
      success = const Color(0xFF81C784),
      onSuccess = Colors.black,
      warning = const Color(0xFFFFD54F),
      onWarning = Colors.black,
      info = const Color(0xFF64B5F6),
      onInfo = Colors.black,
      divider = const Color(0xFF948979);

  static const AppColors lightTheme = AppColors.light();
  static const AppColors darkTheme = AppColors.dark();

  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color white54 = Colors.white54;
  static const Color black = Colors.black;

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  static AppColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightTheme
        : darkTheme;
  }

  static Color adaptive(
    Brightness brightness,
    Color lightColor,
    Color darkColor,
  ) {
    return brightness == Brightness.light ? lightColor : darkColor;
  }

  static Color primaryFor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTheme.primary
        : darkTheme.primary;
  }

  static Color surfaceFor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTheme.surface
        : darkTheme.surface;
  }

  static Color backgroundFor(Brightness brightness) {
    return brightness == Brightness.light
        ? lightTheme.background
        : darkTheme.background;
  }

  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: brightness == Brightness.light
          ? grey100
          : grey800,
      onSurfaceVariant: brightness == Brightness.light ? grey700 : grey300,
      outline: divider,
    );
  }

  static const Color successLight = Color(0xFF72BAA9);
  static const Color successDark = Color(0xFF81C784);
  static const Color warningLight = Color(0xFFD5E7B5);
  static const Color warningDark = Color(0xFFFFD54F);
  static const Color infoLight = Color(0xFF72BAA9);
  static const Color infoDark = Color(0xFF64B5F6);

  static Color successFor(Brightness brightness) {
    return brightness == Brightness.light ? successLight : successDark;
  }

  static Color warningFor(Brightness brightness) {
    return brightness == Brightness.light ? warningLight : warningDark;
  }

  static Color infoFor(Brightness brightness) {
    return brightness == Brightness.light ? infoLight : infoDark;
  }
}

// ============================================================
// APP SPACING
// ============================================================

class AppSpacing {
  final double xxs;
  final double xs;
  final double s;
  final double m;
  final double l;
  final double xl;
  final double xxl;

  const AppSpacing({
    this.xxs = 2.0,
    this.xs = 4.0,
    this.s = 8.0,
    this.m = 16.0,
    this.l = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  EdgeInsets get paddingXs => EdgeInsets.all(xs);

  EdgeInsets get paddingS => EdgeInsets.all(s);

  EdgeInsets get paddingM => EdgeInsets.all(m);

  EdgeInsets get paddingL => EdgeInsets.all(l);

  EdgeInsets get horizontalS => EdgeInsets.symmetric(horizontal: s);

  EdgeInsets get horizontalM => EdgeInsets.symmetric(horizontal: m);

  EdgeInsets get horizontalL => EdgeInsets.symmetric(horizontal: l);

  EdgeInsets get verticalS => EdgeInsets.symmetric(vertical: s);

  EdgeInsets get verticalM => EdgeInsets.symmetric(vertical: m);

  EdgeInsets get verticalL => EdgeInsets.symmetric(vertical: l);

  SizedBox get vXxs => SizedBox(height: xxs);

  SizedBox get vXs => SizedBox(height: xs);

  SizedBox get vS => SizedBox(height: s);

  SizedBox get vM => SizedBox(height: m);

  SizedBox get vL => SizedBox(height: l);

  SizedBox get vXl => SizedBox(height: xl);

  SizedBox get vXxl => SizedBox(height: xxl);

  SizedBox get hXxs => SizedBox(width: xxs);

  SizedBox get hXs => SizedBox(width: xs);

  SizedBox get hS => SizedBox(width: s);

  SizedBox get hM => SizedBox(width: m);

  SizedBox get hL => SizedBox(width: l);

  SizedBox get hXl => SizedBox(width: xl);

  SizedBox get hXxl => SizedBox(width: xxl);

  SizedBox vertical(double height) => SizedBox(height: height);

  SizedBox horizontal(double width) => SizedBox(width: width);

  SizedBox square(double size) => SizedBox(width: size, height: size);
}

// ============================================================
// APP TOPOLOGY (typography)
// ============================================================

class AppTopology {
  final TextTheme textTheme;

  const AppTopology({this.textTheme = const TextTheme()});

  factory AppTopology.create() {
    return AppTopology(
      textTheme: GoogleFonts.mulishTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          displayMedium: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400),
          headlineMedium: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BUILDCONTEXT EXTENSION — everything above, reachable via `context.`
// ============================================================

extension AppContextExtension on BuildContext {
  // ---- Colors / spacing / topology ----

  AppColors get colors => AppColors.of(this);

  AppSpacing get spacing => const AppSpacing();

  AppTopology get topology => AppTopology.create();

  // ---- Theme mode control (backed by ThemeProvider) ----

  ThemeMode get themeMode => watch<ThemeProvider>().themeMode;

  bool get isDarkMode => watch<ThemeProvider>().isDarkMode;

  Future<void> setThemeMode(ThemeMode mode) =>
      read<ThemeProvider>().setThemeMode(mode);

  Future<void> toggleTheme() => read<ThemeProvider>().toggleTheme();

  // ---- Platform detection (OS, web-safe) ----

  bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// OS-based check. For a screen-width breakpoint instead, see
  /// isMobileWidth below — a tablet in split-screen is isMobile == false
  /// but isMobileWidth == true.
  bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  bool get isWeb => kIsWeb;

  bool get isApple {
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  bool get isGoogle {
    if (kIsWeb) return true;
    return Platform.isAndroid;
  }

  bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  // ---- Responsive breakpoints (single scale: 600 / 1024) ----

  static const double _mobileMaxWidth = 600;
  static const double _tabletMaxWidth = 1024;

  bool get isMobileWidth => screenWidth < _mobileMaxWidth;

  bool get isTabletWidth =>
      screenWidth >= _mobileMaxWidth && screenWidth < _tabletMaxWidth;

  bool get isDesktopWidth => screenWidth >= _tabletMaxWidth;

  bool get useDesktopLayout => (isDesktop || isWeb) && isDesktopWidth;

  double get platformSpacing => (isDesktop || isWeb) ? 16.0 : 8.0;

  double get platformIconSize => (isDesktop || isWeb) ? 24.0 : 20.0;

  EdgeInsets get platformPadding =>
      EdgeInsets.all((isDesktop || isWeb) ? 16.0 : 12.0);

  // ---- SizedBox spacing shortcuts (delegate to AppSpacing) ----

  SizedBox get vXxs => spacing.vXxs;

  SizedBox get vXs => spacing.vXs;

  SizedBox get vS => spacing.vS;

  SizedBox get vM => spacing.vM;

  SizedBox get vL => spacing.vL;

  SizedBox get vXl => spacing.vXl;

  SizedBox get vXxl => spacing.vXxl;

  SizedBox get hXxs => spacing.hXxs;

  SizedBox get hXs => spacing.hXs;

  SizedBox get hS => spacing.hS;

  SizedBox get hM => spacing.hM;

  SizedBox get hL => spacing.hL;

  SizedBox get hXl => spacing.hXl;

  SizedBox get hXxl => spacing.hXxl;

  SizedBox vSpace(double height) => spacing.vertical(height);

  SizedBox hSpace(double width) => spacing.horizontal(width);

  SizedBox squareSpace(double size) => spacing.square(size);

  // ---- Common UI helpers ----

  Widget get shrinkBox => SizedBox.shrink();

  Widget get divider =>
      Divider(height: spacing.xs, thickness: 1, color: colors.primary);

  Widget get loadingIndicator => Center(
    child: CircularProgressIndicator(
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
    ),
  );

  EdgeInsets get paddingAll => spacing.paddingM;

  EdgeInsets get paddingHorizontal => spacing.horizontalM;

  EdgeInsets get paddingVertical => spacing.verticalM;

  // ---- Screen size / safe area ----

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get safeArea => MediaQuery.of(this).padding;

  double get statusBarHeight => safeArea.top;

  double get bottomBarHeight => safeArea.bottom;
}
