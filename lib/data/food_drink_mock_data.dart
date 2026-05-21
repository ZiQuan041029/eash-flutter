/// Demo F&B listings for [FoodDrinkScreen] (Figma Food & Drink).
class FoodVenue {
  const FoodVenue({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.rating,
    required this.filters,
    this.discount,
    this.promoBadge,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String category;
  final double distanceKm;
  final double rating;
  final Set<String> filters;
  final String? discount;
  final String? promoBadge;
  final String? imageAsset;

  String get distanceLabel {
    final String km = distanceKm == distanceKm.roundToDouble()
        ? distanceKm.toStringAsFixed(0)
        : distanceKm.toStringAsFixed(1);
    return '$km km away';
  }

  String get subtitle => '$category, $distanceLabel';
}

const String kFoodFilterAll = 'All';
const String kFoodFilterHalal = 'Halal';
const String kFoodFilterWestern = 'Western';
const String kFoodFilterChinese = 'Chinese';

const List<String> kFoodDrinkFilters = <String>[
  kFoodFilterAll,
  kFoodFilterHalal,
  kFoodFilterWestern,
  kFoodFilterChinese,
];

const List<FoodVenue> kFoodDrinkVenues = <FoodVenue>[
  FoodVenue(
    id: 'mcd',
    name: "McDonald's Setia Pearl DT",
    category: 'Western',
    distanceKm: 0.5,
    rating: 4.3,
    discount: '25% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterWestern},
    imageAsset: 'assets/images/pizza.png',
  ),
  FoodVenue(
    id: 'pelita',
    name: 'Pelita Curry House',
    category: 'Malaysian',
    distanceKm: 0.8,
    rating: 4.5,
    discount: '15% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterHalal},
    imageAsset: 'assets/images/streetfood.png',
  ),
  FoodVenue(
    id: 'dimsum',
    name: 'Morning Dim Sum',
    category: 'Chinese',
    distanceKm: 1.1,
    rating: 4.2,
    promoBadge: 'Student Meal Deals',
    filters: <String>{kFoodFilterAll, kFoodFilterChinese},
    imageAsset: 'assets/images/fastfood.png',
  ),
  FoodVenue(
    id: 'kfc',
    name: 'KFC Bayan Lepas',
    category: 'Western',
    distanceKm: 1.3,
    rating: 4.1,
    discount: '10% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterWestern, kFoodFilterHalal},
    imageAsset: 'assets/images/fastfood.png',
  ),
  FoodVenue(
    id: 'simple',
    name: 'Simple Cafe Penang',
    category: 'Cafe',
    distanceKm: 1.5,
    rating: 4.6,
    filters: <String>{kFoodFilterAll},
    imageAsset: 'assets/images/pizza.png',
  ),
  FoodVenue(
    id: 'siraj',
    name: 'Sirajudeen Nasi Kandar',
    category: 'Malaysian',
    distanceKm: 1.7,
    rating: 4.4,
    discount: '20% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterHalal},
    imageAsset: 'assets/images/nasilemak.png',
  ),
  FoodVenue(
    id: 'caro',
    name: 'Caro Caro Cafe',
    category: 'Cafe',
    distanceKm: 2.0,
    rating: 4.0,
    discount: '25% OFF',
    filters: <String>{kFoodFilterAll},
    imageAsset: 'assets/images/burger.png',
  ),
];

bool isFoodDrinkEntryLabel(String label) {
  final String n = label.trim().toLowerCase();
  return n == 'f&b' ||
      n == 'fnb' ||
      n == 'food & drink' ||
      n == 'food and drink' ||
      n.contains('f&b');
}
