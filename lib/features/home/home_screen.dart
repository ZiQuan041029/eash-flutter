import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/location/location_permission_gate.dart';
import '../../core/notifications/unread_notification_store.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../../widgets/eash_gradient_header.dart';
import '../chat/kai_chat_screen.dart';
import '../notifications/notifications_screen.dart';
import '../discover/discover_screen.dart';
import '../food_drink/food_drink_routes.dart';
import '../profile/profile_home_screen.dart';
import '../profile/profile_photo_picker.dart';
import '../profile/profile_setup_screen.dart';
import '../../data/food_drink_mock_data.dart';
import '../../core/search/search_navigate_result.dart';
import '../search/home_search_screen.dart';
import 'widgets/home_deal_banner.dart';

/// Replace with admin API; use `null` + omit sliver when no announcement.
const HomeDealAnnouncement _activeHomeDeal = kDefaultHomeDealAnnouncement;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialTabIndex = 0});

  /// Bottom nav index: 0 Home, 1 Discover, 2 Events, 3 Profile.
  final int initialTabIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _tabIndex;
  String? _profileDisplayName;
  File? _profilePhoto;
  bool _editingProfile = false;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex.clamp(0, 3);
    UnreadNotificationStore.instance.syncHasUnread(
      NotificationsScreen.demoListHasUnread(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        primeUserLocation();
      }
    });
    if (_tabIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ensureUserLocation(context);
        }
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() => _tabIndex = index);
    if (index == 1) {
      ensureUserLocation(context);
    }
  }

  Future<void> _captureProfilePhoto(BuildContext context) async {
    final File? file = await captureProfilePhotoFromCamera(context);
    if (file != null && mounted) {
      setState(() => _profilePhoto = file);
    }
  }

  Future<void> _openSearch(BuildContext context) async {
    final SearchNavigateResult? result = await Navigator.of(context).push<SearchNavigateResult>(
      MaterialPageRoute<SearchNavigateResult>(
        builder: (_) => const HomeSearchScreen(),
      ),
    );
    if (!mounted || result == null) {
      return;
    }
    switch (result) {
      case SearchTabResult(:final tabIndex):
        _onTabChanged(tabIndex.clamp(0, 3));
      case SearchPushResult(:final screen):
        if (!context.mounted) {
          return;
        }
        await Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => screen),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool onProfileTab = _tabIndex == 3;
    final bool showBottomNav = !onProfileTab || !_editingProfile;

    return Scaffold(
      backgroundColor: EashColors.black,
      body: _buildBody(context),
      bottomNavigationBar:
          showBottomNav
              ? ColoredBox(
                color: EashColors.black,
                child: SafeArea(
                  top: false,
                  minimum: const EdgeInsets.only(bottom: 2),
                  child: _BottomNav(
                    index: _tabIndex,
                    onChanged: _onTabChanged,
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildBody(BuildContext context) {
    // For now: only Home tab has real UI; others are placeholders.
    if (_tabIndex == 3) {
      if (_editingProfile) {
        return ProfileSetupScreen(
          embeddedInTab: true,
          onExit: () => setState(() => _editingProfile = false),
          onComplete: ({required String displayName, File? photoFile}) {
            setState(() {
              _profileDisplayName =
                  displayName.trim().isEmpty ? null : displayName.trim();
              _profilePhoto = photoFile;
              _editingProfile = false;
            });
          },
        );
      }
      return ProfileHomeScreen(
        displayName: _profileDisplayName,
        photoFile: _profilePhoto,
        onEditProfile: () => setState(() => _editingProfile = true),
        onCameraTap: () => _captureProfilePhoto(context),
      );
    }
    if (_tabIndex == 1) {
      return const DiscoverScreen();
    }
    if (_tabIndex != 0) {
      final String label = <String>['Home', 'Discover', 'Events', 'Profile'][_tabIndex];
      return SafeArea(
        child: Center(
          child: Text(
            '$label (coming soon)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: EashColors.white.withValues(alpha: 0.75),
                ),
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: ListenableBuilder(
            listenable: UnreadNotificationStore.instance,
            builder: (BuildContext context, Widget? child) {
              return _TopBar(
                hasUnreadNotification: UnreadNotificationStore.instance.hasUnread,
                onSearchTap: () => _openSearch(context),
                onNotificationTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
            child: _KaiCard(userAvatarPath: _profilePhoto?.path),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 34, 16, 8),
            child: _QuickAccess(
              onItemTap: (String label) {
                if (isFoodDrinkEntryLabel(label)) {
                  openFoodDrinkScreen(context);
                }
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
            child: HomeDealBanner(
              deal: _activeHomeDeal,
              onClaim: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Claim — coming soon')),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _CommunityFeedSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.hasUnreadNotification,
    required this.onSearchTap,
    required this.onNotificationTap,
  });

  /// When true, header shows [noti_light] (new message); when false, [noti_done] (normal).
  final bool hasUnreadNotification;

  /// Opens search screen.
  final VoidCallback onSearchTap;

  /// Opens notifications (marks read when tapped from header).
  final VoidCallback onNotificationTap;

  static const Color _explorerText = Color(0xFF3D1F5C);
  static const Color _explorerFlame = Color(0xFF6B3DFF);

  /// Pts pill: #DBFFB7 (top) → #80FF00 (bottom).
  static const LinearGradient _explorerPillGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  @override
  Widget build(BuildContext context) {
    return EashGradientHeader(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ClipOval(
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              EashColors.loginMagentaDark,
                              EashColors.loginMagentaLight,
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Image.asset(
                          EashImages.homeAvatar,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, Object? e, StackTrace? st) => const Center(
                                child: Icon(
                                  Icons.person,
                                  color: EashColors.white,
                                  size: 24,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.none,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  constraints: const BoxConstraints(minWidth: 144),
                  padding: const EdgeInsets.fromLTRB(42, 7, 14, 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: _explorerPillGradient,
                    border: Border.all(
                      color: const Color(0xFF3D6B00).withValues(alpha: 0.22),
                      width: 1.25,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Explorer • 0 pts',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: _explorerText,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.25,
                              fontSize: 13,
                              height: 1.05,
                            ),
                      ),
                    ],
                  ),
                ),
                // Flame taller than the pill; anchored so it sticks up (and slightly down) past the capsule.
                Positioned(
                  left: 13,
                  top: -3,
                  width: 28,
                  height: 34,
                  child: Image.asset(
                    'assets/images/fire.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    errorBuilder:
                        (_, Object? e, StackTrace? st) => Icon(
                          Icons.local_fire_department_rounded,
                          size: 34,
                          color: _explorerFlame,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: onSearchTap,
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Image.asset(
                  'assets/images/search.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  color: EashColors.white,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder:
                      (_, Object? e, StackTrace? st) => const Icon(
                        Icons.search,
                        color: EashColors.white,
                        size: 28,
                      ),
                ),
              ),
              IconButton(
                onPressed: onNotificationTap,
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon:
                    hasUnreadNotification
                        ? Image.asset(
                            EashImages.notiLight,
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder:
                                (_, Object? e, StackTrace? st) => const Icon(
                                  Icons.notifications_active,
                                  color: EashColors.white,
                                  size: 28,
                                ),
                          )
                        : Image.asset(
                            'assets/images/noti_done.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder:
                                (_, Object? e, StackTrace? st) =>
                                    const _NotiDoneFallback(size: 28),
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fallback when [noti_done.png] is missing: outline bell + check as “all clear”.
class _NotiDoneFallback extends StatelessWidget {
  const _NotiDoneFallback({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.notifications_outlined,
            color: EashColors.white,
            size: size * 0.96,
          ),
          Positioned(
            right: -size * 0.02,
            top: -size * 0.01,
            child: Icon(
              Icons.check_rounded,
              color: EashColors.white,
              size: size * 0.48,
            ),
          ),
        ],
      ),
    );
  }
}

class _KaiCard extends StatelessWidget {
  const _KaiCard({this.userAvatarPath});

  final String? userAvatarPath;

  static const double _kaiHeroW = 200;
  static const double _kaiHeroH = 230;
  static const double _avatarSize = 48;
  static const double _cardHeight = 240;
  static const double _cardRadius = 8;
  static const double _innerCardHeight =
      _cardHeight - EashContour.inset * 2;
  /// Copy block at 390pt → 4 lines at 14.5px, nudged toward kai.
  static const double _bodyCopyWidthAtDesign = 194;
  static const double _bodyCopyLeftInset = 8;
  static const double _designFrameWidth = 390;

  static const LinearGradient _kaiCardBg = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      EashColors.loginMagentaDark,
      EashColors.loginMagentaLight,
    ],
  );

  @override
  Widget build(BuildContext context) {
    final TextTheme tt = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        final double scale = (box.maxWidth / 430).clamp(0.78, 1.0);
        final double kaiW = _kaiHeroW * scale;
        final double kaiH = _kaiHeroH * scale;
        const double padX = 14;
        const double padTop = 12;
        const double padBottom = 48;
        final double bodyCopyWidth =
            _bodyCopyWidthAtDesign * (box.maxWidth / _designFrameWidth);
        final double textRightReserve =
            (box.maxWidth - padX - bodyCopyWidth - _bodyCopyLeftInset)
                .clamp(0.0, box.maxWidth);

        return SizedBox(
          height: _cardHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                height: _cardHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _cardRadius + EashContour.inset,
                  ),
                  gradient: EashContour.rimInterestChip,
                ),
                padding: const EdgeInsets.all(EashContour.inset),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_cardRadius),
                  child: SizedBox(
                    height: _innerCardHeight,
                    width: double.infinity,
                    child: Container(
                      decoration: const BoxDecoration(gradient: _kaiCardBg),
                      child: Stack(
                        children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          padX,
                          padTop,
                          textRightReserve,
                          padBottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/kai.png',
                                    width: _avatarSize,
                                    height: _avatarSize,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder:
                                        (_, Object? e, StackTrace? st) =>
                                            Container(
                                              width: _avatarSize,
                                              height: _avatarSize,
                                              color: EashColors.white
                                                  .withValues(alpha: 0.35),
                                              child: Icon(
                                                Icons.smart_toy_outlined,
                                                color: EashColors.black
                                                    .withValues(alpha: 0.45),
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'KAI',
                                      style: tt.titleLarge?.copyWith(
                                        color: EashColors.black,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.5,
                                        height: 1.05,
                                        fontSize: 21,
                                      ),
                                    ),
                                    Text(
                                      'Your AI Buddy',
                                      style: tt.bodyMedium?.copyWith(
                                        color: EashColors.black
                                            .withValues(alpha: 0.82),
                                        fontWeight: FontWeight.w600,
                                        height: 1.15,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: _bodyCopyLeftInset,
                              ),
                              child: SizedBox(
                                width: bodyCopyWidth,
                                child: Text(
                                  'Where to get a local SIM card, how to use public transit in KL, and nearest convenience stores.',
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  style: tt.bodyMedium?.copyWith(
                                    color: EashColors.black
                                        .withValues(alpha: 0.88),
                                    height: 1.32,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: padX,
                        bottom: 22,
                        child: SizedBox(
                          width: 162,
                          child: EashGradientButton(
                            label: 'Chat With KAI',
                            height: 38,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fillGradient: EashGradients.primary,
                            contourGradient: EashContour.rimContinueCta,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder:
                                      (_) => KaiChatScreen(
                                        userAvatarPath: userAvatarPath,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -12 * scale,
                bottom: 0,
                child: Image.asset(
                  EashImages.kaiHero,
                  width: kaiW,
                  height: kaiH,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                    Icons.person_outline,
                    size: kaiH * 0.4,
                    color: EashColors.black.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess({this.onItemTap});

  final void Function(String label)? onItemTap;

  static const List<({String asset, String label})> _items =
      <({String asset, String label})>[
    (asset: EashImages.quickAccessFood, label: 'F&B'),
    (asset: EashImages.quickAccessClubs, label: 'Clubs'),
    (asset: EashImages.quickAccessEvents, label: 'Events'),
    (asset: EashImages.quickAccessHousing, label: 'Housing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Quick Access',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: EashColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints box) {
            const double gap = 8;
            final double tileW = (box.maxWidth - gap * (_items.length - 1)) /
                _items.length;

            return Row(
              children: <Widget>[
                for (int i = 0; i < _items.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: gap),
                  SizedBox(
                    width: tileW,
                    child: _QuickAccessButton(
                      asset: _items[i].asset,
                      label: _items[i].label,
                      onTap: () => onItemTap?.call(_items[i].label),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Figma Access Button: 81×~85, radius 10, 2px inverted gradient rim, blue fill.
class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({
    required this.asset,
    required this.label,
    this.onTap,
  });

  final String asset;
  final String label;
  final VoidCallback? onTap;

  static const double _radius = 10;
  static const double _rimInset = 2;
  static const double _pad = 10;
  static const double _iconLabelGap = 10;

  static const LinearGradient _fill = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF91A3FF), Color(0xFF002BFF)],
  );

  static const LinearGradient _rim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF002BFF), Color(0xFF91A3FF)],
  );

  @override
  Widget build(BuildContext context) {
    final double innerRadius = _radius - _rimInset;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            gradient: _rim,
          ),
          padding: const EdgeInsets.all(_rimInset),
          child: Container(
            padding: const EdgeInsets.all(_pad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(innerRadius),
              gradient: _fill,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                      Icons.image_outlined,
                      color: EashColors.white.withValues(alpha: 0.7),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: _iconLabelGap),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: EashColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        height: 1.1,
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

class _Post {
  const _Post({
    required this.author,
    required this.timeAgo,
    required this.text,
    required this.likes,
    required this.comments,
  });

  final String author;
  final String timeAgo;
  final String text;
  final int likes;
  final int comments;
}

const List<_Post> _mockPosts = <_Post>[
  _Post(
    author: 'Sarah Chen',
    timeAgo: '2 hours ago',
    text:
        'Just found this amazing coffee shop near campus! They have 25% student discount ☕️',
    likes: 24,
    comments: 8,
  ),
  _Post(
    author: 'Marcus Johnson',
    timeAgo: '4 hours ago',
    text: 'Basketball meetup this Saturday at Central Park! Who’s in?',
    likes: 12,
    comments: 15,
  ),
];

class _CommunityFeedSection extends StatelessWidget {
  const _CommunityFeedSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Community Feed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: EashColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const Spacer(),
                Text(
                  'More Feed',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: EashColors.white.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(width: 4),
                Transform.flip(
                  flipX: true,
                  child: Image.asset(
                    EashImages.exit,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder:
                        (_, Object? e, StackTrace? st) => Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: EashColors.white.withValues(alpha: 0.55),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (int i = 0; i < _mockPosts.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(height: 12),
              _PostCard(post: _mockPosts[i]),
            ],
          ],
        ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final _Post post;

  static const TextStyle _metaStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF8E8E93),
  );

  static const TextStyle _countStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Color(0xFF636366),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundColor: EashColors.black.withValues(alpha: 0.06),
                child: Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: EashColors.black.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.author,
                      style: const TextStyle(
                        color: EashColors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(post.timeAgo, style: _metaStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post.text,
            style: TextStyle(
              color: EashColors.black.withValues(alpha: 0.55),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const _FeedActionIcon(asset: EashImages.feedLike),
              const SizedBox(width: 6),
              Text('${post.likes}', style: _countStyle),
              const SizedBox(width: 16),
              const _FeedActionIcon(asset: EashImages.feedComment),
              const SizedBox(width: 6),
              Text('${post.comments}', style: _countStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedActionIcon extends StatelessWidget {
  const _FeedActionIcon({required this.asset});

  final String asset;

  static const double _size = 20;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: _size,
      height: _size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Floating pill footer with a Telegram-style sliding active highlight.
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  static const Color _barFill = Color(0xFF2A2A2C);
  static const Color _inactiveLabel = Color(0xFFB8B8BC);
  static const Duration _slideDuration = Duration(milliseconds: 300);

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem(
      label: 'Home',
      asset: EashImages.navHome,
      fallbackIcon: Icons.home_outlined,
    ),
    _NavItem(
      label: 'Discover',
      asset: EashImages.navDiscover,
      fallbackIcon: Icons.explore_outlined,
    ),
    _NavItem(
      label: 'Events',
      asset: EashImages.navEvents,
      fallbackIcon: Icons.celebration_outlined,
    ),
    _NavItem(
      label: 'Profile',
      asset: EashImages.navProfile,
      fallbackIcon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int tabCount = _items.length;
    const double barInset = 5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(barInset),
        decoration: BoxDecoration(
          color: _barFill,
          borderRadius: BorderRadius.circular(999),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double tabWidth = constraints.maxWidth / tabCount;
            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: _slideDuration,
                  curve: Curves.easeInOutCubic,
                  left: index * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: EashGradients.primary,
                    ),
                  ),
                ),
                Row(
                  children: List<Widget>.generate(tabCount, (int i) {
                    return Expanded(
                      child: _BottomNavSlot(
                        item: _items[i],
                        selected: i == index,
                        onTap: () => onChanged(i),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavSlot extends StatelessWidget {
  const _BottomNavSlot({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: EashColors.white.withValues(alpha: 0.12),
        highlightColor: EashColors.white.withValues(alpha: 0.06),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                item.asset,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color:
                    selected
                        ? EashColors.white
                        : EashColors.white.withValues(alpha: 0.55),
                colorBlendMode: BlendMode.srcIn,
                filterQuality: FilterQuality.high,
                errorBuilder:
                    (_, Object? e, StackTrace? st) => Icon(
                      item.fallbackIcon ?? Icons.circle_outlined,
                      size: 22,
                      color:
                          selected
                              ? EashColors.white
                              : EashColors.white.withValues(alpha: 0.55),
                    ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: _BottomNav._slideDuration,
                curve: Curves.easeInOutCubic,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  height: 1.1,
                  color:
                      selected ? EashColors.white : _BottomNav._inactiveLabel,
                ),
                child: Text(item.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.asset,
    this.fallbackIcon,
  });

  final String label;
  final String asset;
  final IconData? fallbackIcon;
}
