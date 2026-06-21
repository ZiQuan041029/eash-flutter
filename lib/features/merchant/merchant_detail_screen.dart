import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../features/directions/direction_routes.dart';
import '../../data/merchant_mock_data.dart';
import '../../widgets/eash_gradient_header.dart';

/// Merchant / store detail page (mock data) — Figma `06b-merchant-details`.
class MerchantDetailScreen extends StatelessWidget {
  const MerchantDetailScreen({super.key, required this.merchant});

  final Merchant merchant;

  // Figma tokens.
  static const Color _white80 = Color(0xFFCCCCCC);
  static const Color _grey = Color(0xFF737373);
  static const Color _panelGrey = Color(0xFF1D1D1D);
  static const Color _pinkBorder = Color(0xFFFF4BFA);

  static const LinearGradient _amenityGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF525252), Color(0xFF737373)],
  );
  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.black,
      child: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: EashGradientTitleHeader(
                    title: 'Store Details',
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
                SliverToBoxAdapter(child: _MerchantBanner(merchant: merchant)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // 01 — Title.
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 21, 20, 20),
                        child: _TitleBlock(merchant: merchant),
                      ),

                      // 02 — Available Amenities.
                      if (merchant.amenities.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const _SectionHeader('Available Amenities'),
                              const SizedBox(height: 14),
                              _AmenitiesGrid(
                                amenities: merchant.amenities,
                                background: _panelGrey,
                                iconGradient: _amenityGradient,
                              ),
                            ],
                          ),
                        ),

                      // 03 — Venue Details.
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 31, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const _SectionHeader('Venue Details'),
                            const SizedBox(height: 12),
                            if (merchant.address.isNotEmpty)
                              _InfoRow(
                                icon: Icons.location_on_outlined,
                                value: merchant.address,
                              ),
                            if (merchant.openingHours.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 21),
                              _InfoRow(
                                icon: Icons.access_time_rounded,
                                value: merchant.openingHours.join('\n'),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer CTA — fixed "Get Direction" button.
          _FooterCTA(
            gradient: _buttonGradient,
            borderColor: _pinkBorder,
            onTap: () => openVenueDirections(
              context,
              name: merchant.name,
              latitude: merchant.latitude,
              longitude: merchant.longitude,
              address: merchant.address,
              directionLabelFallback: merchant.directionLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantBanner extends StatefulWidget {
  const _MerchantBanner({required this.merchant});

  final Merchant merchant;

  @override
  State<_MerchantBanner> createState() => _MerchantBannerState();
}

class _MerchantBannerState extends State<_MerchantBanner> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Merchant merchant = widget.merchant;
    final int count = merchant.galleryLength;

    return SizedBox(
      height: 350,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (int i) => setState(() => _page = i),
            itemBuilder: (BuildContext context, int index) {
              final String? asset =
                  index < merchant.gallery.length
                      ? merchant.gallery[index]
                      : null;
              if (asset != null) {
                return ColoredBox(
                  color: EashColors.white,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder:
                        (_, Object? e, StackTrace? st) => _placeholder(),
                  ),
                );
              }
              return _placeholder();
            },
          ),
          if (count > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < count; i++) _Dot(active: i == _page),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: EashColors.cardGrey.withValues(alpha: 0.15),
      child: Icon(
        Icons.storefront_rounded,
        size: 64,
        color: EashColors.black.withValues(alpha: 0.2),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  static const LinearGradient _activeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );
  static const LinearGradient _inactiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFD4D4D4), Color(0xFFFFFFFF)],
  );

  @override
  Widget build(BuildContext context) {
    final double size = active ? 8 : 6;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active ? _activeGradient : _inactiveGradient,
        border:
            active
                ? null
                : Border.all(color: const Color(0xFF737373), width: 0.5),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.merchant});

  final Merchant merchant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          merchant.name,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.near_me_outlined,
                  size: 18,
                  color: MerchantDetailScreen._white80,
                ),
                const SizedBox(width: 5),
                Text(
                  merchant.distanceLabel,
                  style: const TextStyle(
                    color: MerchantDetailScreen._white80,
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
            Text(
              merchant.openLabel,
              style: const TextStyle(
                color: MerchantDetailScreen._white80,
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

class _AmenitiesGrid extends StatelessWidget {
  const _AmenitiesGrid({
    required this.amenities,
    required this.background,
    required this.iconGradient,
  });

  final List<MerchantAmenity> amenities;
  final Color background;
  final LinearGradient iconGradient;

  @override
  Widget build(BuildContext context) {
    const int columns = 3;
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < amenities.length; i += columns) {
      final List<Widget> cells = <Widget>[];
      for (int c = 0; c < columns; c++) {
        final int index = i + c;
        cells.add(
          Expanded(
            child:
                index < amenities.length
                    ? _AmenityTile(
                      amenity: amenities[index],
                      iconGradient: iconGradient,
                    )
                    : const SizedBox.shrink(),
          ),
        );
      }
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 18));
      rows.add(Row(children: cells));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: rows),
    );
  }
}

class _AmenityTile extends StatelessWidget {
  const _AmenityTile({required this.amenity, required this.iconGradient});

  final MerchantAmenity amenity;
  final LinearGradient iconGradient;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 61,
          height: 61,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: iconGradient,
          ),
          alignment: Alignment.center,
          child: Icon(amenity.icon, color: EashColors.white, size: 30),
        ),
        const SizedBox(height: 11),
        Text(
          amenity.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: EashColors.white,
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
        Icon(icon, size: 20, color: MerchantDetailScreen._white80),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: MerchantDetailScreen._white80,
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

class _FooterCTA extends StatelessWidget {
  const _FooterCTA({
    required this.gradient,
    required this.borderColor,
    required this.onTap,
  });

  final LinearGradient gradient;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: EashColors.black,
        border: Border(
          top: BorderSide(color: MerchantDetailScreen._grey, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: SafeArea(
        top: false,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: gradient,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.near_me_rounded,
                      color: EashColors.white,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Get Direction',
                      style: TextStyle(
                        color: EashColors.white,
                        fontFamily: 'Helvetica',
                        fontFamilyFallback: <String>['Arial', 'sans-serif'],
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}
