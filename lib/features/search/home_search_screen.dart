import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/search/recent_search_store.dart';
import '../../core/search/search_navigate_result.dart';
import '../../core/search/search_router.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/discover_trending_categories.dart';
import '../../widgets/eash_exit_icon_button.dart';
import '../../widgets/eash_gradient_header.dart';
import '../../widgets/explore_community_card.dart';
import '../home/widgets/home_deal_banner.dart';

/// Home → search entry: typed query + prototype-style sections (recent, trending, promo).
class HomeSearchScreen extends StatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  static const double _searchBarHeight = 40;
  static const double _searchIconSize = 22;
  static const double _backIconSize = 28;

  final TextEditingController _query = TextEditingController();

  List<String> _recentLabels = List<String>.from(RecentSearchStore.defaultLabels);
  bool _loadingRecents = true;

  @override
  void initState() {
    super.initState();
    _query.addListener(_onQueryChanged);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _query.removeListener(_onQueryChanged);
    _query.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() {});
  }

  Future<void> _loadRecentSearches() async {
    final List<String> labels = await RecentSearchStore.instance.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _recentLabels = labels;
      _loadingRecents = false;
    });
  }

  Future<void> _refreshRecentLabels() async {
    final List<String> labels = await RecentSearchStore.instance.load();
    if (!mounted) {
      return;
    }
    setState(() => _recentLabels = labels);
  }

  Future<void> _runSearch(String raw) async {
    final String q = raw.trim();
    if (q.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    final SearchNavigateResult? destination = SearchRouter.resolve(q);
    if (destination != null) {
      final String recentLabel = switch (destination) {
        SearchTabResult(:final recentLabel) => recentLabel,
        SearchPushResult(:final recentLabel) => recentLabel,
      };
      await RecentSearchStore.instance.add(recentLabel);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(destination);
      return;
    }

    await RecentSearchStore.instance.add(q);
    await _refreshRecentLabels();
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No page found for "$q"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitSearch() {
    _runSearch(_query.text);
  }

  Future<void> _clearAllRecent() async {
    await RecentSearchStore.instance.clear();
    await _refreshRecentLabels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          EashGradientHeader(
            backButton: true,
            padding: EashGradientHeaderMetrics.paddingOf(
              context,
              backButton: true,
              trailingOverride: 16,
            ),
            child: Row(
              children: <Widget>[
                EashExitIconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  iconSize: _backIconSize,
                  minTapSize: 48,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: SizedBox(
                      height: _searchBarHeight,
                      child: TextField(
                        controller: _query,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _submitSearch(),
                        style: const TextStyle(
                          color: EashColors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        cursorColor: EashColors.gradientBlue,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: EashColors.white,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: EashColors.black.withValues(alpha: 0.38),
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            onPressed: _submitSearch,
                            padding: const EdgeInsets.only(right: 6),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            icon: Image.asset(
                              EashImages.search2,
                              width: _searchIconSize,
                              height: _searchIconSize,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (_, Object? e, StackTrace? st) =>
                                  Icon(
                                Icons.search_rounded,
                                color: EashColors.brandMagenta
                                    .withValues(alpha: 0.95),
                                size: _searchIconSize,
                              ),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 10, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HomeDealBanner(
                    deal: kDefaultHomeDealAnnouncement,
                    onClaim: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Claim — coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 46),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Recent Searches',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: EashColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed:
                            _recentLabels.isEmpty ? null : _clearAllRecent,
                        iconAlignment: IconAlignment.end,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 8, right: 0),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        label: Text(
                          'Clear All',
                          style: TextStyle(
                            color: EashColors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        icon: Image.asset(
                          EashImages.notiDelete,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                            color: EashColors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_loadingRecents)
                    const SizedBox(
                      height: 44,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    _RecentSearchGrid(
                      labels: _recentLabels,
                      selectedLabel: _query.text.trim(),
                      onChipTap: (String t) {
                        _query.text = t;
                        _query.selection = TextSelection.collapsed(
                          offset: t.length,
                        );
                        _runSearch(t);
                      },
                    ),
                  const SizedBox(height: 36),
                  Text(
                    'Trending Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: EashColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                  ),
                  const SizedBox(height: 16),
                  const DiscoverTrendingCategories(),
                  const SizedBox(height: 28),
                  const ExploreCommunityCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma 04b — left-aligned chips; wraps to the next row when width is tight.
class _RecentSearchGrid extends StatelessWidget {
  const _RecentSearchGrid({
    required this.labels,
    required this.selectedLabel,
    required this.onChipTap,
  });

  final List<String> labels;
  final String selectedLabel;
  final ValueChanged<String> onChipTap;

  static const double _gap = 10;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _gap,
      runSpacing: _gap,
      alignment: WrapAlignment.start,
      children: labels
          .map(
            (String label) => _RecentChip(
              label: label,
              selected: selectedLabel == label,
              onTap: () => onChipTap(label),
            ),
          )
          .toList(),
    );
  }
}

/// Matches [interests_screen._InterestChip] — white idle, blue→pink fill when selected.
class _RecentChip extends StatelessWidget {
  const _RecentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const double _chipBorder = 1.5;
  static const EdgeInsets _innerPadding = EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: EashContour.rimInterestChip,
      ),
      padding: const EdgeInsets.all(_chipBorder),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: _innerPadding,
            decoration: BoxDecoration(
              gradient: selected ? EashGradients.primary : null,
              color: selected ? null : EashColors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  EashImages.searchRecent,
                  width: 19,
                  height: 19,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  color: selected ? EashColors.white : null,
                  colorBlendMode: selected ? BlendMode.srcIn : null,
                  errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                    Icons.history_rounded,
                    size: 19,
                    color: selected
                        ? EashColors.white
                        : EashColors.brandMagenta.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? EashColors.white : EashColors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
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
