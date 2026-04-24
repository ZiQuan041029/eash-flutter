import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
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
          // Prototype background (full-bleed image).
          Image.asset(
            'assets/images/landing_background.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            filterQuality: FilterQuality.high,
          ),
          // Subtle bottom fade so text/buttons read well.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withOpacity(0.18),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const <double>[0.0, 0.55, 0.78, 1.0],
                ),
              ),
            ),
          ),
          // Greeting pills (over hero art; positions are screen fractions).
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;
              final double topPad = MediaQuery.paddingOf(context).top;
              return Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    left: w * 0.36,
                    top: topPad + h * 0.27,
                    child: const _GreetingPill(
                      colors: <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
                      text: 'HELLO',
                      textColor: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: w * 0.19,
                    top: topPad + h * 0.50,
                    child: const _GreetingPill(
                      colors: <Color>[Color(0xFF91A3FF), Color(0xFF002BFF)],
                      text: 'नमस्ते',
                      textColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    left: 120,
                    right: 0,
                    top: topPad + h * 0.65,
                    child: const Center(
                      child: _GreetingPill(
                        colors: <Color>[Color(0xFFFFFFFF), Color(0xFFFFEA00)],
                        text: 'வணக்கம்',
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: Padding(
              // Slight bottom inset only — large values pull the tagline up into the pills.
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                children: <Widget>[
                  // The prototype art (logo/pills/people) lives inside the background image.
                  const Spacer(),
                  Text(
                    'Connect, explore, and thrive\nwith your digital community.',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: EashColors.white,
                      fontSize: 18,
                      height: 1.22,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  EashGradientButton(
                    label: 'Get Started',
                    fontSize: 16,
                    height: 48,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const InterestsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Transform.translate(
                    offset: const Offset(0, 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        foregroundColor: EashColors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            color: EashColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.35,
                          ),
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
                  ),
                  const SizedBox(height: 4),
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
  const _GreetingPill({
    required this.colors,
    required this.text,
    required this.textColor,
  });

  final List<Color> colors;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            height: 1.15,
          ),
        ),
      ),
    );
  }
}