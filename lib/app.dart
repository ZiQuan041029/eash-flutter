import 'package:flutter/material.dart';

import 'core/theme/eash_theme.dart';
import 'features/landing/landing_screen.dart';

class EashApp extends StatelessWidget {
  const EashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eash',
      theme: buildEashTheme(),
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
    );
  }
}
