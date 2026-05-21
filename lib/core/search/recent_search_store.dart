import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists recent search chip labels (newest first).
final class RecentSearchStore {
  RecentSearchStore._();
  static final RecentSearchStore instance = RecentSearchStore._();

  static const String _prefsKey = 'eash_recent_searches_v1';
  static const int _maxItems = 12;

  static const List<String> defaultLabels = <String>[
    'Book club',
    'Student Cafe',
    'Football',
    'Mcdonalds',
  ];

  Future<List<String>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) {
      return List<String>.from(defaultLabels);
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        return List<String>.from(defaultLabels);
      }
      final List<String> labels = decoded
          .whereType<String>()
          .map((String s) => s.trim())
          .where((String s) => s.isNotEmpty)
          .toList();
      return labels.isEmpty ? List<String>.from(defaultLabels) : labels;
    } catch (_) {
      return List<String>.from(defaultLabels);
    }
  }

  Future<void> add(String label) async {
    final String trimmed = label.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final List<String> current = await load();
    final String lower = trimmed.toLowerCase();
    current.removeWhere((String s) => s.toLowerCase() == lower);
    current.insert(0, trimmed);

    final List<String> next =
        current.length > _maxItems ? current.sublist(0, _maxItems) : current;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(next));
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, '[]');
  }
}
