import 'package:flutter/material.dart';

import '../core/assets/eash_images.dart';
import '../core/theme/eash_theme.dart';
import 'eash_gradient_button.dart';

/// Explore community promo — soft pink base + 8 Figma stripe columns + earth.
class ExploreCommunityCard extends StatelessWidget {
  const ExploreCommunityCard({super.key, this.onStartMap});

  final VoidCallback? onStartMap;

  static const double _radius = 8;
  static const double _rimInset = 1;
  static const double _cardHeight = 274;
  static const double _earthBandHeight = 96;

  static const LinearGradient _rim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFE300EC), Color(0xFFFDBFFC)],
  );

  static const LinearGradient _baseFill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFFD4FC),
      Color(0xFFFFB8F8),
      Color(0xFFFFA0F0),
      Color(0xFFFF8AE8),
    ],
    stops: <double>[0.0, 0.35, 0.7, 1.0],
  );

  static const LinearGradient stripePink = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFFDBFFC), Color(0xFFE300EC)],
  );

  static const LinearGradient stripeCol4 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFDBFFC),
      Color(0xFFE300EC),
      Color(0xFFFDBFFC),
      Color(0xFF38FF00),
      Color(0xFFE300EC),
    ],
    stops: <double>[0.0, 0.0, 0.38, 0.72, 1.0],
  );

  static const LinearGradient stripeCol5 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF38FF00), Color(0xFFFDBFFC), Color(0xFF0600FF)],
    stops: <double>[0.0, 0.5, 1.0],
  );

  static const LinearGradient stripeCol6 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFDBFFC),
      Color(0xFFE300EC),
      Color(0xFFFDBFFC),
      Color(0xFF38FF00),
      Color(0xFFE300EC),
    ],
    stops: <double>[0.0, 0.0, 0.38, 0.72, 1.0],
  );

  static const LinearGradient stripeCol7 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFE300EC),
      Color(0xFFFDBFFC),
      Color(0xFF38FF00),
      Color(0xFF00B4E5),
    ],
    stops: <double>[0.0, 0.22, 0.58, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    final double innerRadius = _radius - _rimInset;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        gradient: _rim,
      ),
      padding: const EdgeInsets.all(_rimInset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: SizedBox(
          height: _cardHeight,
          child: DecoratedBox(
            decoration: const BoxDecoration(gradient: _baseFill),
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                const _CommunityStripeBand(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRect(
                      child: SizedBox(
                        height: _earthBandHeight,
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return OverflowBox(
                              alignment: Alignment.bottomCenter,
                              maxWidth: constraints.maxWidth,
                              minWidth: constraints.maxWidth,
                              maxHeight: constraints.maxWidth * 1.35,
                              child: Image.asset(
                                EashImages.notificationsEarth,
                                width: constraints.maxWidth,
                                fit: BoxFit.fitWidth,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                                  Icons.public_rounded,
                                  size: 88,
                                  color: EashColors.gradientBlue.withValues(alpha: 0.85),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Spacer(),
                            Text(
                              'Explore Your Community',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: EashColors.landingPurple,
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Connecting international students with local services and hidden gems.',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: EashColors.landingPurple.withValues(alpha: 0.88),
                                height: 1.28,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 14),
                            EashGradientButton(
                              label: 'Start Map',
                              height: 44,
                              fontSize: 15,
                              onPressed: onStartMap ?? () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunityStripeBand extends StatelessWidget {
  const _CommunityStripeBand();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripePink),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripePink),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripePink),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripeCol4),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripeCol5),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripeCol6),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripeCol7),
        _CommunityStripeColumn(gradient: ExploreCommunityCard.stripePink),
      ],
    );
  }
}

class _CommunityStripeColumn extends StatelessWidget {
  const _CommunityStripeColumn({required this.gradient});

  final LinearGradient gradient;

  static const double _stripeOpacity = 0.34;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: _stripeOpacity,
        child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
      ),
    );
  }
}
