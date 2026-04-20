import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IconButton(
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back, color: EashColors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 8),
              const Text('❓', textAlign: TextAlign.center, style: TextStyle(fontSize: 72)),
              const SizedBox(height: 12),
              Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your university email address and we\'ll send you instructions to reset your password.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: EashColors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 32),
              Text('Email Address', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: kMockEmail,
                style: const TextStyle(color: EashColors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail_outline, color: EashColors.gradientMagenta),
                  hintText: kMockEmail,
                ),
              ),
              const Spacer(),
              EashGradientButton(
                label: 'Send Reset Link',
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  const Expanded(child: Divider(color: EashColors.white)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider(color: EashColors.white)),
                ],
              ),
              const SizedBox(height: 16),
              EashOutlinedGradientButton(
                label: 'Back to Log In',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
