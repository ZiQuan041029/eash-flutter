import 'package:flutter/material.dart';

import 'core/theme/eash_theme.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/verification_complete_screen.dart';
import 'features/landing/landing_screen.dart';

/// Set at run time: `flutter run --dart-define=EASH_PREVIEW_VERIFICATION=true`
/// Opens the post-register verification UI without registering again.
const bool kPreviewVerificationComplete = bool.fromEnvironment(
  'EASH_PREVIEW_VERIFICATION',
  defaultValue: false,
);

/// Set at run time: `flutter run --dart-define=EASH_PREVIEW_REGISTER=true`
/// Opens Step 3 register / confirm-password UI without the visa flow.
const bool kPreviewRegister = bool.fromEnvironment(
  'EASH_PREVIEW_REGISTER',
  defaultValue: false,
);

class EashApp extends StatelessWidget {
  const EashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eash',
      theme: buildEashTheme(),
      debugShowCheckedModeBanner: false,
      home: kPreviewVerificationComplete
          ? const VerificationCompleteScreen()
          : kPreviewRegister
              ? const RegisterScreen()
              : const LandingScreen(),
    );
  }
}
