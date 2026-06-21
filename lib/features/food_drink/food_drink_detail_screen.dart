import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/eash_theme.dart';
import '../../features/directions/direction_routes.dart';
import '../../core/location/geo_utils.dart';
import '../../core/location/user_location_store.dart';
import '../../data/food_drink_mock_data.dart';
import '../../data/user_location_mock_data.dart';
import '../../widgets/eash_gradient_header.dart';
import 'widgets/venue_gallery_carousel.dart';

/// Restaurant detail page (mock data) — Figma `04f-f&b-details`.
class FoodVenueDetailScreen extends StatelessWidget {
  const FoodVenueDetailScreen({super.key, required this.venue});

  final FoodVenue venue;

  // Figma tokens.
  static const Color _white80 = Color(0xFFCCCCCC);
  static const Color _grey = Color(0xFF737373);
  static const Color _pinkBorder = Color(0xFFFF4BFA);

  static const LinearGradient _pinkGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: <Color>[Color(0xFFFFB6FE), Color(0xFFF74AFA)],
  );
  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );

  @override
  Widget build(BuildContext context) {
    final StudentDeal? deal = venue.studentDeal;

    return ColoredBox(
      color: EashColors.black,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: EashGradientTitleHeader(
              title: venue.name,
              trailing: const Icon(
                Icons.ios_share_rounded,
                color: EashColors.white,
                size: 22,
              ),
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
          SliverToBoxAdapter(child: _Banner(venue: venue)),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 01 — Title.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
                  child: _TitleBlock(venue: venue),
                ),

                // 02 — Student Exclusive.
                if (deal != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const _SectionHeader('Student Exclusive'),
                        const SizedBox(height: 14),
                        _DealCard(deal: deal, iconGradient: _pinkGradient),
                      ],
                    ),
                  ),

                // 03 — QR Code.
                if (deal?.qrData != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: _QrCard(data: deal!.qrData!, gradient: _pinkGradient),
                  ),

                // 04 — Venue Details.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _SectionHeader('Venue Details'),
                      const SizedBox(height: 12),
                      if (venue.address.isNotEmpty)
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          value: venue.address,
                        ),
                      if (venue.openingHours.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 21),
                        _InfoRow(
                          icon: Icons.access_time_rounded,
                          value: venue.openingHours.join('\n'),
                        ),
                      ],
                      if (venue.phone != null) ...<Widget>[
                        const SizedBox(height: 21),
                        _InfoRow(
                          icon: Icons.call_outlined,
                          value: venue.phone!,
                        ),
                      ],
                      const SizedBox(height: 30),
                      _DetailButton(
                        label: 'Get Direction',
                        filled: true,
                        gradient: _buttonGradient,
                        borderColor: _pinkBorder,
                        icon: const Icon(
                          Icons.near_me_rounded,
                          color: EashColors.white,
                          size: 24,
                        ),
                        onTap: () => openVenueDirections(
                          context,
                          name: venue.name,
                          latitude: venue.latitude,
                          longitude: venue.longitude,
                          address: venue.address,
                        ),
                      ),
                      if (deal != null) ...<Widget>[
                        const SizedBox(height: 20),
                        _DetailButton(
                          label: 'Claim Student Deal',
                          filled: false,
                          gradient: _buttonGradient,
                          borderColor: _pinkBorder,
                          icon: const Icon(
                            Icons.confirmation_number_outlined,
                            color: EashColors.black,
                            size: 24,
                          ),
                          onTap: () => _comingSoon(context, 'Claim deal'),
                        ),
                      ],
                    ],
                  ),
                ),

                // 05 — Popular Dishes.
                if (venue.popularDishes.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 38),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _PopularDishesHeader(
                      onFullMenu: () => _comingSoon(context, 'Full menu'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PopularDishesRow(dishes: venue.popularDishes),
                ],

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label coming soon')),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.venue});

  final FoodVenue venue;

  @override
  Widget build(BuildContext context) {
    return VenueGalleryCarousel(
      venue: venue,
      height: 350,
      placeholderIconSize: 64,
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.venue});

  final FoodVenue venue;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserLocationStore.instance,
      builder: (BuildContext context, Widget? child) {
        final UserLocation? live =
            UserLocationStore.instance.navigationOrigin;
        String distanceText = venue.distanceLabel;
        if (live != null &&
            venue.latitude != null &&
            venue.longitude != null) {
          distanceText = formatDistanceKmLabel(
            distanceKm(
              live.latitude,
              live.longitude,
              venue.latitude!,
              venue.longitude!,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              venue.name,
              style: const TextStyle(
                color: EashColors.white,
                fontFamily: 'Helvetica',
                fontFamilyFallback: <String>['Arial', 'sans-serif'],
                fontSize: 24,
                fontWeight: FontWeight.w400,
                height: 30 / 24,
                letterSpacing: 0,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${venue.category}, $distanceText',
                    style: const TextStyle(
                      color: FoodVenueDetailScreen._white80,
                      fontFamily: 'Helvetica',
                      fontFamilyFallback: <String>['Arial', 'sans-serif'],
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 15 / 14,
                      letterSpacing: 0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.star_border_rounded,
                  color: EashColors.white,
                  size: 22,
                ),
                const SizedBox(width: 5),
                Text(
                  venue.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: FoodVenueDetailScreen._white80,
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
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: EashColors.white,
        fontFamily: 'Helvetica',
        fontFamilyFallback: <String>['Arial', 'sans-serif'],
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 25 / 18,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard({required this.deal, required this.iconGradient});

  final StudentDeal deal;
  final LinearGradient iconGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: iconGradient,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.discount_rounded,
              color: EashColors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            deal.title,
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
          const SizedBox(height: 3),
          Text(
            deal.description,
            style: const TextStyle(
              color: FoodVenueDetailScreen._grey,
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
    );
  }
}

class _QrCard extends StatelessWidget {
  const _QrCard({required this.data, required this.gradient});

  final String data;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: gradient,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: EashColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: QrImageView(
              data: data,
              backgroundColor: EashColors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: EashColors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: EashColors.black,
              ),
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            'Scan To Verify Student Status',
            textAlign: TextAlign.center,
            style: TextStyle(
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
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: FoodVenueDetailScreen._white80),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: FoodVenueDetailScreen._white80,
              fontFamily: 'Helvetica',
              fontFamilyFallback: <String>['Arial', 'sans-serif'],
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 22 / 16,
              letterSpacing: 0,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton({
    required this.label,
    required this.filled,
    required this.gradient,
    required this.borderColor,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final LinearGradient gradient;
  final Color borderColor;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(25);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: filled ? gradient : null,
            color: filled ? null : EashColors.white,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                icon,
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: filled ? EashColors.white : EashColors.black,
                    fontFamily: 'Helvetica',
                    fontFamilyFallback: const <String>['Arial', 'sans-serif'],
                    fontSize: 18,
                    fontWeight: filled ? FontWeight.w700 : FontWeight.w400,
                    height: 25 / 18,
                    letterSpacing: 0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PopularDishesHeader extends StatelessWidget {
  const _PopularDishesHeader({required this.onFullMenu});

  final VoidCallback onFullMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const _SectionHeader('Popular Dishes'),
        GestureDetector(
          onTap: onFullMenu,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Full Menu',
                style: TextStyle(
                  color: FoodVenueDetailScreen._white80,
                  fontFamily: 'Helvetica',
                  fontFamilyFallback: <String>['Arial', 'sans-serif'],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 15 / 12,
                  letterSpacing: 0,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: FoodVenueDetailScreen._white80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopularDishesRow extends StatelessWidget {
  const _PopularDishesRow({required this.dishes});

  final List<FoodDish> dishes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dishes.length,
        separatorBuilder: (_, int i) => const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) =>
            _DishCard(dish: dishes[index]),
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish});

  final FoodDish dish;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: dish.imageAsset != null
                ? Image.asset(
                    dish.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, Object? e, StackTrace? st) =>
                        const _DishPlaceholder(),
                  )
                : const _DishPlaceholder(),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFD9D9D9)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dish.name,
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
                const SizedBox(height: 3),
                Text(
                  dish.priceLabel,
                  style: const TextStyle(
                    color: FoodVenueDetailScreen._grey,
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
          ),
        ],
      ),
    );
  }
}

class _DishPlaceholder extends StatelessWidget {
  const _DishPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.white,
      child: Icon(
        Icons.fastfood_rounded,
        size: 40,
        color: EashColors.black.withValues(alpha: 0.15),
      ),
    );
  }
}
