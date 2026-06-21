/// Mock user location used for distance calc + the map/directions view.
///
/// Replace [kMockUserLocation] with live GPS / saved-address data once the
/// backend + location services are wired up.
class UserLocation {
  const UserLocation({
    required this.currentAddress,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
  });

  /// Human-readable current address.
  final String currentAddress;

  final double latitude;
  final double longitude;

  /// Postal / ZIP code.
  final String postalCode;
}

/// Default mock location (Kepong, KL) — matches common emulator GPS for testing.
const UserLocation kMockUserLocation = UserLocation(
  currentAddress: 'Jalan Burung Balam, Kepong, Kuala Lumpur',
  latitude: 3.1999,
  longitude: 101.6358,
  postalCode: '52100',
);
