import 'dart:async';

import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';
import 'package:product_app/core/navigation/navigation_route.dart';
import 'package:product_app/core/navigation/navigation_service.dart';

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    this.animationDuration = const Duration(milliseconds: 1800),
    this.idleDuration = const Duration(milliseconds: 2400),
    this.logoAssetPath = 'assets/images/logo.png',
  });

  /// Entrance animation (plays once).
  final Duration animationDuration;

  /// One half-cycle of the idle movement that loops while loading.
  final Duration idleDuration;
  final String logoAssetPath;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Duration _settleDuration = Duration(milliseconds: 400);

  late final AnimationController _controller; // entrance
  late final AnimationController _idle; // loops while loading
  late final Future<void> _animationDone;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _idle = AnimationController(vsync: this, duration: widget.idleDuration);

    _animationDone = _controller.forward();
    _animationDone.then((_) {
      if (mounted && _isLoading) _idle.repeat(reverse: true);
    });

    // Start the work after the first frame so the animation is already running.
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    await Future.wait([
      _animationDone,
    ]);

    _isLoading = false;
    if (!mounted) return;

    await _idle.animateTo(0, duration: _settleDuration, curve: Curves.easeOut);
    _goNext();
  }

  void _goNext() {
    if (!mounted) return;

    // locator<NavigationService>().navigateToAndRemoveUntil(
    //    NavigationRoutes.loginScreen,
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSplashBackground(animation: _controller, idle: _idle),
          Center(
            child: AnimatedSplashLogo(
              animation: _controller,
              assetPath: widget.logoAssetPath,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKGROUND
// ============================================================

class AnimatedSplashBackground extends StatelessWidget {
  const AnimatedSplashBackground({
    super.key,
    required this.animation,
    required this.idle,
  });

  final Animation<double> animation;
  final Animation<double> idle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final soft = Color.lerp(colors.background, colors.secondary, 0.35)!;
    final muted = colors.secondary;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: colors.background), // base background
        TopLightShape(animation: animation, idle: idle, color: soft),
        TopRightShape(animation: animation, idle: idle, color: muted),
        BottomLeftShape(animation: animation, idle: idle, color: soft),
        BottomShape(animation: animation, idle: idle, color: muted),
      ],
    );
  }
}

// ============================================================
// SHARED SHAPE WRAPPER
// ============================================================

/// Wraps one painter with its own entrance (slide + fade + rotation).
/// After the entrance, [idle] (0 → 1, looping) drives the painter's movement.
class AnimatedSplashShape extends StatefulWidget {
  const AnimatedSplashShape({
    super.key,
    required this.animation,
    required this.idle,
    required this.entrance,
    required this.beginOffset,
    required this.painterBuilder,
    this.beginRotation = 0,
    this.rotationAlignment = Alignment.center,
  });

  final Animation<double> animation;
  final Animation<double> idle;
  final Interval entrance;

  /// Start offset as a fraction of the shape's size.
  final Offset beginOffset;
  final double beginRotation;
  final Alignment rotationAlignment;

  /// Receives the eased idle value (0 → 1).
  final CustomPainter Function(double idle) painterBuilder;

  @override
  State<AnimatedSplashShape> createState() => _AnimatedSplashShapeState();
}

class _AnimatedSplashShapeState extends State<AnimatedSplashShape> {
  late final CurvedAnimation _entrance;
  late final CurvedAnimation _idleCurve;

  @override
  void initState() {
    super.initState();
    _entrance = CurvedAnimation(
      parent: widget.animation,
      curve: widget.entrance,
    );
    _idleCurve = CurvedAnimation(parent: widget.idle, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _idleCurve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.animation, widget.idle]),
        builder: (context, _) {
          final t = _entrance.value;
          final inv = 1 - t;
          return Opacity(
            opacity: t,
            child: FractionalTranslation(
              translation: widget.beginOffset * inv,
              child: Transform.rotate(
                angle: widget.beginRotation * inv,
                alignment: widget.rotationAlignment,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: widget.painterBuilder(_idleCurve.value),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// SHAPE WIDGETS
// ============================================================

class TopLightShape extends StatelessWidget {
  const TopLightShape({
    super.key,
    required this.animation,
    required this.idle,
    required this.color,
  });

  final Animation<double> animation;
  final Animation<double> idle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashShape(
      animation: animation,
      idle: idle,
      entrance: const Interval(0.11, 0.44, curve: Curves.easeInOut),
      beginOffset: const Offset(0, -0.08),
      painterBuilder: (p) => TopLightShapePainter(progress: p, color: color),
    );
  }
}

class TopRightShape extends StatelessWidget {
  const TopRightShape({
    super.key,
    required this.animation,
    required this.idle,
    required this.color,
  });

  final Animation<double> animation;
  final Animation<double> idle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashShape(
      animation: animation,
      idle: idle,
      entrance: const Interval(0.11, 0.44, curve: Curves.easeInOut),
      beginOffset: const Offset(0.10, -0.08),
      beginRotation: 0.12,
      rotationAlignment: Alignment.topRight,
      painterBuilder: (p) => TopRightShapePainter(progress: p, color: color),
    );
  }
}

class BottomLeftShape extends StatelessWidget {
  const BottomLeftShape({
    super.key,
    required this.animation,
    required this.idle,
    required this.color,
  });

  final Animation<double> animation;
  final Animation<double> idle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashShape(
      animation: animation,
      idle: idle,
      entrance: const Interval(0.14, 0.50, curve: Curves.easeInOut),
      beginOffset: const Offset(-0.08, 0.06),
      painterBuilder: (p) => BottomLeftShapePainter(progress: p, color: color),
    );
  }
}

class BottomShape extends StatelessWidget {
  const BottomShape({
    super.key,
    required this.animation,
    required this.idle,
    required this.color,
  });

  final Animation<double> animation;
  final Animation<double> idle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashShape(
      animation: animation,
      idle: idle,
      entrance: const Interval(0.14, 0.50, curve: Curves.easeInOut),
      beginOffset: const Offset(0, 0.08),
      painterBuilder: (p) => BottomShapePainter(progress: p, color: color),
    );
  }
}

// ============================================================
// LOGO
// ============================================================

class AnimatedSplashLogo extends StatelessWidget {
  const AnimatedSplashLogo({
    super.key,
    required this.animation,
    required this.assetPath,
    this.width,
  });

  final Animation<double> animation;
  final String assetPath;

  /// Defaults to 40% of the available width, clamped to 120–240.
  final double? width;

  static const _curve = Interval(0.28, 0.67, curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final curve = CurveTween(curve: _curve);

    return LayoutBuilder(
      builder: (context, constraints) {
        final logoWidth =
            width ?? (constraints.maxWidth * 0.4).clamp(120.0, 240.0);

        return RepaintBoundary(
          child: FadeTransition(
            opacity: animation.drive(curve),
            child: SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).chain(curve),
              ),
              child: ScaleTransition(
                scale: animation.drive(
                  Tween<double>(begin: 0.90, end: 1.0).chain(curve),
                ),
                child: Image.asset(assetPath, width: logoWidth),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// PAINTERS  (progress = idle movement, 0 → 1)
// ============================================================

class TopLightShapePainter extends CustomPainter {
  const TopLightShapePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final n = progress * h * 0.02;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.10)
      ..cubicTo(
        w * 0.80,
        h * 0.20 + n,
        w * 0.55,
        h * 0.06 - n,
        w * 0.35,
        h * 0.14,
      )
      ..cubicTo(w * 0.18, h * 0.20 + n, w * 0.08, h * 0.18, 0, h * 0.24)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(TopLightShapePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class TopRightShapePainter extends CustomPainter {
  const TopRightShapePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final n = progress * w * 0.03;

    final path = Path()
      ..moveTo(w * 0.55, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.36)
      ..cubicTo(
        w * 0.88 - n,
        h * 0.36,
        w * 0.80 - n,
        h * 0.20,
        w * 0.70,
        h * 0.12,
      )
      ..cubicTo(w * 0.64, h * 0.07, w * 0.62, h * 0.03, w * 0.55, 0)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(TopRightShapePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class BottomLeftShapePainter extends CustomPainter {
  const BottomLeftShapePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final n = progress * w * 0.03;

    final path = Path()
      ..moveTo(0, h * 0.64)
      ..cubicTo(
        w * 0.20 + n,
        h * 0.62,
        w * 0.34 + n,
        h * 0.74,
        w * 0.52,
        h * 0.84,
      )
      ..cubicTo(w * 0.62, h * 0.90, w * 0.70, h * 0.96, w * 0.72, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(BottomLeftShapePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class BottomShapePainter extends CustomPainter {
  const BottomShapePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final n = progress * h * 0.02;

    final path = Path()
      ..moveTo(0, h * 0.90)
      ..cubicTo(w * 0.18, h * 0.86 - n, w * 0.36, h * 0.93, w * 0.55, h * 0.90)
      ..cubicTo(w * 0.78, h * 0.86 + n, w * 0.90, h * 0.80, w, h * 0.82)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(BottomShapePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
