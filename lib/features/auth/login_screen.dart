import 'package:flutter/material.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../home/home_screen.dart';
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
              const SizedBox(height: 28),
              // Header Card
              Container(
                width: double.infinity,
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      EashColors.gradientMagentaDark,
                      EashColors.gradientMagentaLight, // Bottom color (#FF4BFA)
                    ],
                    // Remove the stops or set them to [0.0, 1.0] for a smooth blend
                    stops: const [0.0, 1.0],
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    // 1. Blue Star
                    Positioned(
                      top: -5,
                      right: 5,
                      child: Image.asset(
                        'assets/images/stars_blue_2.png',
                        width: 110,
                      ),
                    ),
                    // 2. Floating Assets (Backpack)
                    Positioned(
                      width: 130,
                      top: -10,
                      right: -50,
                      child: Image.asset(
                        'assets/images/backpack_2.png',
                        width: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: EashColors.white),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 160,
                            child: Text(
                              'Log in to your account to continue',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: EashColors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 3. Main Character Image
                    Positioned(
                      right: -85,
                      height: 280,
                      child: Image.asset(
                        'assets/images/image63_1.png',
                        height: 320,
                      ),
                    ),
                    // 4. Smiley pink
                    Positioned(
                      bottom: 0,
                      right: 155,
                      child: Image.asset(
                        'assets/images/smiley_pink_2.png',
                        width: 60,
                      ),
                    ),
                    // 5 . Floating Assets (Book)
                    Positioned(
                      width: 130,
                      top: 10,
                      right: 70,
                      child: Image.asset('assets/images/book_2.png', width: 40),
                    ),

                    //6 . Floating Assets (Sparkle)
                    Positioned(
                      width: 130,
                      top: 145,
                      right: -30,
                      child: Image.asset(
                        'assets/images/sparkle_2.png',
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // 1. Email Address Field
              // 1. Email Label
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                ), // Nudges text right to align with box
                child: Text(
                  'Email Address',
                  style: const TextStyle(
                    color: EashColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700, // Bold
                    letterSpacing: -0.5,
                    fontFamily:
                        'Helvetica', // Only if you have Helvetica in pubspec.yaml
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(color: EashColors.black),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 8.0,
                      top: 12.0,
                      bottom: 12.0,
                    ),
                    child: Image.asset(
                      'assets/images/email.png',
                      width: 25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  hintText: 'student@university.edu',
                  hintStyle: TextStyle(
                    // ignore: deprecated_member_use
                    color: EashColors.black.withOpacity(0.3),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. Password Label
              Padding(
                padding: const EdgeInsets.only(left: 4.0), // Consistent nudge
                child: Text(
                  'Password',
                  style: const TextStyle(
                    color: EashColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: true,
                style: const TextStyle(color: EashColors.black),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 8.0,
                      top: 12.0,
                      bottom: 12.0,
                    ),
                    child: Image.asset(
                      'assets/images/password.png',
                      width: 25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  hintText: '••••••••',
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
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
              const SizedBox(height: 70),
              EashGradientButton(
                label: 'Log In',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const HomeScreen(),
                    ),
                    (Route<void> r) => false,
                  );
                },
              ),
              // 1. Spacing after the main Log In button
              const SizedBox(
                height: 40,
              ), // Increased to push the SSO section lower
              // 2. SSO Section with Thicker Lines and Bold Text
              Row(
                children: <Widget>[
                  // Left Divider
                  Expanded(
                    child: Divider(
                      color: EashColors.white.withValues(alpha: 0.3),
                      thickness: 2.5, // Applied here
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or log in with',
                      style: TextStyle(
                        color: EashColors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Right Divider - MUST match the left one
                  Expanded(
                    child: Divider(
                      color: EashColors.white.withValues(alpha: 0.3),
                      thickness: 2.5, // Added this to fix your issue
                    ),
                  ),
                ],
              ),
              // 3. Spacing between the text and the icons
              const SizedBox(
                height: 30,
              ), // Increased from 16 to 30 for better breathing room

              Row(
                children: <Widget>[
                  Expanded(
                    child: _SsoShell(
                      onPressed: () {},
                      child: Image.asset('assets/images/google.png', width: 24),
                    ),
                  ),
                  const SizedBox(width: 10), // Slightly wider gap between icons
                  Expanded(
                    child: _SsoShell(
                      onPressed: () {},
                      child: const Icon(
                        Icons.apple,
                        size: 28,
                        color: EashColors.black,
                      ),
                    ),
                  ),
                ],
              ),
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
        child: InkWell(onTap: onPressed, child: Center(child: child)),
      ),
    );
  }
}