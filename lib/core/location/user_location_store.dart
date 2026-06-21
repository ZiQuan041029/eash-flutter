import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/user_location_mock_data.dart';

enum LocationEnsureResult {
  granted,
  alreadyGranted,
  serviceDisabled,
  denied,
  deniedForever,
  error,
}

/// Live GPS location — used for distance, directions, and map origin.
///
/// [ensureLocation] is called automatically when the app opens (Home) and
/// again before opening external navigation.
final class UserLocationStore extends ChangeNotifier {
  UserLocationStore._();
  static final UserLocationStore instance = UserLocationStore._();

  UserLocation? _liveLocation;
  bool _isLoading = false;
  bool _permissionGranted = false;

  UserLocation? get liveLocation => _liveLocation;

  bool get isLoading => _isLoading;

  bool get permissionGranted => _permissionGranted;

  /// Real GPS only — no mock. Use for map origin / "you are here".
  UserLocation? get navigationOrigin => _liveLocation;

  /// Real GPS when available; mock fallback for UI previews when GPS is off.
  UserLocation get effectiveLocation => _liveLocation ?? kMockUserLocation;

  /// Reads device GPS (requests permission on first call).
  ///
  /// Pass [refresh: true] before navigation to pick up the latest fix.
  Future<LocationEnsureResult> ensureLocation({bool refresh = false}) async {
    if (_liveLocation != null && !refresh) {
      return LocationEnsureResult.alreadyGranted;
    }
    if (_isLoading) {
      return _permissionGranted
          ? LocationEnsureResult.alreadyGranted
          : LocationEnsureResult.denied;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationEnsureResult.serviceDisabled;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _permissionGranted = false;
        return LocationEnsureResult.denied;
      }

      if (permission == LocationPermission.deniedForever) {
        _permissionGranted = false;
        return LocationEnsureResult.deniedForever;
      }

      _permissionGranted = true;

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      _liveLocation = await _resolveAddress(position);
      notifyListeners();
      return LocationEnsureResult.granted;
    } catch (_) {
      return LocationEnsureResult.error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserLocation> _resolveAddress(Position position) async {
    final double lat = position.latitude;
    final double lng = position.longitude;

    try {
      final List<Placemark> marks = await placemarkFromCoordinates(lat, lng);
      if (marks.isNotEmpty) {
        final Placemark place = marks.first;
        final String address = _formatPlacemark(place);
        final String postal = place.postalCode?.trim() ?? '';
        return UserLocation(
          currentAddress: address.isNotEmpty ? address : _coordsLabel(lat, lng),
          latitude: lat,
          longitude: lng,
          postalCode: postal,
        );
      }
    } catch (_) {
      // Geocoding can fail on emulators — coords are still valid.
    }

    return UserLocation(
      currentAddress: _coordsLabel(lat, lng),
      latitude: lat,
      longitude: lng,
      postalCode: '',
    );
  }

  String _formatPlacemark(Placemark place) {
    final List<String> parts = <String>[
      if (place.street?.trim().isNotEmpty ?? false) place.street!.trim(),
      if (place.subLocality?.trim().isNotEmpty ?? false) place.subLocality!.trim(),
      if (place.locality?.trim().isNotEmpty ?? false) place.locality!.trim(),
      if (place.administrativeArea?.trim().isNotEmpty ?? false)
        place.administrativeArea!.trim(),
      if (place.postalCode?.trim().isNotEmpty ?? false) place.postalCode!.trim(),
      if (place.country?.trim().isNotEmpty ?? false) place.country!.trim(),
    ];
    return parts.join(', ');
  }

  String _coordsLabel(double lat, double lng) =>
      '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
}

/// GPS coordinates for a place (restaurant / merchant).
typedef MapCoordinates = ({double latitude, double longitude});

/// Resolves destination coordinates from stored lat/long or by geocoding address.
Future<MapCoordinates?> resolveMapDestination({
  double? latitude,
  double? longitude,
  String? address,
}) async {
  if (latitude != null && longitude != null) {
    return (latitude: latitude, longitude: longitude);
  }

  final String query = address?.trim() ?? '';
  if (query.isEmpty) {
    return null;
  }

  try {
    final List<Location> locations = await locationFromAddress(_addressQuery(query));
    if (locations.isEmpty) {
      return null;
    }
    final Location loc = locations.first;
    return (latitude: loc.latitude, longitude: loc.longitude);
  } catch (_) {
    return null;
  }
}

String _addressQuery(String address) {
  final String lower = address.toLowerCase();
  if (lower.contains('malaysia') ||
      lower.contains('kuala lumpur') ||
      lower.contains('penang') ||
      lower.contains('selangor')) {
    return address;
  }
  return '$address, Malaysia';
}
