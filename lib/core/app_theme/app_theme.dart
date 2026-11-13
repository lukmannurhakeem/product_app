import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';

class AppTheme {
  static ThemeData get lightTheme =>
      _build(AppColors.lightTheme, Brightness.light);

  static ThemeData get darkTheme =>
      _build(AppColors.darkTheme, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final textTheme = AppTopology.create().textTheme;
    final colorScheme = colors.toColorScheme(brightness);

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme.apply(
        bodyColor: colors.onBackground,
        displayColor: colors.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: colors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 4,
        shadowColor: colors.primary.withValues(alpha: 0.4),
        shape: LeftBottomBorder(
          side: BorderSide(color: colors.primary, width: 1.5),
          borderRadius: 12,
          fadeRadius: 60, // increase to fade more gradually, decrease for a tighter fade
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary.withOpacity(0.5),
          foregroundColor: colors.onPrimary.withOpacity(0.5),
          shadowColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.divider),
        ),
      ),
      dividerColor: colors.divider,
    );
  }
}

class LeftBottomBorder extends OutlinedBorder {
  const LeftBottomBorder({
    super.side = BorderSide.none,
    this.borderRadius = 12,
    this.fadeRadius = 60,
  });

  final double borderRadius;
  final double fadeRadius; // how far the color fades out from the corner

  @override
  LeftBottomBorder copyWith({
    BorderSide? side,
    double? borderRadius,
    double? fadeRadius,
  }) {
    return LeftBottomBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      fadeRadius: fadeRadius ?? this.fadeRadius,
    );
  }

  Path _borderPath(Rect rect) {
    final r = borderRadius;

    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left, rect.bottom - r)
      ..quadraticBezierTo(rect.left, rect.bottom, rect.left + r, rect.bottom)
      ..lineTo(rect.right, rect.bottom);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;

    final corner = Offset(rect.left, rect.bottom);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = ui.Gradient.radial(
        corner,
        fadeRadius,
        [side.color, side.color.withValues(alpha: 0)],
        [0.0, 1.0],
      );

    canvas.drawPath(_borderPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
}
