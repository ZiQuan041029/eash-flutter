import 'package:flutter/material.dart';

import 'user_location_store.dart';

/// Silently starts GPS + permission on app open (no snackbar).
void primeUserLocation() {
  UserLocationStore.instance.ensureLocation();
}

/// Requests native location permission and reads GPS when the user enters
/// Discover or Food & Drink.
Future<void> ensureUserLocation(BuildContext context) async {
  final LocationEnsureResult result =
      await UserLocationStore.instance.ensureLocation();
  if (!context.mounted) {
    return;
  }

  final String? message = switch (result) {
    LocationEnsureResult.granted ||
    LocationEnsureResult.alreadyGranted =>
      null,
    LocationEnsureResult.serviceDisabled =>
      'Location services are off. Turn on GPS to see nearby places.',
    LocationEnsureResult.denied =>
      'Location access is needed to show distance and directions.',
    LocationEnsureResult.deniedForever =>
      'Location access is off. Enable it in Settings for nearby results.',
    LocationEnsureResult.error =>
      'Could not read your location. Try again.',
  };

  if (message != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
