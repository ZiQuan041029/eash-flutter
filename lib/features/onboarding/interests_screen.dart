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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: EashColors.mutedText),
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
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFF3A2F55),
                          child: Text('🧑‍🎓', style: TextStyle(fontSize: 28)),
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
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'What are you into?',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: EashColors.black,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pick at least 3!',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: EashColors.mutedText,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$kAssistantName • Just now',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: EashColors.mutedText,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    for (final InterestCategory cat in kInterestCategories) ...<Widget>[
                      Text(
                        cat.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cat.tags
                            .map(
                              (InterestTag t) => _InterestChip(
                                tag: t,
                                selected: _selected.contains(t.id),
                                onTap: () => _toggle(t.id),
                              ),
                            )
                            .toList(),
                      ),
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
                onPressed: ready
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
    required this.selected,
    required this.onTap,
  });

  final InterestTag tag;
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
            gradient: selected ? EashGradients.primary : EashGradients.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          padding: selected ? EdgeInsets.zero : const EdgeInsets.all(1.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: selected ? EashGradients.primary : null,
              color: selected ? null : EashColors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(tag.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  tag.label,
                  style: TextStyle(
                    color: selected ? EashColors.white : EashColors.black,
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
