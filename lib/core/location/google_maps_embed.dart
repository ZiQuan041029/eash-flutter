/// Builds a Google Maps **embed** URL (iframe-style preview, no Maps SDK).
///
/// Uses the same pattern as Google Maps desktop “Share → Embed a map”.
String buildGoogleMapsEmbedUrl({
  required String name,
  String? address,
  double? latitude,
  double? longitude,
}) {
  final String query = _embedQuery(
    name: name,
    address: address,
    latitude: latitude,
    longitude: longitude,
  );

  return Uri.https('maps.google.com', '/maps', <String, String>{
    'q': query,
    'hl': 'en',
    'z': '15',
    'output': 'embed',
  }).toString();
}

String buildGoogleMapsEmbedHtml({
  required String name,
  String? address,
  double? latitude,
  double? longitude,
}) {
  final String src = buildGoogleMapsEmbedUrl(
    name: name,
    address: address,
    latitude: latitude,
    longitude: longitude,
  );

  return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <style>
      html, body { margin: 0; padding: 0; height: 100%; background: #1d1d1d; }
      iframe { border: 0; width: 100%; height: 100%; }
    </style>
  </head>
  <body>
    <iframe
      src="${_escapeHtmlAttribute(src)}"
      allowfullscreen
      loading="lazy"
      referrerpolicy="no-referrer-when-downgrade">
    </iframe>
  </body>
</html>
''';
}

String _embedQuery({
  required String name,
  String? address,
  double? latitude,
  double? longitude,
}) {
  if (latitude != null && longitude != null) {
    return '${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';
  }

  final String trimmedAddress = address?.trim() ?? '';
  if (trimmedAddress.isNotEmpty) {
    return trimmedAddress;
  }

  return name.trim();
}

String _escapeHtmlAttribute(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('"', '&quot;')
      .replaceAll('<', '&lt;');
}
