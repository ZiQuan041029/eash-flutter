import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../../widgets/eash_gradient_header.dart';
import '../food_drink/food_drink_routes.dart';
/// Rewards / tiers profile tab (Figma 05e).
class ProfileHomeScreen extends StatelessWidget {
  const ProfileHomeScreen({
    super.key,
    this.displayName,
    this.photoFile,
    required this.onEditProfile,
    this.onCameraTap,
  });

  final String? displayName;
  final File? photoFile;
  final VoidCallback onEditProfile;
  final VoidCallback? onCameraTap;

  /// Tier card — Figma: light mint top → lime bottom.
  static const LinearGradient _tierCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  static const LinearGradient _tierProgressFill = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[EashColors.loginMagentaDark, EashColors.loginMagentaLight],
  );

  /// Progress bar outer ring — Figma Gradient/Grey, left → right.
  static const LinearGradient _tierProgressRing = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF525252), Color(0xFF737373)],
  );

  /// White line-art PNGs need a saturated tile behind them (invisible on white cards).
  static const LinearGradient _benefitBurgerTile = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFFF74AFA), Color(0xFFFFB6FE)],
  );

  static const LinearGradient _benefitHeadsetTile = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF2948FF), Color(0xFF7B9FFF)],
  );

  /// Active pill on benefit cards — light green top → dark green bottom.
  static const LinearGradient _benefitActiveBadge = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  /// Complete Profile icon tile — Figma mint, **left → right** (teal → green).
  static const LinearGradient _missionProfileTile = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF18CB96), Color(0xFF8FFFDE)],
  );

  /// 1st Cafe Visit icon tile — light purple top → dark purple bottom.
  static const LinearGradient _missionCafeTile = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFAD9FFF), Color(0xFF705BE8)],
  );

  static const Color _missionRingEmpty = Color(0xFFCCCCCC);

  /// Figma mission row metrics.
  static const double _missionLeadSize = 40;
  static const double _missionLeadPadding = 8;
  static const double _missionProgressSize = 20;

  @override
  Widget build(BuildContext context) {
    final String? name = displayName?.trim();
    final bool hasName = name != null && name.isNotEmpty;

    return ColoredBox(
      color: EashColors.black,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: EashGradientHeader(
              padding: EashGradientHeaderMetrics.centeredTitlePadding(context),
              child: const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: EashColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _ProfileAvatar(
                    photoFile: photoFile,
                    onCameraTap: onCameraTap,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          hasName ? name : 'Your Name',
                          style: TextStyle(
                            color:
                                hasName
                                    ? EashColors.white
                                    : EashColors.white.withValues(alpha: 0.45),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 36,
                          child: EashGradientButton(
                            label: 'Edit Profile',
                            onPressed: onEditProfile,
                            height: 36,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            contourInset: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: _ExplorerTierCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 18),
              child: Text(
                'Your Benefits',
                style: TextStyle(
                  color: EashColors.white.withValues(alpha: 0.95),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _BenefitCard(
                    iconAsset: EashImages.profileBenefitBurger,
                    iconTileGradient: ProfileHomeScreen._benefitBurgerTile,
                    title: '20% F&B Discount',
                    subtitle: 'Applicable at all campus partner cafes',
                    active: true,
                    onTap: () => openFoodDrinkScreen(context),
                  ),
                  SizedBox(width: 10),
                  _BenefitCard(
                    iconAsset: EashImages.profileBenefitHeadset,
                    iconTileGradient: ProfileHomeScreen._benefitHeadsetTile,
                    title: 'Priority Peer Support',
                    subtitle:
                        'Skip the queue for academic & visa advice',
                    active: true,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Your Mission',
                      style: TextStyle(
                        color: EashColors.white.withValues(alpha: 0.95),
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: EashColors.white.withValues(alpha: 0.55),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: EashColors.white.withValues(alpha: 0.45),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              const _MissionTile(
                iconAsset: EashImages.profileMissionProfile,
                iconTileGradient: ProfileHomeScreen._missionProfileTile,
                title: 'Complete Profile',
                reward: '+200 Points, +10 Exp',
                progress: _MissionProgress.completed,
                date: 'Apr 24, 2026',
              ),
              const _MissionTile(
                iconAsset: EashImages.profileMissionCoffee,
                iconTileGradient: ProfileHomeScreen._missionCafeTile,
                title: '1st Cafe Visit',
                reward: '+25 Points, +5 Exp',
                progress: _MissionProgress.none,
              ),
              const _MissionTile(
                iconAsset: EashImages.profileMissionVisaVerify,
                iconTileGradient: ProfileHomeScreen._missionProfileTile,
                title: 'Visa Verified',
                reward: '+500 Points, +5 Exp',
                progress: _MissionProgress.partial,
                isLast: true,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.photoFile, this.onCameraTap});

  final File? photoFile;
  final VoidCallback? onCameraTap;

  /// Outer pink→blue ring + inner fill (same pattern as 72px avatar rim).
  static const double _cameraBadgeOuter = 28;
  static const double _cameraBadgeRim = 2;
  static const double _cameraIconPad = 4;

  @override
  Widget build(BuildContext context) {
    final Widget image;
    final File? file = photoFile;
    if (file != null) {
      image = Image.file(file, fit: BoxFit.cover);
    } else {
      image = Image.asset(EashImages.profileAvatar, fit: BoxFit.cover);
    }

    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: EashGradients.profileRim,
            ),
            padding: const EdgeInsets.all(2.5),
            child: ClipOval(child: image),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCameraTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: _cameraBadgeOuter,
                  height: _cameraBadgeOuter,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: EashGradients.profileRim,
                  ),
                  padding: const EdgeInsets.all(_cameraBadgeRim),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: EashGradients.primary,
                    ),
                    padding: const EdgeInsets.all(_cameraIconPad),
                    alignment: Alignment.center,
                    child: Image.asset(
                      EashImages.profileCameraBadge,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, Object? e, StackTrace? st) =>
                          const Icon(
                        Icons.photo_camera_rounded,
                        size: 12,
                        color: EashColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplorerTierCard extends StatelessWidget {
  static const double _fireSize = 96;
  static const double _fireTopOverflow = 20;
  static const double _cardHeight = 176;
  static const double _pointsToProgressGap = 6;
  static const double _textFireClearance = 84;

  @override
  Widget build(BuildContext context) {
    const TextStyle tierLabel = TextStyle(
      color: EashColors.black,
      fontWeight: FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.only(top: _fireTopOverflow),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _cardHeight,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: ProfileHomeScreen._tierCardGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: _textFireClearance),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Transform.translate(
                        offset: const Offset(0, 4),
                        child: Text(
                          'Current Tier',
                          style: tierLabel.copyWith(
                            color: EashColors.black.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explorer',
                        style: tierLabel.copyWith(
                          color: EashColors.black.withValues(alpha: 0.9),
                          fontSize: 22,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '245 Points',
                  style: tierLabel.copyWith(
                    color: EashColors.black.withValues(alpha: 0.85),
                    fontSize: 18,
                    height: 1,
                  ),
                ),
                const SizedBox(height: _pointsToProgressGap),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Progress to Connector',
                        style: tierLabel.copyWith(
                          color: EashColors.black.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '156 / 499 Exp',
                      style: tierLabel.copyWith(
                        color: EashColors.black.withValues(alpha: 0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const _TierExpProgressBar(value: 156 / 499),
              ],
            ),
          ),
        Positioned(
          top: -_fireTopOverflow,
          right: 14,
          bottom: 60,
          child: Image.asset(
            EashImages.profileFire,
            width: _fireSize,
            height: _fireSize,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, Object? e, StackTrace? st) => Icon(
              Icons.local_fire_department_rounded,
              size: _fireSize,
              color: EashColors.brandMagenta.withValues(alpha: 0.85),
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _TierExpProgressBar extends StatelessWidget {
  const _TierExpProgressBar({required this.value});

  final double value;

  static const double _trackHeight = 10;
  static const double _ringWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _trackHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                const ColoredBox(color: EashColors.white),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value.clamp(0.0, 1.0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: ProfileHomeScreen._tierProgressFill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            painter: _TierProgressRingPainter(strokeWidth: _ringWidth),
          ),
        ],
      ),
    );
  }
}

/// Grey gradient stroke only — does not fill the bar interior.
class _TierProgressRingPainter extends CustomPainter {
  _TierProgressRingPainter({required this.strokeWidth});

  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Offset.zero & size;
    final double radius = size.height / 2;
    final RRect outline = RRect.fromRectAndRadius(
      bounds.deflate(strokeWidth / 2),
      Radius.circular(radius - strokeWidth / 2),
    );

    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = ProfileHomeScreen._tierProgressRing.createShader(bounds);

    canvas.drawRRect(outline, ring);
  }

  @override
  bool shouldRepaint(covariant _TierProgressRingPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.iconAsset,
    required this.iconTileGradient,
    required this.title,
    required this.subtitle,
    required this.active,
    this.onTap,
  });

  final String iconAsset;
  final LinearGradient iconTileGradient;
  final String title;
  final String subtitle;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 136),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
      decoration: BoxDecoration(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: iconTileGradient,
                ),
                padding: const EdgeInsets.all(7),
                child: Image.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const Spacer(),
              if (active)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: ProfileHomeScreen._benefitActiveBadge,
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: EashColors.black,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: EashColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.25,
              color: EashColors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: card,
      ),
    );
  }
}

class _MissionLeadIcon extends StatelessWidget {
  const _MissionLeadIcon({
    this.icon,
    this.iconAsset,
    this.iconTileGradient,
    this.iconBg = const Color(0xFF9B5CFF),
  });

  final IconData? icon;
  final String? iconAsset;
  final LinearGradient? iconTileGradient;
  final Color iconBg;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = iconTileGradient != null
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: iconTileGradient,
          )
        : BoxDecoration(
            color: iconBg.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
          );

    return Container(
      width: ProfileHomeScreen._missionLeadSize,
      height: ProfileHomeScreen._missionLeadSize,
      decoration: decoration,
      padding: iconAsset != null
          ? const EdgeInsets.all(ProfileHomeScreen._missionLeadPadding)
          : null,
      alignment: Alignment.center,
      child: iconAsset != null
          ? Image.asset(
              iconAsset!,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            )
          : Icon(icon, color: iconBg, size: 26),
    );
  }
}

enum _MissionProgress { none, partial, completed }

/// Right-side mission progress disc (empty / 50% / completed).
class _MissionProgressRing extends StatelessWidget {
  const _MissionProgressRing({required this.progress});

  final _MissionProgress progress;

  static const double _emptyRingWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final double size = ProfileHomeScreen._missionProgressSize;

    switch (progress) {
      case _MissionProgress.none:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ProfileHomeScreen._missionRingEmpty,
              width: _emptyRingWidth,
            ),
          ),
        );
      case _MissionProgress.partial:
        return Image.asset(
          EashImages.profileMission50,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        );
      case _MissionProgress.completed:
        // Full Figma asset (ring + inner gradient + check) — no extra wrapper.
        return Image.asset(
          EashImages.profileMissionComplete,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        );
    }
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    this.icon,
    this.iconAsset,
    this.iconTileGradient,
    this.iconBg = const Color(0xFF9B5CFF),
    required this.title,
    required this.reward,
    required this.progress,
    this.date,
    this.isLast = false,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final LinearGradient? iconTileGradient;
  final Color iconBg;
  final String title;
  final String reward;
  final _MissionProgress progress;
  final String? date;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 20 : 12),
      child: Material(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _MissionLeadIcon(
                icon: icon,
                iconAsset: iconAsset,
                iconTileGradient: iconTileGradient,
                iconBg: iconBg,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: EashColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reward,
                      style: TextStyle(
                        fontSize: 12,
                        color: EashColors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _MissionProgressRing(progress: progress),
                  if (date != null) ...<Widget>[
                    const SizedBox(height: 6),
                    Text(
                      date!,
                      style: TextStyle(
                        fontSize: 10,
                        color: EashColors.black.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
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
