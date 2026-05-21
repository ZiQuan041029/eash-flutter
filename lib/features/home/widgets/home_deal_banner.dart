import 'package:flutter/material.dart';

import '../../../core/theme/eash_theme.dart';
import '../../../widgets/eash_gradient_button.dart';

/// Admin-posted deal shown on Home. `null` = hidden (no announcement).
class HomeDealAnnouncement {
  const HomeDealAnnouncement({
    required this.title,
    required this.subtitle,
    this.imageAsset = 'assets/images/CoffeeCup.png',
  });

  final String title;
  final String subtitle;
  final String imageAsset;
}

/// Default promo until admin feed is wired.
const HomeDealAnnouncement kDefaultHomeDealAnnouncement = HomeDealAnnouncement(
  title: '20% Coffee Discount',
  subtitle: 'at The Student Cafe',
);

class HomeDealBanner extends StatelessWidget {
  const HomeDealBanner({
    required this.deal,
    super.key,
    this.onClaim,
  });

  final HomeDealAnnouncement deal;
  final VoidCallback? onClaim;

  static const double _radius = 12;
  static const double _rimInset = 1;
  /// Figma column width × 3.
  static const double _accentStripWidth = 147;
  static const double _minBannerHeight = 148;

  static const LinearGradient _fill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFFFFFF),
      EashColors.loginMagentaLight,
      EashColors.loginMagentaLight,
      EashColors.loginMagentaDark,
    ],
    stops: <double>[0.0, 0.22, 0.55, 1.0],
  );

  static const LinearGradient _rim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[EashColors.loginMagentaDark, EashColors.loginMagentaLight],
  );

  @override
  Widget build(BuildContext context) {
    final double innerRadius = _radius - _rimInset;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        gradient: _rim,
      ),
      padding: const EdgeInsets.all(_rimInset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Container(
          constraints: const BoxConstraints(minHeight: _minBannerHeight),
          decoration: const BoxDecoration(gradient: _fill),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: _accentStripWidth,
                child: const _DealAccentColumns(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, _accentStripWidth, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              deal.title,
                              maxLines: 1,
                              softWrap: false,
                              style: const TextStyle(
                                color: EashColors.black,
                                fontSize: 21,
                                fontWeight: FontWeight.w400,
                                height: 1.15,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            deal.subtitle,
                            style: TextStyle(
                              color: EashColors.black.withValues(alpha: 0.72),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: 160,
                            child: EashGradientButton(
                              label: 'Claim',
                              height: 38,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fillGradient: EashGradients.primary,
                              contourGradient: EashContour.rimContinueCta,
                              onPressed: onClaim,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 2,
                bottom: -6,
                width: _accentStripWidth,
                child: Image.asset(
                  deal.imageAsset,
                  height: 138,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                    Icons.local_cafe_rounded,
                    size: 80,
                    color: const Color(0xFF5C3D2E).withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Three 49×full-height Figma vectors at 50% opacity on the banner’s right half.
class _DealAccentColumns extends StatelessWidget {
  const _DealAccentColumns();

  static const LinearGradient _column1 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFFDBFFC), Color(0xFF0600FF)],
  );

  static const LinearGradient _column2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFE300EC),
      Color(0xFFFDBFFC),
      Color(0xFF38FF00),
      Color(0xFFE300EC),
    ],
    stops: <double>[0.0, 0.28, 0.62, 1.0],
  );

  static const LinearGradient _column3 = LinearGradient(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        _DealAccentColumn(gradient: _column1),
        _DealAccentColumn(gradient: _column2),
        _DealAccentColumn(gradient: _column3),
      ],
    );
  }
}

class _DealAccentColumn extends StatelessWidget {
  const _DealAccentColumn({required this.gradient});

  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: 0.5,
        child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
      ),
    );
  }
}
