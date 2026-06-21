import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/food_drink_mock_data.dart';
import '../../data/merchant_mock_data.dart';
import '../../widgets/discover_trending_categories.dart';
import '../food_drink/food_drink_routes.dart';
import '../merchant/merchant_routes.dart';
import '../../widgets/eash_gradient_header.dart';
import '../../widgets/explore_community_card.dart';
import '../home/widgets/home_deal_banner.dart';

/// Discover tab — deal banner, trending grid, explore card, top picks (Figma 04a).
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static const LinearGradient _offerBadge = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  );

  static const List<_TopPick> _topPicks = <_TopPick>[
    _TopPick(
      name: 'Oriental Kopi',
      category: 'Cafe',
      distance: '0.5 km',
      offer: '25% Student Off',
    ),
    _TopPick(
      name: 'The Burger King',
      category: 'Fast Food',
      distance: '1.6 km',
      offer: '15% Student Off',
    ),
    _TopPick(
      name: 'Kuala Lumpur Library',
      category: 'Study Spot',
      distance: '1.2 km',
      offer: 'Free Wifi',
    ),
    _TopPick(
      name: 'Night Owl Club',
      category: 'Nightlife',
      distance: '2.1 km',
      offer: 'Student Entry',
    ),
    _TopPick(
      name: "Mario's Pizza",
      category: 'Italian',
      distance: '1.5 km',
      offer: '25% Student Off',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.black,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: EashGradientHeader(
              padding: EashGradientHeaderMetrics.centeredTitlePadding(context),
              child: const Center(
                child: Text(
                  'Discover',
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: HomeDealBanner(
                deal: kDefaultHomeDealAnnouncement,
                onClaim: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Claim — coming soon')),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 36, 16, 4),
              child: Text(
                'Trending Categories',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: EashColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
              child: DiscoverTrendingCategories(
                onCategoryTap: (String label) {
                  if (isFoodDrinkEntryLabel(label)) {
                    openFoodDrinkScreen(context);
                  }
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: const ExploreCommunityCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Top Picks',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: EashColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final _TopPick pick = _topPicks[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  index == _topPicks.length - 1 ? 16 : 10,
                ),
                child: _TopPickCard(
                  pick: pick,
                  offerGradient: _offerBadge,
                  onTap: () => openMerchantDetail(context),
                ),
              );
            }, childCount: _topPicks.length),
          ),
        ],
      ),
    );
  }
}

class _TopPick {
  const _TopPick({
    required this.name,
    required this.category,
    required this.distance,
    required this.offer,
  });

  final String name;
  final String category;
  final String distance;
  final String offer;
}

class _TopPickCard extends StatelessWidget {
  const _TopPickCard({
    required this.pick,
    required this.offerGradient,
    this.onTap,
  });

  final _TopPick pick;
  final LinearGradient offerGradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EashColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: EashColors.cardGrey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: EashColors.black.withValues(alpha: 0.35),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pick.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: EashColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pick.category} · ${pick.distance}',
                      style: TextStyle(
                        color: EashColors.black.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: offerGradient,
                ),
                child: Text(
                  pick.offer,
                  style: const TextStyle(
                    color: EashColors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
