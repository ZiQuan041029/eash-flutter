import 'package:flutter/material.dart';

import 'food_drink_screen.dart';

/// Opens the Food & Drink listing (Figma F&B).
void openFoodDrinkScreen(BuildContext context) {
  Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const FoodDrinkScreen(),
    ),
  );
}
