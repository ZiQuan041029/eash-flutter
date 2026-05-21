import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../food_drink/food_drink_routes.dart';
import '../../core/notifications/unread_notification_store.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_header.dart';
import '../../widgets/explore_community_card.dart';
import 'mark_all_read_sheet.dart';

/// Notification row + icon corners (12px design + 2px).
const double _kNotificationTileRadius = 14;

/// Extra space above/below each list divider line.
const double _kNotificationDividerGap = 3;

/// Space between the last notification row and the Explore card.
const double _kExploreCardTopGap = 32;

/// Read-row separator — lighter grey so it reads clearly on black.
const Color _kNotificationDividerColor = Color(0xFF5C5C62);

/// Divider line weight between read notification rows.
const double _kNotificationDividerThickness = 1.5;

/// Figma: unread row bottom border — Black/50% → #737373.
const Color _kUnreadBorderColor = Color(0xFF737373);

/// **All** notification list icon tiles (rounded squares) use this axis only: dark/strong on
/// the **left**, lighter on the **right** — never top-to-bottom.
const Alignment _kNotificationIconGradientBegin = Alignment.centerLeft;
const Alignment _kNotificationIconGradientEnd = Alignment.centerRight;

/// Figma: unread dot — 12×12, Gradient/Green (same LTR rule as row icons).
const LinearGradient _kUnreadDotGradient = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
);

/// Figma **Gradient/Grey** — read / seen notification icons (LTR).
const LinearGradient _kSeenNotificationIconGradient = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFF525252), Color(0xFF737373)],
);

/// Figma **Gradient/Pink White** — unread F&B / burger tile (LTR).
const LinearGradient _kUnreadIconPinkWhite = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFFF74AFA), Color(0xFFFFB6FE)],
);

/// Figma **Gradient/Mint** — unread profile / Earn 200pts (LTR: dark `#18CB96` → light `#8FFFDE`).
const LinearGradient _kUnreadIconMint = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFF18CB96), Color(0xFF8FFFDE)],
);

/// Unread “other” tiles: horizontal dark → light (event-style).
const LinearGradient _kUnreadIconGenericEvent = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFF0369A1), Color(0xFF7DD3FC)],
);

/// Unread default (e.g. message / Material icon): dark → light.
const LinearGradient _kUnreadIconGenericDefault = LinearGradient(
  begin: _kNotificationIconGradientBegin,
  end: _kNotificationIconGradientEnd,
  colors: <Color>[Color(0xFF4C1D95), Color(0xFFC4B5FD)],
);

LinearGradient _notificationIconBackground(_NotificationData item) {
  if (!item.unread) {
    return _kSeenNotificationIconGradient;
  }
  if (item.iconAsset == EashImages.notiBurger) {
    return _kUnreadIconPinkWhite;
  }
  if (item.iconAsset == EashImages.notiProfile) {
    return _kUnreadIconMint;
  }
  if (item.iconAsset == EashImages.notiEvent) {
    return _kUnreadIconGenericEvent;
  }
  return _kUnreadIconGenericDefault;
}

/// Demo notifications list — wire to API / push later.
class _NotificationData {
  const _NotificationData({
    required this.id,
    required this.title,
    required this.time,
    required this.body,
    this.iconAsset,
    this.icon,
    this.unread = false,
  }) : assert(iconAsset != null || icon != null);

  final String id;
  final String title;
  final String time;
  final String body;
  final String? iconAsset;
  final IconData? icon;
  final bool unread;
}

const List<_NotificationData> _kDemoNotificationItems = <_NotificationData>[
  _NotificationData(
    id: 'fb',
    title: 'F&B Promotion',
    time: 'Just Now',
    body: 'Get 20% off at The Student Cafe this week!',
    iconAsset: EashImages.notiBurger,
    unread: true,
  ),
  _NotificationData(
    id: 'pts',
    title: 'Earn 200pts!',
    time: '10 mins ago',
    body: 'Complete your profile to earn 200 points!',
    iconAsset: EashImages.notiProfile,
    unread: true,
  ),
  _NotificationData(
    id: 'msg',
    title: 'New Message',
    time: '2 hours ago',
    body: 'Sarah Chen replied to your post about quiet study spots.',
    icon: Icons.chat_bubble_outline_rounded,
    unread: false,
  ),
  _NotificationData(
    id: 'event',
    title: 'Upcoming Event',
    time: '5 hours ago',
    body: 'Kuala Lumpur Secrets walking tour starts this Saturday.',
    iconAsset: EashImages.notiEvent,
    unread: false,
  ),
  _NotificationData(
    id: 'earned',
    title: 'Points Earned',
    time: '1 day ago',
    body: 'You earned 50 pts for completing your profile!',
    iconAsset: EashImages.notiProfile,
    unread: false,
  ),
];

/// Demo seed includes unread rows — home bell starts on [EashImages.notiLight].
const bool kDemoNotificationsIncludeUnread = true;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  /// Whether the demo inbox starts with unread items (see [kDemoNotificationsIncludeUnread]).
  static bool demoListHasUnread() => kDemoNotificationsIncludeUnread;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const List<_NotificationData> _seed = _kDemoNotificationItems;
  final List<_NotificationData> _items = List<_NotificationData>.from(_seed);

  static const Duration _undoWindow = Duration(seconds: 5);

  Timer? _pendingDeleteTimer;
  _NotificationData? _pendingDeleteItem;
  int? _pendingDeleteIndex;

  @override
  void initState() {
    super.initState();
    _syncHomeBell();
  }

  @override
  void dispose() {
    _pendingDeleteTimer?.cancel();
    _syncHomeBell(deferNotify: true);
    super.dispose();
  }

  void _syncHomeBell({bool deferNotify = false}) {
    UnreadNotificationStore.instance.syncHasUnread(
      _items.any((_NotificationData n) => n.unread),
      deferNotify: deferNotify,
    );
  }

  void _commitPendingDelete() {
    _pendingDeleteTimer?.cancel();
    _pendingDeleteTimer = null;
    _pendingDeleteItem = null;
    _pendingDeleteIndex = null;
  }

  void _undoPendingDelete() {
    final _NotificationData? item = _pendingDeleteItem;
    final int? index = _pendingDeleteIndex;
    if (item == null || index == null) return;

    _commitPendingDelete();
    setState(() {
      final int insertAt = index.clamp(0, _items.length);
      _items.insert(insertAt, item);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onNotificationDismissed(_NotificationData item) {
    final int index = _items.indexWhere((e) => e.id == item.id);
    if (index < 0) return;

    _commitPendingDelete();

    final _NotificationData removed = _items.removeAt(index);
    setState(() {});
    _syncHomeBell();

    _pendingDeleteItem = removed;
    _pendingDeleteIndex = index;

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Deleted "${removed.title}"',
          style: const TextStyle(color: EashColors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2E),
        behavior: SnackBarBehavior.floating,
        duration: _undoWindow,
        action: SnackBarAction(
          label: 'Undo',
          textColor: EashColors.limeHello,
          onPressed: _undoPendingDelete,
        ),
      ),
    );

    _pendingDeleteTimer = Timer(_undoWindow, _commitPendingDelete);
  }

  Future<void> _onMarkAllReadPressed() async {
    final bool confirmed = await showMarkAllReadSheet(context);
    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      for (int i = 0; i < _items.length; i++) {
        final _NotificationData n = _items[i];
        if (!n.unread) {
          continue;
        }
        _items[i] = _NotificationData(
          id: n.id,
          title: n.title,
          time: n.time,
          body: n.body,
          iconAsset: n.iconAsset,
          icon: n.icon,
          unread: false,
        );
      }
    });
    _syncHomeBell();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          EashGradientTitleHeader(
            title: 'Notifications',
            titleStyle: const TextStyle(
              color: EashColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
            trailing: IconButton(
              onPressed: _onMarkAllReadPressed,
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              tooltip: 'Mark all as read',
              icon: Image.asset(
                EashImages.notiDone,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                  Icons.notifications_outlined,
                  color: EashColors.white.withValues(alpha: 0.95),
                  size: 26,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Text(
                    'Recent Updates',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: EashColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                  ),
                ),
                if (_items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Text(
                      'No notifications yet.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: EashColors.mutedText,
                          ),
                    ),
                  )
                else
                  ..._items.map(_buildDismissible),
                const SizedBox(height: _kExploreCardTopGap),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ExploreCommunityCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissible(_NotificationData item) {
    return Dismissible(
      key: ValueKey<String>(item.id),
      direction: DismissDirection.endToStart,
      background: const _DeleteSwipeBackground(),
      onDismissed: (_) => _onNotificationDismissed(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _NotificationTile(
            item: item,
            onTap: item.id == 'fb' ? () => openFoodDrinkScreen(context) : null,
          ),
          if (!item.unread)
            Divider(
              height: _kNotificationDividerThickness + _kNotificationDividerGap * 2,
              thickness: _kNotificationDividerThickness,
              color: _kNotificationDividerColor,
            ),
        ],
      ),
    );
  }
}

/// Swipe-reveal delete — full row height; horizontal magenta → coral + `delete.png`.
class _DeleteSwipeBackground extends StatelessWidget {
  const _DeleteSwipeBackground();

  /// Narrow strip (Figma-style compact delete zone).
  static const double _width = 64;

  static const LinearGradient _deleteGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      Color(0xFFE300EC),
      Color(0xFFFF2D92),
      Color(0xFFFF5C6A),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.black,
      child: Row(
        children: <Widget>[
          const Spacer(),
          Container(
            width: _width,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(gradient: _deleteGradient),
            child: Image.asset(
              EashImages.notiDelete,
              width: 26,
              height: 26,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, this.onTap});

  final _NotificationData item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    final bool unread = item.unread;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: unread
            ? _kUnreadBorderColor.withValues(alpha: 0.5)
            : EashColors.black,
        border: unread
            ? Border(
                bottom: BorderSide(
                  color: _kUnreadBorderColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _NotificationIcon(item: item),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            style: text.titleSmall?.copyWith(
                              color: EashColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.time,
                          style: text.bodySmall?.copyWith(
                            color: EashColors.mutedText,
                            fontSize: 13,
                          ),
                        ),
                        if (unread) ...<Widget>[
                          const SizedBox(width: 6),
                          const _UnreadDot(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.body,
                      style: text.bodySmall?.copyWith(
                        color: EashColors.white.withValues(alpha: 0.72),
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                  ],
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

/// Figma unread indicator — 12×12, #DBFFB7 → #80FF00 (LTR).
class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(top: 3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: _kUnreadDotGradient,
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.item});

  final _NotificationData item;

  static const double _box = 44;

  @override
  Widget build(BuildContext context) {
    final LinearGradient background = _notificationIconBackground(item);
    final BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(_kNotificationTileRadius),
      gradient: background,
    );

    if (item.iconAsset != null) {
      return Container(
        width: _box,
        height: _box,
        decoration: decoration,
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          item.iconAsset!,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, Object? e, StackTrace? st) => Icon(
            item.icon ?? Icons.image_not_supported_outlined,
            color: EashColors.white,
            size: 20,
          ),
        ),
      );
    }

    return Container(
      width: _box,
      height: _box,
      decoration: decoration,
      child: Icon(item.icon, color: EashColors.white, size: 22),
    );
  }
}
