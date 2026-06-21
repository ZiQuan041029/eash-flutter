import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/location/geo_utils.dart';
import '../../core/location/user_location_store.dart';
import '../../core/network/restaurant_api.dart';
import '../../core/theme/eash_theme.dart';
import '../../data/food_drink_mock_data.dart';
import '../../data/restaurant_mapper.dart';
import '../../data/user_location_mock_data.dart';
import '../../widgets/eash_gradient_header.dart';
import 'food_drink_routes.dart';
import 'widgets/venue_gallery_carousel.dart';

/// Food & Drink category listing (Figma F&B).
class FoodDrinkScreen extends StatefulWidget {
  const FoodDrinkScreen({super.key});

  @override
  State<FoodDrinkScreen> createState() => _FoodDrinkScreenState();
}

class _FoodDrinkScreenState extends State<FoodDrinkScreen> {
  String _filter = kFoodFilterAll;
  List<FoodVenue> _venues = kFoodDrinkVenues;
  final RestaurantApi _restaurantApi = RestaurantApi(http.Client());

  static const LinearGradient _discountBadge = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  static const Color _chipBorder = Color(0xFF1F1F1F);

  List<FoodVenue> get _visible {
    if (_filter == kFoodFilterAll) {
      return _venues;
    }
    return _venues
        .where((FoodVenue v) => v.filters.contains(_filter))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    try {
      final List<ApiRestaurant> rows = await _restaurantApi.fetchRestaurants();
      if (!mounted) {
        return;
      }
      setState(() {
        _venues = mergeFoodVenues(kFoodDrinkVenues, rows);
      });
    } catch (e) {
      debugPrint('Food & Drink API load failed: $e');
      // Keep mock listings when the API is unreachable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodVenue> venues = _visible;

    return ColoredBox(
      color: EashColors.black,
      child: RefreshIndicator(
        onRefresh: _loadVenues,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
          SliverToBoxAdapter(
            child: EashGradientTitleHeader(
              title: 'Food & Drink',
              titleStyle: const TextStyle(
                color: EashColors.white,
                fontFamily: 'Helvetica',
                fontFamilyFallback: <String>['Arial', 'sans-serif'],
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 25 / 18,
                letterSpacing: 0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              // Figma Tabs: px=20, py=20, chips 40px tall, gap 10.
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kFoodDrinkFilters.length,
                  separatorBuilder: (_, int i) => const SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final String label = kFoodDrinkFilters[index];
                    return _FilterChip(
                      label: label,
                      selected: _filter == label,
                      borderColor: _chipBorder,
                      onTap: () => setState(() => _filter = label),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    // Figma list: 20px gap between cards, 30px after the last.
                    index == venues.length - 1 ? 30 : 20,
                  ),
                  child: ListenableBuilder(
                    listenable: UserLocationStore.instance,
                    builder: (BuildContext context, Widget? child) {
                      return _VenueCard(
                        venue: venues[index],
                        discountGradient: _discountBadge,
                      );
                    },
                  ),
                );
              },
              childCount: venues.length,
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color borderColor;
  final VoidCallback onTap;

  // Figma "Active" state: 40px tall, radius 20, padding 10/20, border 2.
  static const double _height = 40;
  static const double _radius = 20;
  static const double _border = 2;

  // Figma border (Idle + Active): linear gradient.
  static const LinearGradient _rimGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0B34FE), Color(0xFFFF4BFA)],
  );

  static const LinearGradient _activeFill = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(_radius);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: r,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          constraints: const BoxConstraints.tightFor(height: _height),
          decoration: BoxDecoration(borderRadius: r, gradient: _rimGradient),
          padding: const EdgeInsets.all(_border),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: r,
              color: selected ? null : EashColors.white,
              gradient: selected ? _activeFill : null,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? EashColors.white : EashColors.black,
                    fontFamily: 'Helvetica',
                    fontFamilyFallback: const <String>['Arial', 'sans-serif'],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 15 / 14,
                    letterSpacing: 0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.venue,
    required this.discountGradient,
  });

  final FoodVenue venue;
  final LinearGradient discountGradient;

  // Figma "Student Meal Deals" tag: mint gradient.
  static const LinearGradient _promoBadgeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF8FFFDE), Color(0xFF18CB96)],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EashColors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openFoodVenueDetail(context, venue),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SizedBox(
              height: 170,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  VenueGalleryCarousel(
                    venue: venue,
                    height: 170,
                    borderRadius: 5,
                    border:
                        Border.all(color: const Color(0xFFD9D9D9), width: 1),
                  ),
                  if (venue.discount != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _Badge(
                        label: venue.discount!,
                        gradient: discountGradient,
                      ),
                    ),
                  if (venue.promoBadge != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _Badge(
                        label: venue.promoBadge!,
                        gradient: _promoBadgeGradient,
                        textColor: EashColors.black,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        venue.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: EashColors.black,
                          fontFamily: 'Helvetica',
                          fontFamilyFallback: <String>['Arial', 'sans-serif'],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 20 / 16,
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/rate_star.png',
                      width: 20,
                      height: 20,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      venue.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: EashColors.black,
                        fontFamily: 'Helvetica',
                        fontFamilyFallback: <String>['Arial', 'sans-serif'],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 15 / 14,
                        letterSpacing: 0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _listSubtitle(venue),
                  style: const TextStyle(
                    color: Color(0xFF737373),
                    fontFamily: 'Helvetica',
                    fontFamilyFallback: <String>['Arial', 'sans-serif'],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 15 / 12,
                    letterSpacing: 0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  String _listSubtitle(FoodVenue venue) {
    final UserLocation? live = UserLocationStore.instance.navigationOrigin;
    if (live != null &&
        venue.latitude != null &&
        venue.longitude != null) {
      return '${venue.category}, ${formatDistanceKmLabel(
        distanceKm(
          live.latitude,
          live.longitude,
          venue.latitude!,
          venue.longitude!,
        ),
      )}';
    }
    return venue.subtitle;
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.gradient,
    this.textColor = EashColors.black,
  });

  final String label;
  final LinearGradient? gradient;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: gradient,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Helvetica',
          fontFamilyFallback: const <String>['Arial', 'sans-serif'],
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 15 / 12,
          letterSpacing: 0,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

