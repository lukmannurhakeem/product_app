import 'package:flutter/material.dart';
import 'package:product_app/core/extension/theme_extension.dart';

// TODO: adjust this import to wherever your AppColors / AppContextExtension live.

// ============================================================
// DIALOG SERVICE
// ------------------------------------------------------------
// Setup (once, after your service locator is ready, e.g. in main()):
//
//   DialogService.init(locator<NavigationService>().navigatorKey);
//
// MaterialApp already uses that same key, so no MaterialApp change needed.
//
// Usage (context is optional once init() has been called):
//
//   await DialogService.success(title: 'Saved', message: 'All done.');
//   final ok = await DialogService.confirm(title: 'Delete?', isDestructive: true);
//   final name = await DialogService.input(title: 'Your name');
//   final data = await DialogService.runWithLoading(() => api.fetch());
// ============================================================

enum DialogType { success, error, warning, info, confirm }

class DialogService {
  DialogService._();

  static GlobalKey<NavigatorState>? _navigatorKey;

  /// Pass the same key that MaterialApp uses (NavigationService's key).
  static void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static BuildContext? _loadingContext;

  static bool get isLoadingVisible => _loadingContext != null;

  static BuildContext _resolve(BuildContext? context) {
    final ctx = context ?? _navigatorKey?.currentContext;
    assert(
      ctx != null,
      'DialogService: no context available. Pass a context or call '
      'DialogService.init(navigatorKey) first.',
    );
    return ctx!;
  }

  // ------------------------------------------------------------
  // CUSTOM
  // ------------------------------------------------------------

  /// Show any widget as a dialog.
  static Future<T?> custom<T>({
    BuildContext? context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: _resolve(context),
      barrierDismissible: barrierDismissible,
      useRootNavigator: true,
      builder: builder,
    );
  }

  // ------------------------------------------------------------
  // ALERTS (single button)
  // ------------------------------------------------------------

  static Future<void> alert({
    BuildContext? context,
    required String title,
    String? message,
    DialogType type = DialogType.info,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return custom<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => _DialogShell(
        type: type,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: buttonText,
            type: type,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  static Future<void> success({
    BuildContext? context,
    required String title,
    String? message,
    String buttonText = 'OK',
  }) => alert(
    context: context,
    title: title,
    message: message,
    type: DialogType.success,
    buttonText: buttonText,
  );

  static Future<void> error({
    BuildContext? context,
    String title = 'Something went wrong',
    String? message,
    String buttonText = 'OK',
  }) => alert(
    context: context,
    title: title,
    message: message,
    type: DialogType.error,
    buttonText: buttonText,
  );

  static Future<void> warning({
    BuildContext? context,
    required String title,
    String? message,
    String buttonText = 'OK',
  }) => alert(
    context: context,
    title: title,
    message: message,
    type: DialogType.warning,
    buttonText: buttonText,
  );

  static Future<void> info({
    BuildContext? context,
    required String title,
    String? message,
    String buttonText = 'OK',
  }) => alert(
    context: context,
    title: title,
    message: message,
    type: DialogType.info,
    buttonText: buttonText,
  );

  // ------------------------------------------------------------
  // CONFIRM (two buttons) — returns true / false (false if dismissed)
  // ------------------------------------------------------------

  static Future<bool> confirm({
    BuildContext? context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) async {
    final type = isDestructive ? DialogType.error : DialogType.confirm;
    final result = await custom<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => _DialogShell(
        type: type,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: cancelText,
            type: type,
            outlined: true,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          _DialogButton(
            label: confirmText,
            type: type,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ------------------------------------------------------------
  // INPUT — returns the entered text, or null if cancelled
  // ------------------------------------------------------------

  static Future<String?> input({
    BuildContext? context,
    required String title,
    String? message,
    String? hint,
    String? initialValue,
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool obscureText = false,
    String? Function(String value)? validator,
  }) {
    return custom<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _InputDialog(
        title: title,
        message: message,
        hint: hint,
        initialValue: initialValue,
        confirmText: confirmText,
        cancelText: cancelText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  // ------------------------------------------------------------
  // LOADING
  // ------------------------------------------------------------

  static void showLoading({BuildContext? context, String? message}) {
    if (isLoadingVisible) return;
    showDialog<void>(
      context: _resolve(context),
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) {
        _loadingContext = ctx;
        return PopScope(canPop: false, child: _LoadingDialog(message: message));
      },
    ).whenComplete(() => _loadingContext = null);
  }

  static void hideLoading() {
    final ctx = _loadingContext;
    if (ctx == null) return;
    _loadingContext = null;
    if (ctx.mounted) Navigator.of(ctx, rootNavigator: true).pop();
  }

  /// Shows a loader while [task] runs, and always hides it afterwards.
  static Future<T> runWithLoading<T>(
    Future<T> Function() task, {
    BuildContext? context,
    String? message,
  }) async {
    showLoading(context: context, message: message);
    try {
      return await task();
    } finally {
      hideLoading();
    }
  }
}

// ============================================================
// INTERNAL WIDGETS
// ============================================================

class _TypeStyle {
  final IconData icon;
  final Color color;
  final Color onColor;

  const _TypeStyle(this.icon, this.color, this.onColor);
}

_TypeStyle _styleFor(BuildContext context, DialogType type) {
  final c = context.colors;
  final isLight = Theme.of(context).brightness == Brightness.light;

  switch (type) {
    case DialogType.success:
      return _TypeStyle(Icons.check_circle_rounded, c.success, c.onSuccess);
    case DialogType.error:
      return _TypeStyle(Icons.error_rounded, c.error, c.onError);
    case DialogType.warning:
      // The light-theme warning colour is a pale green that is hard to see
      // as an icon, so use amber there.
      return _TypeStyle(
        Icons.warning_amber_rounded,
        isLight ? const Color(0xFFE6A100) : c.warning,
        isLight ? Colors.white : c.onWarning,
      );
    case DialogType.info:
      return _TypeStyle(Icons.info_rounded, c.info, c.onInfo);
    case DialogType.confirm:
      return _TypeStyle(Icons.help_rounded, c.primary, c.onPrimary);
  }
}

class _DialogShell extends StatelessWidget {
  final DialogType type;
  final String title;
  final String? message;
  final Widget? content;
  final List<Widget> actions;

  const _DialogShell({
    required this.type,
    required this.title,
    required this.actions,
    this.message,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.spacing;
    final text = Theme.of(context).textTheme;
    final style = _styleFor(context, type);

    return Dialog(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: s.l, vertical: s.l),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(s.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(style.icon, size: 34, color: style.color),
                ),
              ),
              s.vM,
              Text(
                title,
                textAlign: TextAlign.center,
                style: text.titleLarge?.copyWith(color: c.onSurface),
              ),
              if (message != null && message!.isNotEmpty) ...[
                s.vS,
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: c.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
              if (content != null) ...[s.vM, content!],
              s.vL,
              Row(
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    if (i > 0) s.hS,
                    Expanded(child: actions[i]),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final DialogType type;
  final VoidCallback? onPressed;
  final bool outlined;

  const _DialogButton({
    required this.label,
    required this.type,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = _styleFor(context, type);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    const padding = EdgeInsets.symmetric(vertical: 14);

    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: c.onSurface,
          side: BorderSide(color: c.divider),
          shape: shape,
          padding: padding,
        ),
        child: Text(label),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: style.color,
        foregroundColor: style.onColor,
        shape: shape,
        padding: padding,
      ),
      child: Text(label),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final String? message;

  const _LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.spacing;
    final text = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: s.l, vertical: s.l),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(c.primary),
              ),
            ),
            if (message != null) ...[
              s.hM,
              Flexible(
                child: Text(
                  message!,
                  style: text.bodyMedium?.copyWith(color: c.onSurface),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InputDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String? hint;
  final String? initialValue;
  final String confirmText;
  final String cancelText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final String? Function(String value)? validator;

  const _InputDialog({
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.keyboardType,
    required this.maxLines,
    required this.obscureText,
    this.message,
    this.hint,
    this.initialValue,
    this.validator,
  });

  @override
  State<_InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return _DialogShell(
      type: DialogType.confirm,
      title: widget.title,
      message: widget.message,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          obscureText: widget.obscureText,
          style: TextStyle(color: c.onSurface),
          cursorColor: c.primary,
          validator: (v) => widget.validator?.call((v ?? '').trim()),
          onFieldSubmitted: (_) {
            if (widget.maxLines == 1) _submit();
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: c.onSurface.withValues(alpha: 0.5)),
            filled: true,
            fillColor: c.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.divider.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: c.error, width: 2),
            ),
          ),
        ),
      ),
      actions: [
        _DialogButton(
          label: widget.cancelText,
          type: DialogType.confirm,
          outlined: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        _DialogButton(
          label: widget.confirmText,
          type: DialogType.confirm,
          onPressed: _submit,
        ),
      ],
    );
  }
}
