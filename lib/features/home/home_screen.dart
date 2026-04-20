import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../landing/landing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Step 3 of 3',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: EashColors.mutedText),
              ),
              const Spacer(),
              Text(
                'You\'re in!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'EA Social House is ready with your mock profile. Replace this screen with your real home feed when backend and SSO are wired up.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: EashColors.white.withValues(alpha: 0.85),
                      height: 1.45,
                    ),
              ),
              const Spacer(),
              EashGradientButton(
                label: 'Back to landing (demo)',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const LandingScreen()),
                    (Route<void> r) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
