/// ISO 3166-1 alpha-2 country with ITU-T E.164 calling code and nationality label.
class IsoCountry {
  const IsoCountry({
    required this.iso2,
    required this.name,
    required this.dialCode,
    required this.nationality,
  });

  final String iso2;
  final String name;
  final String dialCode;
  final String nationality;

  String get flagEmoji {
    final String code = iso2.toUpperCase();
    if (code.length != 2) {
      return '';
    }
    return String.fromCharCodes(
      code.codeUnits.map((int u) => u + 127397),
    );
  }

  /// Primary demonym for lists (e.g. "Italian" from "Italian" or "Azerbaijani, Azeri").
  String get primaryNationality {
    final String t = nationality.trim();
    if (t.isEmpty) {
      return name;
    }
    final int comma = t.indexOf(',');
    return comma < 0 ? t : t.substring(0, comma).trim();
  }

  String get dialDisplay => '+$dialCode';

  String get phoneListLabel => '$flagEmoji $name ($dialDisplay)';

  factory IsoCountry.fromJson(Map<String, dynamic> json) {
    String dial = (json['dial'] as String? ?? '').replaceAll(RegExp(r'\D'), '');
    dial = dial.replaceFirst(RegExp(r'^0+'), '');
    if (dial.isEmpty) {
      dial = '0';
    }

    String nat = (json['nationality'] as String? ?? '').trim();
    if (nat.isEmpty) {
      nat = json['name'] as String? ?? '';
    }

    return IsoCountry(
      iso2: (json['iso2'] as String).toUpperCase(),
      name: json['name'] as String,
      dialCode: dial,
      nationality: nat,
    );
  }
}
