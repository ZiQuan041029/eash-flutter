import 'package:flutter/material.dart';

import '../../core/location/external_map_launcher.dart';
import '../../core/location/geo_utils.dart';
import '../../core/location/user_location_store.dart';
import '../../data/user_location_mock_data.dart';
import 'venue_direction_screen.dart';

/// Get Direction — opens in-app map preview (embedded Google Map).
Future<void> openVenueDirections(
  BuildContext context, {
  required String name,
  required double? latitude,
  required double? longitude,
  String? address,
  String? directionLabelFallback,
}) async {
  final LocationEnsureResult locationResult =
      await UserLocationStore.instance.ensureLocation(refresh: true);

  if (!context.mounted) {
    return;
  }

  if (!locationReadyForDirections(locationResult)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(locationBlockedMessage(locationResult))),
    );
    return;
  }

  final String directionLabel = _resolveDirectionLabel(
    latitude: latitude,
    longitude: longitude,
    fallback: directionLabelFallback,
  );

  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => VenueDirectionScreen(
        name: name,
        address: address ?? '',
        latitude: latitude,
        longitude: longitude,
        directionLabel: directionLabel,
      ),
    ),
  );
}

String _resolveDirectionLabel({
  required double? latitude,
  required double? longitude,
  String? fallback,
}) {
  final UserLocation? live = UserLocationStore.instance.navigationOrigin;
  if (live == null || latitude == null || longitude == null) {
    return fallback ?? 'Tap Start Navigation';
  }

  final double km = distanceKm(
    live.latitude,
    live.longitude,
    latitude,
    longitude,
  );

  final String distanceText = km < 1
      ? '${(km * 1000).round()}m away'
      : '${km == km.roundToDouble() ? km.toStringAsFixed(0) : km.toStringAsFixed(1)} km away';

  final int walkMinutes = (km / 5.0 * 60).ceil().clamp(1, 999);
  return '$distanceText, $walkMinutes mins via walk';
}
