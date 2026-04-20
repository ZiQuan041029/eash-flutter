import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import '../onboarding/interests_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back, color: EashColors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: EashColors.welcomePink,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: EashColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Log in to your account to continue',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: EashColors.white.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🤳✨', style: TextStyle(fontSize: 44)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
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
              const SizedBox(height: 20),
              Text('Password', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                style: const TextStyle(color: EashColors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.key_outlined, color: EashColors.gradientBlue),
                  hintText: '••••••••',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: EashColors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              EashGradientButton(
                label: 'Log In',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const InterestsScreen()),
                    (Route<void> r) => false,
                  );
                },
              ),
              const SizedBox(height: 28),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: EashColors.mutedText.withValues(alpha: 0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or log in with',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: EashColors.mutedText),
                    ),
                  ),
                  Expanded(child: Divider(color: EashColors.mutedText.withValues(alpha: 0.5))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SsoShell(
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SsoShell(
                      child: const Icon(Icons.apple, size: 28, color: EashColors.black),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SsoShell extends StatelessWidget {
  const _SsoShell({required this.child, required this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: EashGradients.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2),
      child: Material(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
