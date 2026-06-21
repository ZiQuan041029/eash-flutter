import 'package:flutter/material.dart';

import '../core/network/restaurant_api.dart';
import 'food_drink_mock_data.dart';
import 'merchant_mock_data.dart';

const String kMerchantDemoSlug = '7eleven-kepong';

const Map<String, String> _slugToMockVenueId = <String, String>{
  'mcd-kepong': 'mcd',
  'pelita-kepong': 'pelita',
  'dimsum-kepong': 'dimsum',
  'kfc-kepong': 'kfc',
  'simple-cafe-kepong': 'simple',
  'siraj-kepong': 'siraj',
  'caro-kepong': 'caro',
};

/// Overlay admin/API edits onto mock venues, then append any new API listings.
List<FoodVenue> mergeFoodVenues(
  List<FoodVenue> mocks,
  List<ApiRestaurant> apiRows,
) {
  final Map<String, ApiRestaurant> byMockId = <String, ApiRestaurant>{};
  final Set<String> mappedSlugs = <String>{};

  for (final ApiRestaurant row in apiRows) {
    if (row.isConvenienceStore) {
      continue;
    }
    final String? mockId = _slugToMockVenueId[row.slug];
    if (mockId != null) {
      byMockId[mockId] = row;
      mappedSlugs.add(row.slug);
    }
  }

  final List<FoodVenue> mergedMocks = mocks.map((FoodVenue mock) {
    final ApiRestaurant? api = byMockId[mock.id];
    if (api == null) {
      return mock;
    }
    return _overlayApiOntoMock(mock, api);
  }).toList();

  final List<FoodVenue> apiOnly = apiRows
      .where(
        (ApiRestaurant row) =>
            !row.isConvenienceStore && !mappedSlugs.contains(row.slug),
      )
      .map(foodVenueFromApi)
      .toList();

  return <FoodVenue>[...mergedMocks, ...apiOnly];
}

FoodVenue foodVenueFromApi(ApiRestaurant api) {
  final List<String> gallery =
      api.images.map((ApiRestaurantImage img) => img.url).toList();

  return FoodVenue(
    id: api.slug,
    name: api.name,
    category: api.subtitle ?? 'Restaurant',
    distanceKm: 0,
    rating: api.rating ?? 0,
    filters: filtersForCategory(api.subtitle),
    address: api.address ?? '',
    description: api.subtitle ?? '',
    phone: api.contactNumber,
    openingHours: api.operatingHours,
    latitude: api.latitude,
    longitude: api.longitude,
    gallery: gallery,
    studentDeal: api.qrData == null
        ? null
        : StudentDeal(
            title: 'Student offer',
            description: 'Present your student ID to redeem.',
            qrData: api.qrData,
          ),
  );
}

FoodVenue _overlayApiOntoMock(FoodVenue mock, ApiRestaurant api) {
  final List<String> gallery =
      api.images.map((ApiRestaurantImage img) => img.url).toList();

  return FoodVenue(
    id: mock.id,
    name: api.name,
    category: api.subtitle ?? mock.category,
    distanceKm: mock.distanceKm,
    rating: api.rating ?? mock.rating,
    filters: mock.filters,
    discount: mock.discount,
    promoBadge: mock.promoBadge,
    imageAsset: mock.imageAsset,
    address: api.address ?? mock.address,
    description: mock.description,
    phone: api.contactNumber ?? mock.phone,
    priceRange: mock.priceRange,
    openingHours:
        api.operatingHours.isNotEmpty ? api.operatingHours : mock.openingHours,
    isHalal: mock.isHalal,
    latitude: api.latitude ?? mock.latitude,
    longitude: api.longitude ?? mock.longitude,
    studentDeal: mock.studentDeal,
    popularDishes: mock.popularDishes,
    gallery: gallery.isNotEmpty ? gallery : mock.gallery,
    galleryPlaceholderCount: mock.galleryPlaceholderCount,
  );
}

Set<String> filtersForCategory(String? subtitle) {
  final String value = (subtitle ?? '').toLowerCase();
  final Set<String> filters = <String>{kFoodFilterAll};

  if (value.contains('western') || value.contains('fast food')) {
    filters.add(kFoodFilterWestern);
  }
  if (value.contains('chinese')) {
    filters.add(kFoodFilterChinese);
  }
  if (value.contains('indian')) {
    filters.add(kFoodFilterIndian);
  }
  if (value.contains('malaysian') ||
      value.contains('halal') ||
      value.contains('mamak')) {
    filters.add(kFoodFilterHalal);
  }
  if (value.contains('budget') || value.contains('cheap')) {
    filters.add(kFoodFilterBudget);
  }

  return filters;
}

Merchant? merchantFromApi(ApiRestaurant api) {
  final List<MerchantAmenity> amenities = api.amenities
      .map(
        (ApiAmenity row) => MerchantAmenity(
          label: row.name,
          icon: _amenityIcon(row.icon),
        ),
      )
      .toList();

  final List<String> gallery =
      api.images.map((ApiRestaurantImage img) => img.url).toList();

  return Merchant(
    id: api.slug,
    name: api.name,
    distanceLabel: kMockMerchant.distanceLabel,
    openLabel: api.operatingHours.isNotEmpty
        ? api.operatingHours.first
        : kMockMerchant.openLabel,
    address: api.address ?? kMockMerchant.address,
    openingHours: api.operatingHours.isNotEmpty
        ? api.operatingHours
        : kMockMerchant.openingHours,
    amenities: amenities.isNotEmpty ? amenities : kMockMerchant.amenities,
    latitude: api.latitude ?? kMockMerchant.latitude,
    longitude: api.longitude ?? kMockMerchant.longitude,
    directionLabel: kMockMerchant.directionLabel,
    gallery: gallery.isNotEmpty ? gallery : kMockMerchant.gallery,
    galleryPlaceholderCount: kMockMerchant.galleryPlaceholderCount,
  );
}

IconData _amenityIcon(String icon) {
  switch (icon) {
    case 'wifi':
      return Icons.wifi_rounded;
    case 'credit_card':
      return Icons.credit_card_rounded;
    case 'sim_card':
      return Icons.sim_card_rounded;
    case 'print':
      return Icons.print_rounded;
    case 'dashboard':
      return Icons.dashboard_customize_rounded;
    case 'package':
      return Icons.inventory_2_rounded;
    default:
      return Icons.check_circle_outline_rounded;
  }
}
