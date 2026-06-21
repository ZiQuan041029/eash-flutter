import 'package:flutter/material.dart';

/// A single amenity tile shown in the merchant "Available Amenities" grid.
class MerchantAmenity {
  const MerchantAmenity({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Merchant / store detail (mock data) — Figma `06b-merchant-details`.
class Merchant {
  const Merchant({
    required this.id,
    required this.name,
    required this.distanceLabel,
    required this.openLabel,
    required this.address,
    required this.openingHours,
    required this.amenities,
    required this.latitude,
    required this.longitude,
    required this.directionLabel,
    this.gallery = const <String>[],
    this.galleryPlaceholderCount = 5,
  });

  final String id;
  final String name;

  /// e.g. `250m away`.
  final String distanceLabel;

  /// e.g. `Open until 11 PM`.
  final String openLabel;

  final String address;
  final List<String> openingHours;
  final List<MerchantAmenity> amenities;

  final double latitude;
  final double longitude;

  /// e.g. `250m away, 2 mins via walk` (shown on the directions sheet).
  final String directionLabel;

  final List<String> gallery;
  final int galleryPlaceholderCount;

  int get galleryLength =>
      gallery.length > galleryPlaceholderCount
          ? gallery.length
          : galleryPlaceholderCount;
}

const Merchant kMockMerchant = Merchant(
  id: '7eleven-kepong',
  name: '7-Eleven (Kepong Metropolitan)',
  distanceLabel: '1.9 km away',
  openLabel: 'Open 24 hours',
  address:
      'Lot G-08, Ground Floor, Metropolitan Batu, Jalan Ipoh, 52100 Kuala Lumpur',
  openingHours: <String>[
    'Open 24 hours',
  ],
  amenities: <MerchantAmenity>[
    MerchantAmenity(label: 'Free WI-FI', icon: Icons.wifi_rounded),
    MerchantAmenity(label: 'INTL Cards', icon: Icons.credit_card_rounded),
    MerchantAmenity(label: 'Sim Top-Up', icon: Icons.sim_card_rounded),
    MerchantAmenity(label: 'Print', icon: Icons.print_rounded),
    MerchantAmenity(
      label: 'Rental Board',
      icon: Icons.dashboard_customize_rounded,
    ),
    MerchantAmenity(label: 'Parcel', icon: Icons.inventory_2_rounded),
  ],
  latitude: 3.2172,
  longitude: 101.6395,
  directionLabel: '1.9 km away, 23 mins via walk',
);
