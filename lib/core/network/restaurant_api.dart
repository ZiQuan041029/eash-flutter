import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_api.dart';

class RestaurantApi {
  const RestaurantApi(this._client);

  final http.Client _client;

  Future<List<ApiRestaurant>> fetchRestaurants() async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/restaurants');
    final Map<String, String> headers = _jsonHeaders();

    final http.Response res = await _client.get(url, headers: headers);
    final dynamic decoded = _decodeJson(res);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((dynamic row) => ApiRestaurant.fromJson(row as Map<String, dynamic>))
            .toList();
      }
      if (decoded is List) {
        return decoded
            .map((dynamic row) => ApiRestaurant.fromJson(row as Map<String, dynamic>))
            .toList();
      }
      return const <ApiRestaurant>[];
    }

    throw ApiException.fromResponse(res.statusCode, decoded);
  }

  Future<ApiRestaurant> fetchRestaurant(int id) async {
    final Uri url = Uri.parse('${ApiConfig.baseUrl()}/api/restaurants/$id');
    final http.Response res = await _client.get(url, headers: _jsonHeaders());
    final dynamic decoded = _decodeJson(res);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return ApiRestaurant.fromJson(decoded as Map<String, dynamic>);
    }

    throw ApiException.fromResponse(res.statusCode, decoded);
  }

  Future<ApiRestaurant?> fetchRestaurantBySlug(String slug) async {
    final List<ApiRestaurant> rows = await fetchRestaurants();
    for (final ApiRestaurant row in rows) {
      if (row.slug == slug) {
        return row;
      }
    }
    return null;
  }

  Map<String, String> _jsonHeaders() {
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
    };
    final String host = ApiConfig.hostHeader();
    if (host.isNotEmpty) {
      headers['Host'] = host;
    }
    return headers;
  }

  dynamic _decodeJson(http.Response res) {
    final String body = res.body;
    final String trimmed = body.trimLeft();
    if (trimmed.startsWith('<')) {
      throw const ApiException(
        'Backend returned HTML instead of JSON. Check API_BASE_URL.',
      );
    }
    return jsonDecode(body);
  }
}

class ApiRestaurantImage {
  const ApiRestaurantImage({required this.url, required this.sortOrder});

  final String url;
  final int sortOrder;

  factory ApiRestaurantImage.fromJson(Map<String, dynamic> json) {
    return ApiRestaurantImage(
      url: (json['url'] ?? '') as String,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

class ApiAmenity {
  const ApiAmenity({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
  });

  final int id;
  final String name;
  final String slug;
  final String icon;

  factory ApiAmenity.fromJson(Map<String, dynamic> json) {
    return ApiAmenity(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      icon: (json['icon'] ?? '') as String,
    );
  }
}

class ApiRestaurant {
  const ApiRestaurant({
    required this.id,
    required this.name,
    required this.slug,
    this.subtitle,
    this.address,
    this.contactNumber,
    this.latitude,
    this.longitude,
    this.postalCode,
    this.rating,
    this.operatingHours = const <String>[],
    this.qrData,
    this.isActive = true,
    this.images = const <ApiRestaurantImage>[],
    this.amenities = const <ApiAmenity>[],
  });

  final int id;
  final String name;
  final String slug;
  final String? subtitle;
  final String? address;
  final String? contactNumber;
  final double? latitude;
  final double? longitude;
  final String? postalCode;
  final double? rating;
  final List<String> operatingHours;
  final String? qrData;
  final bool isActive;
  final List<ApiRestaurantImage> images;
  final List<ApiAmenity> amenities;

  bool get isConvenienceStore {
    final String value = (subtitle ?? '').toLowerCase();
    return value.contains('convenience');
  }

  factory ApiRestaurant.fromJson(Map<String, dynamic> json) {
    final List<dynamic> hours = json['operating_hours'] as List<dynamic>? ?? const <dynamic>[];
    final List<dynamic> imageRows = json['images'] as List<dynamic>? ?? const <dynamic>[];
    final List<dynamic> amenityRows = json['amenities'] as List<dynamic>? ?? const <dynamic>[];

    return ApiRestaurant(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      subtitle: json['subtitle'] as String?,
      address: json['address'] as String?,
      contactNumber: json['contact_number'] as String?,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      postalCode: json['postal_code'] as String?,
      rating: _toDouble(json['rating']),
      operatingHours: hours.map((dynamic line) => line.toString()).toList(),
      qrData: json['qr_data'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      images: imageRows
          .map((dynamic row) => ApiRestaurantImage.fromJson(row as Map<String, dynamic>))
          .toList()
        ..sort((ApiRestaurantImage a, ApiRestaurantImage b) => a.sortOrder.compareTo(b.sortOrder)),
      amenities: amenityRows
          .map((dynamic row) => ApiAmenity.fromJson(row as Map<String, dynamic>))
          .toList(),
    );
  }

  static double? _toDouble(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
