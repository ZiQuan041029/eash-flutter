import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import '../auth/login_screen.dart';
import '../onboarding/interests_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(decoration: BoxDecoration(gradient: EashGradients.landing)),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  4,
                  (_) => Container(
                    width: 56,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.north_east, color: EashColors.limeHello, size: 28),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'EA SOCIAL HOUSE',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: EashColors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                fontFamily: 'serif',
                                height: 1.05,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          top: 24,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  color: const Color(0xFF4A3F6B),
                                  child: const Center(
                                    child: Text('👥', style: TextStyle(fontSize: 96)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(top: 8, right: 12, child: Text('🍕', style: TextStyle(fontSize: 40))),
                        const Positioned(top: 48, left: 4, child: Text('☕', style: TextStyle(fontSize: 36))),
                        const Positioned(bottom: 56, right: 8, child: Text('🍜', style: TextStyle(fontSize: 38))),
                        const Positioned(bottom: 72, left: 20, child: Text('🎾', style: TextStyle(fontSize: 34))),
                        Positioned(
                          top: 100,
                          left: 0,
                          child: _GreetingPill(data: kLandingGreetings[0]),
                        ),
                        Positioned(
                          top: 140,
                          right: 0,
                          child: _GreetingPill(data: kLandingGreetings[1]),
                        ),
                        Positioned(
                          bottom: 120,
                          left: 40,
                          child: _GreetingPill(data: kLandingGreetings[2]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    kTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: EashColors.white.withValues(alpha: 0.95),
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 20),
                  EashGradientButton(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const InterestsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: EashColors.white),
                        children: const <TextSpan>[
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingPill extends StatelessWidget {
  const _GreetingPill({required this.data});

  final Map<String, String> data;

  Color _bg() {
    switch (data['bg']) {
      case 'lime':
        return EashColors.limeHello;
      case 'blue':
        return EashColors.blueNamaste;
      case 'yellow':
        return EashColors.yellowVanakkam;
      default:
        return EashColors.white;
    }
  }

  Color _fg() {
    switch (data['bg']) {
      case 'lime':
      case 'yellow':
        return EashColors.black;
      default:
        return EashColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        data['label'] ?? '',
        style: TextStyle(
          color: _fg(),
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}
