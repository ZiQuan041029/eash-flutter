import 'dart:convert';

import 'package:flutter/services.dart';

import 'iso_country.dart';

/// Loads [assets/data/iso_countries.json] (ISO 3166-1 alpha-2 + E.164 dial codes).
abstract final class IsoCountries {
  static const String _assetPath = 'assets/data/iso_countries.json';

  static List<IsoCountry>? _all;

  static Future<List<IsoCountry>> load() async {
    if (_all != null) {
      return _all!;
    }
    final String raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    _all =
        decoded
            .map((dynamic e) => IsoCountry.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((IsoCountry a, IsoCountry b) {
            return a.primaryNationality.compareTo(b.primaryNationality);
          });
    return _all!;
  }

  static IsoCountry? byIso2(List<IsoCountry> list, String iso2) {
    final String key = iso2.toUpperCase();
    for (final IsoCountry c in list) {
      if (c.iso2 == key) {
        return c;
      }
    }
    return null;
  }

  static List<IsoCountry> searchNationalities(
    List<IsoCountry> list,
    String query,
  ) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return list;
    }
    return list
        .where(
          (IsoCountry c) =>
              c.primaryNationality.toLowerCase().contains(q) ||
              c.name.toLowerCase().contains(q) ||
              c.iso2.toLowerCase().contains(q),
        )
        .toList();
  }

  static List<IsoCountry> searchDialCodes(List<IsoCountry> list, String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return list;
    }
    final String digits = q.replaceAll(RegExp(r'\D'), '');
    return list.where((IsoCountry c) {
      if (c.name.toLowerCase().contains(q)) {
        return true;
      }
      if (c.iso2.toLowerCase().contains(q)) {
        return true;
      }
      if (digits.isNotEmpty && c.dialCode.contains(digits)) {
        return true;
      }
      return c.dialDisplay.toLowerCase().contains(q);
    }).toList();
  }
}
