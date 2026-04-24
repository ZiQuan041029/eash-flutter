import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import '../visa/visa_verification_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<String> _selected = <String>{};
  static const int _min = 3;

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  String _getAssetPath(String id) {
    final Map<String, String> assetMap = {
      'cycling': 'cycle.png',
      // Support both legacy ids (from `mock_data.dart`) and newer ids.
      'pickle': 'pickle.png',
      'pickle_paddle': 'pickle.png',
      'gym': 'gym.png',
      'gym_fitness': 'gym.png',
      'football': 'football.png',
      'coffee': 'coffee.png',
      'coffee_tea': 'coffee.png', // Matches coffee.png in your folder
      'street': 'streetfood.png',
      'street_food': 'streetfood.png', // Matches streetfood.png
      'fast': 'fastfood.png',
      'fast_food': 'fastfood.png', // Matches fastfood.png
      'vegan': 'vegan.png',
      'vegan_eats': 'vegan.png',
      'halal': 'halal.png',
      'halal_food': 'halal.png', // Matches halal.png
      'grocery': 'grocery.png',
      'music': 'music.png',
      'games': 'game.png',
      'video_games': 'game.png',
      'travel': 'travel.png',
      'traveling': 'travel.png',
      'fashion': 'fashion.png',
      'culture': 'culture.png',
    };

    final fileName = assetMap[id] ?? '$id.png';
    return 'assets/images/$fileName';
  }

  Widget _interestChip(InterestTag tag) {
    return _InterestChip(
      tag: tag,
      assetPath: _getAssetPath(tag.id),
      selected: _selected.contains(tag.id),
      onTap: () => _toggle(tag.id),
    );
  }

  /// Prototype: "Vibe & Lifestyle" is 2 + 2 + 1 rows (not 3 + 2 from [Wrap]).
  Widget _buildTagLayout(InterestCategory cat) {
    const double gap = 8;
    if (cat.title == 'Vibe & Lifestyle') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < cat.tags.length; i += 2) ...<Widget>[
            if (i > 0) const SizedBox(height: gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _interestChip(cat.tags[i]),
                if (i + 1 < cat.tags.length) ...<Widget>[
                  const SizedBox(width: gap),
                  _interestChip(cat.tags[i + 1]),
                ],
              ],
            ),
          ],
        ],
      );
    }
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: cat.tags.map(_interestChip).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int count = _selected.length;
    final bool ready = count >= _min;

    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: EashColors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  Text(
                    'Step 1 of 3',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: EashColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: EashGradients.primary,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: EashColors.black,
                            ),
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/kai.png', // Your avatar
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: EashColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'What are you into?',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        color: EashColors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pick at least 3!',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: EashColors.mutedText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'KAI • Just now',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: EashColors.mutedText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    for (final InterestCategory cat
                        in kInterestCategories) ...<Widget>[
                      Text(
                        cat.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTagLayout(cat),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFF2C2C2E)),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: EashGradientButton(
                label: 'Continue ($count/3 Selected)',
                enabled: ready,
                onPressed:
                    ready
                        ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const VisaVerificationScreen(),
                            ),
                          );
                        }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({
    required this.tag,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final InterestTag tag;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            gradient: selected ? EashGradients.primary : null,
            color: selected ? null : Colors.transparent,
            border:
                selected
                    ? null
                    : Border.all(
                      color: Colors.white.withOpacity(0.22),
                      width: 1.25,
                    ),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: selected ? EashGradients.primary : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  assetPath,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 18,
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  tag.label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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
