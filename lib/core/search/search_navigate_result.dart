import 'package:flutter/material.dart';

/// Result returned from [HomeSearchScreen] when a query matches a destination.
sealed class SearchNavigateResult {}

/// Switch [HomeScreen] bottom-nav tab (0 Home, 1 Discover, 2 Events, 3 Profile).
final class SearchTabResult extends SearchNavigateResult {
  SearchTabResult({
    required this.tabIndex,
    required this.recentLabel,
  });

  final int tabIndex;
  final String recentLabel;
}

/// Push another screen on top of [HomeScreen] after closing search.
final class SearchPushResult extends SearchNavigateResult {
  SearchPushResult({
    required this.screen,
    required this.recentLabel,
  });

  final Widget screen;
  final String recentLabel;
}
