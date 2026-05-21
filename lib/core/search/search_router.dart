import '../../features/chat/kai_chat_screen.dart';
import '../../features/food_drink/food_drink_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import 'search_navigate_result.dart';

/// Maps search queries (e.g. "profile") to in-app destinations.
abstract final class SearchRouter {
  static SearchNavigateResult? resolve(String rawQuery) {
    final String q = rawQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return null;
    }

    for (final _SearchEntry entry in _entries) {
      if (entry.keywords.contains(q)) {
        return entry.build();
      }
    }

    return null;
  }
}

typedef _SearchBuilder = SearchNavigateResult Function();

final class _SearchEntry {
  const _SearchEntry(this.keywords, this.build);

  final Set<String> keywords;
  final _SearchBuilder build;
}

final List<_SearchEntry> _entries = <_SearchEntry>[
  _SearchEntry(
    <String>{'profile', 'my profile', 'account'},
    () => SearchTabResult(tabIndex: 3, recentLabel: 'Profile'),
  ),
  _SearchEntry(
    <String>{
      'f&b',
      'fnb',
      'food',
      'food & drink',
      'food and drink',
      'restaurant',
      'cafe',
      'mcdonalds',
      'halal',
      'western',
      'chinese',
    },
    () => SearchPushResult(
      screen: const FoodDrinkScreen(),
      recentLabel: 'Food & Drink',
    ),
  ),
  _SearchEntry(
    <String>{'discover', 'explore'},
    () => SearchTabResult(tabIndex: 1, recentLabel: 'Discover'),
  ),
  _SearchEntry(
    <String>{'home', 'feed'},
    () => SearchTabResult(tabIndex: 0, recentLabel: 'Home'),
  ),
  _SearchEntry(
    <String>{'notifications', 'notification', 'noti', 'alerts'},
    () => SearchPushResult(
      screen: const NotificationsScreen(),
      recentLabel: 'Notifications',
    ),
  ),
  _SearchEntry(
    <String>{'kai', 'chat', 'ask kai', 'ask_kai', 'kai chat'},
    () => SearchPushResult(
      screen: const KaiChatScreen(),
      recentLabel: 'KAI Chat',
    ),
  ),
];
