import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    dumpAll();
  }

  Future<void> clearAll() {
    log('CLEAR ALL');
    return _prefs.clear();
  }

  void dumpAll() {
    for (final key in _prefs.getKeys()) {
      log('DUMP', key, _prefs.get(key));
    }
  }

  Map<String, Object?> getAllEntries() {
    return {for (final key in _prefs.getKeys()) key: _prefs.get(key)};
  }

  String? read(String key) {
    final value = _prefs.getString(key);
    log('READ', key, value);
    return value;
  }

  Future<void> write(String key, String value) {
    log('WRITE', key, value);
    return _prefs.setString(key, value);
  }

  Future<void> remove(String key) {
    log('REMOVE', key);
    return _prefs.remove(key);
  }

  void log(String action, [String? key, Object? value]) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('╔╣ Storage · $action')
      ..writeln('║');

    if (key != null) buffer.writeln('║  key: $key');
    if (key != null && action != 'REMOVE') {
      buffer.writeln('║  value:');
      for (final line in _pretty(value).split('\n')) {
        buffer.writeln('║    $line');
      }
    }

    buffer.write('╚${'═' * 40}');
    debugPrint(buffer.toString(), wrapWidth: 1024);
  }

  String _pretty(Object? value) {
    if (value == null) return 'null';
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map || decoded is List) {
          return const JsonEncoder.withIndent('  ').convert(decoded);
        }
      } catch (_) {}
    }
    return value.toString();
  }
}
