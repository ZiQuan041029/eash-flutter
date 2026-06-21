import 'package:flutter/material.dart';

import '../../core/location/location_permission_gate.dart';
import '../../data/food_drink_mock_data.dart';
import 'food_drink_detail_screen.dart';
import 'food_drink_screen.dart';

/// Opens the Food & Drink listing (Figma F&B).
Future<void> openFoodDrinkScreen(BuildContext context) async {
  await ensureUserLocation(context);
  if (!context.mounted) {
    return;
  }
  await Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const FoodDrinkScreen(),
    ),
  );
}

/// Opens the detail page for a single venue (mock data).
void openFoodVenueDetail(BuildContext context, FoodVenue venue) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => FoodVenueDetailScreen(venue: venue),
    ),
  );
}
