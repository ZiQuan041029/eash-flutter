import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/food_drink_mock_data.dart';
import '../../widgets/eash_gradient_header.dart';

/// Food & Drink category listing (Figma F&B).
class FoodDrinkScreen extends StatefulWidget {
  const FoodDrinkScreen({super.key});

  @override
  State<FoodDrinkScreen> createState() => _FoodDrinkScreenState();
}

class _FoodDrinkScreenState extends State<FoodDrinkScreen> {
  String _filter = kFoodFilterAll;

  static const LinearGradient _discountBadge = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  List<FoodVenue> get _visible {
    if (_filter == kFoodFilterAll) {
      return kFoodDrinkVenues;
    }
    return kFoodDrinkVenues
        .where((FoodVenue v) => v.filters.contains(_filter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodVenue> venues = _visible;

    return ColoredBox(
      color: EashColors.black,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: EashGradientTitleHeader(title: 'Food & Drink'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kFoodDrinkFilters.length,
                  separatorBuilder: (_, int i) => const SizedBox(width: 8),
                  itemBuilder: (BuildContext context, int index) {
                    final String label = kFoodDrinkFilters[index];
                    return _FilterChip(
                      label: label,
                      selected: _filter == label,
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
                    16,
                    0,
                    16,
                    index == venues.length - 1 ? 24 : 14,
                  ),
                  child: _VenueCard(
                    venue: venues[index],
                    discountGradient: _discountBadge,
                  ),
                );
              },
              childCount: venues.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _rim = 1.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: selected ? EashGradients.primary : null,
        border: selected
            ? null
            : Border.all(color: EashColors.black.withValues(alpha: 0.85)),
      ),
      padding: EdgeInsets.all(selected ? _rim : 0),
      child: Material(
        color: selected ? Colors.transparent : EashColors.white,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? EashColors.white : EashColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
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

  static const Color _promoBadgeBg = Color(0xFFB8E4FF);
  static const Color _ratingPurple = Color(0xFF9B5CFF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EashColors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 168,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _VenueImage(asset: venue.imageAsset),
                if (venue.discount != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Badge(
                      label: venue.discount!,
                      gradient: discountGradient,
                    ),
                  ),
                if (venue.promoBadge != null)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Badge(
                      label: venue.promoBadge!,
                      background: _promoBadgeBg,
                      textColor: EashColors.black,
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _PageDot(active: true),
                      const SizedBox(width: 5),
                      _PageDot(active: false),
                      const SizedBox(width: 5),
                      _PageDot(active: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        venue.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: EashColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venue.subtitle,
                        style: TextStyle(
                          color: EashColors.black.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: _ratingPurple.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      venue.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: _ratingPurple,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  const _VenueImage({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return Image.asset(
        asset!,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, Object? e, StackTrace? st) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return ColoredBox(
      color: EashColors.cardGrey.withValues(alpha: 0.15),
      child: Icon(
        Icons.restaurant_rounded,
        size: 48,
        color: EashColors.black.withValues(alpha: 0.2),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    this.gradient,
    this.background,
    this.textColor = EashColors.black,
  });

  final String label;
  final LinearGradient? gradient;
  final Color? background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: gradient,
        color: background,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? EashColors.gradientBlue
            : EashColors.white.withValues(alpha: 0.85),
      ),
    );
  }
}
