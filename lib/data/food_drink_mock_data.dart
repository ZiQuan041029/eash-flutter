/// A single popular dish shown on the venue detail screen.
class FoodDish {
  const FoodDish({
    required this.name,
    required this.priceFrom,
    this.imageAsset,
  });

  final String name;

  /// Lowest price (RM), shown as "From RM14.40".
  final double priceFrom;

  final String? imageAsset;

  String get priceLabel => 'From RM${priceFrom.toStringAsFixed(2)}';
}

/// Student-exclusive deal shown on the venue detail screen.
class StudentDeal {
  const StudentDeal({
    required this.title,
    required this.description,
    this.qrData,
  });

  /// e.g. "20% OFF Total Bill".
  final String title;

  /// e.g. "Present your student ID card at the counter to redeem".
  final String description;

  /// Payload encoded into the verification QR (null = no QR shown).
  final String? qrData;
}

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
    this.address = '',
    this.description = '',
    this.phone,
    this.priceRange,
    this.openingHours = const <String>[],
    this.isHalal,
    this.latitude,
    this.longitude,
    this.studentDeal,
    this.popularDishes = const <FoodDish>[],
    this.gallery = const <String>[],
    this.galleryPlaceholderCount = 5,
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

  /// Full street address shown on the detail screen.
  final String address;

  /// Short blurb about the venue.
  final String description;

  /// Contact number (display string).
  final String? phone;

  /// e.g. "RM", "RM RM", "$$".
  final String? priceRange;

  /// One entry per line, e.g. "Mon–Fri  10:00 – 22:00".
  final List<String> openingHours;

  /// null = unknown (not yet confirmed by data source).
  final bool? isHalal;

  final double? latitude;
  final double? longitude;

  /// Student-exclusive offer (+ QR verification). null = no deal.
  final StudentDeal? studentDeal;

  /// Popular menu items shown on the detail screen.
  final List<FoodDish> popularDishes;

  /// Banner carousel image assets. Empty until backend supplies photos.
  final List<String> gallery;

  /// How many blank slides to show when [gallery] is empty (4–5 in design).
  final int galleryPlaceholderCount;

  /// Number of slides the banner carousel should render. Shows any real
  /// photos first, then pads with blank slides up to [galleryPlaceholderCount]
  /// so the carousel stays swipeable while backend photos roll in.
  int get galleryLength => gallery.length > galleryPlaceholderCount
      ? gallery.length
      : galleryPlaceholderCount;

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
const String kFoodFilterIndian = 'Indian';
const String kFoodFilterBudget = 'Budget-Friendly';

const List<String> kFoodDrinkFilters = <String>[
  kFoodFilterAll,
  kFoodFilterHalal,
  kFoodFilterWestern,
  kFoodFilterChinese,
  kFoodFilterIndian,
  kFoodFilterBudget,
];

const List<FoodVenue> kFoodDrinkVenues = <FoodVenue>[
  FoodVenue(
    id: 'mcd',
    name: "McDonald's Kepong",
    category: 'Western',
    distanceKm: 1.5,
    rating: 4.5,
    discount: '20% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterWestern},
    imageAsset: null,
    address:
        'No. 1 & 2, Jalan 54, Desa Jaya, 52100 Kepong, Kuala Lumpur',
    description:
        '24-hour McDonald\'s in Kepong. Student combo deals on weekdays.',
    phone: '+60 3-6276 7457',
    priceRange: 'RM',
    openingHours: <String>[
      'Open 24 hours',
    ],
    isHalal: true,
    latitude: 3.21351,
    longitude: 101.63205,
    studentDeal: StudentDeal(
      title: '20% OFF Total Bill',
      description: 'Present your student ID card at the counter to redeem.',
      qrData: 'EASH:VENUE:mcd:DEAL:STUDENT20',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Big Mac™', priceFrom: 14.40),
      FoodDish(name: 'French Fries', priceFrom: 6.45),
      FoodDish(name: 'McChicken™', priceFrom: 12.90),
    ],
    gallery: <String>[
      'assets/images/mcd_1.png',
    ],
  ),
  FoodVenue(
    id: 'pelita',
    name: 'Pelita Nasi Kandar (Kepong)',
    category: 'Malaysian',
    distanceKm: 1.2,
    rating: 4.5,
    discount: '15% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterHalal},
    imageAsset: null,
    address: '49, Jalan Kepong, 52000 Kuala Lumpur',
    description:
        'Classic mamak serving nasi kandar, roti canai and teh tarik around the clock.',
    phone: '+60 3-6273 8822',
    priceRange: 'RM',
    openingHours: <String>[
      'Mon – Sun  06:00 – 02:00',
    ],
    isHalal: true,
    latitude: 3.2140,
    longitude: 101.6365,
    studentDeal: StudentDeal(
      title: '15% OFF Total Bill',
      description: 'Show your student ID before ordering to claim.',
      qrData: 'EASH:VENUE:pelita:DEAL:STUDENT15',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Roti Canai', priceFrom: 1.80),
      FoodDish(name: 'Nasi Kandar', priceFrom: 9.50),
      FoodDish(name: 'Teh Tarik', priceFrom: 2.50),
    ],
    gallery: <String>['assets/images/pelita.png'],
  ),
  FoodVenue(
    id: 'dimsum',
    name: 'Morning Dim Sum (Kepong)',
    category: 'Chinese',
    distanceKm: 1.4,
    rating: 4.2,
    discount: '15% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterChinese},
    imageAsset: null,
    address:
        '38, Jalan Metro Perdana 1, Kepong Metropolitan, 52100 Kuala Lumpur',
    description:
        'Hand-made dim sum steamed fresh every morning. Best to arrive before noon.',
    phone: '+60 3-6274 7711',
    priceRange: 'RM RM',
    openingHours: <String>[
      'Tue – Sun  07:00 – 14:00',
      'Mon  Closed',
    ],
    isHalal: false,
    latitude: 3.2165,
    longitude: 101.6380,
    studentDeal: StudentDeal(
      title: '15% OFF Dim Sum Set',
      description: 'Present your student ID at the counter to redeem.',
      qrData: 'EASH:VENUE:dimsum:DEAL:STUDENT15',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Har Gao', priceFrom: 6.50),
      FoodDish(name: 'Siew Mai', priceFrom: 5.90),
      FoodDish(name: 'Char Siu Bao', priceFrom: 4.80),
    ],
    gallery: <String>['assets/images/dimsum.png'],
  ),
  FoodVenue(
    id: 'kfc',
    name: 'KFC Kepong',
    category: 'Western',
    distanceKm: 1.5,
    rating: 4.1,
    discount: '10% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterWestern, kFoodFilterHalal},
    imageAsset: null,
    address: 'No. 3, Jalan 54, Desa Jaya, 52100 Kepong, Kuala Lumpur',
    description:
        'Fried chicken combos and student bucket deals. Dine-in and delivery available.',
    phone: '+60 3-6275 5566',
    priceRange: 'RM',
    openingHours: <String>[
      'Mon – Sun  10:00 – 23:00',
    ],
    isHalal: true,
    latitude: 3.2138,
    longitude: 101.6315,
    studentDeal: StudentDeal(
      title: '10% OFF Total Bill',
      description: 'Valid on dine-in with a verified student status.',
      qrData: 'EASH:VENUE:kfc:DEAL:STUDENT10',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Snack Plate', priceFrom: 10.99),
      FoodDish(name: 'Zinger Burger', priceFrom: 13.50),
      FoodDish(name: 'Cheesy Wedges', priceFrom: 7.20),
    ],
    gallery: <String>['assets/images/kfc.png'],
  ),
  FoodVenue(
    id: 'simple',
    name: 'Simple Cafe Kepong',
    category: 'Cafe',
    distanceKm: 1.6,
    rating: 4.6,
    discount: '10% OFF',
    filters: <String>{kFoodFilterAll},
    imageAsset: null,
    address: '12, Jalan Kepong, 52000 Kuala Lumpur',
    description:
        'Cosy specialty coffee spot with study-friendly seating and free Wi-Fi.',
    phone: '+60 3-6271 0099',
    priceRange: 'RM RM',
    openingHours: <String>[
      'Mon – Fri  09:00 – 22:00',
      'Sat – Sun  09:00 – 23:00',
    ],
    isHalal: null,
    latitude: 3.2120,
    longitude: 101.6340,
    studentDeal: StudentDeal(
      title: '10% OFF Drinks',
      description: 'Show your student ID when ordering any beverage.',
      qrData: 'EASH:VENUE:simple:DEAL:STUDENT10',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Latte', priceFrom: 11.90),
      FoodDish(name: 'Avocado Toast', priceFrom: 16.50),
      FoodDish(name: 'Croissant', priceFrom: 8.00),
    ],
    gallery: <String>['assets/images/simplecafe.png'],
  ),
  FoodVenue(
    id: 'siraj',
    name: 'Sirajudeen Nasi Kandar (Kepong)',
    category: 'Malaysian',
    distanceKm: 1.8,
    rating: 4.4,
    discount: '20% OFF',
    filters: <String>{kFoodFilterAll, kFoodFilterHalal},
    imageAsset: null,
    address: '15, Jalan Kepong, 52000 Kuala Lumpur',
    description:
        'Famous nasi kandar with a wide spread of curries and fried chicken.',
    phone: '+60 3-6272 3344',
    priceRange: 'RM',
    openingHours: <String>[
      'Mon – Sun  24 hours',
    ],
    isHalal: true,
    latitude: 3.2155,
    longitude: 101.6370,
    studentDeal: StudentDeal(
      title: '20% OFF Total Bill',
      description: 'Valid after 3 PM with a verified student ID.',
      qrData: 'EASH:VENUE:siraj:DEAL:STUDENT20',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Nasi Kandar Ayam', priceFrom: 12.00),
      FoodDish(name: 'Mutton Curry', priceFrom: 14.50),
      FoodDish(name: 'Fish Curry', priceFrom: 11.00),
    ],
    gallery: <String>['assets/images/nasikandar.png'],
  ),
  FoodVenue(
    id: 'caro',
    name: 'Caro Caro Cafe (Kepong)',
    category: 'Cafe',
    distanceKm: 2.0,
    rating: 4.0,
    discount: '25% OFF',
    filters: <String>{kFoodFilterAll},
    imageAsset: null,
    address: '22, Jalan Metro Perdana, Kepong Metropolitan, 52100 Kuala Lumpur',
    description:
        'Brunch cafe known for pastries, matcha and weekend acoustic sessions.',
    phone: '+60 3-6270 7766',
    priceRange: 'RM RM',
    openingHours: <String>[
      'Wed – Mon  10:00 – 21:00',
      'Tue  Closed',
    ],
    isHalal: null,
    latitude: 3.2105,
    longitude: 101.6330,
    studentDeal: StudentDeal(
      title: '25% OFF Brunch',
      description: 'Weekday brunch only. Present student ID to redeem.',
      qrData: 'EASH:VENUE:caro:DEAL:STUDENT25',
    ),
    popularDishes: <FoodDish>[
      FoodDish(name: 'Matcha Latte', priceFrom: 13.90),
      FoodDish(name: 'Croffle', priceFrom: 15.00),
      FoodDish(name: 'Egg Benedict', priceFrom: 18.50),
    ],
    gallery: <String>['assets/images/caro.png'],
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
