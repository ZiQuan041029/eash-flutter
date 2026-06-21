import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/network/restaurant_api.dart';
import '../../features/directions/direction_routes.dart';
import '../../data/merchant_mock_data.dart';
import '../../data/restaurant_mapper.dart';
import 'merchant_detail_screen.dart';

/// Opens the merchant / store detail page (Figma `06b-merchant-details`).
Future<void> openMerchantDetail(BuildContext context, {Merchant? merchant}) async {
  Merchant resolved = merchant ?? kMockMerchant;

  try {
    final ApiRestaurant? api = await RestaurantApi(http.Client())
        .fetchRestaurantBySlug(kMerchantDemoSlug);
    if (api != null) {
      resolved = merchantFromApi(api) ?? resolved;
    }
  } catch (_) {
    // Fall back to mock merchant when API is unreachable.
  }

  if (!context.mounted) {
    return;
  }

  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder:
          (BuildContext context) => MerchantDetailScreen(merchant: resolved),
    ),
  );
}

/// Opens the directions / navigation page (Figma
/// `06c-merchant-details-get-direction`).
void openMerchantDirection(BuildContext context, Merchant merchant) {
  openVenueDirections(
    context,
    name: merchant.name,
    latitude: merchant.latitude,
    longitude: merchant.longitude,
    address: merchant.address,
    directionLabelFallback: merchant.directionLabel,
  );
}
