import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../home/home_screen.dart';

/// Post-registration “Verification complete” screen (Figma 393×852).
///
/// Layout uses a fixed design canvas [kDesignW]×[kDesignH] scaled with [FittedBox].
class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});

  static const double kDesignW = 393;
  static const double kDesignH = 852;

  /// Hero height from design: text block starts at `top: 477`.
  static const double kHeroHeight = 477;

  /// Main copy block width; title ↔ body gap `6`.
  static const double kContentWidth = 353;
  static const double kTitleBlockGap = 6;

  /// CSS `linear-gradient(136.38deg, …)` — purple/magenta weighted; orange only at far corner.
  static const LinearGradient kHeroBackground = LinearGradient(
    begin: Alignment(-0.82, -1),
    end: Alignment(0.92, 1),
    stops: <double>[0.012, 0.28, 0.52, 0.78, 1.0],
    colors: <Color>[
      Color(0xFF5656D2),
      Color(0xFF8F33C2),
      Color(0xFFCC2A82),
      Color(0xFFE04090),
      Color(0xFFF3702C),
    ],
  );

  /// Accent rim for CTA (pink ↔ magenta) when using [EashGradients.primary] fill.
  static const LinearGradient kCtaRim = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: <Color>[
      Color(0xFFFFB6FE),
      Color(0xFFF74AFA),
    ],
  );

  /// Hero art (place PNGs under `assets/images/` — same names as your export).
  static const String _kVerifyComplete = 'assets/images/verify_complete.png';
  static const String _kBluePlane = 'assets/images/blue_plane.png';
  static const String _kGreenLightning = 'assets/images/green_lightning.png';
  static const String _kLightbulb = 'assets/images/lightbulb.png';
  static const String _kThumbs = 'assets/images/thumbs.png';
  static const String _kFire = 'assets/images/fire.png';
  static const String _kSpeechChat = 'assets/images/speech_chat.png';
  static const String _kTrophy = 'assets/images/trophy.png';

  static Widget _heroImage(String assetPath, {double? width, double? height}) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, Object? err, StackTrace? st) => const SizedBox.shrink(),
    );
  }

  void _goDashboard(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  void _goProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HomeScreen(initialTabIndex: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      // Edge-to-edge hero like the mock; keep home indicator clear at bottom only.
      body: SafeArea(
        top: false,
        bottom: true,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints c) {
            final double w = c.maxWidth;
            final double h = c.maxHeight;
            // Scale design (393×852) to **full width** so the hero is not a tiny centered box.
            final double scaledH = kDesignH * (w / kDesignW);
            final Widget canvas = SizedBox(
              width: w,
              height: scaledH > h ? scaledH : h,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: kDesignW,
                  height: kDesignH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: kHeroHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(gradient: kHeroBackground),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 44, 12, 8),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'EA\nSOCIAL\nHOUSE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 0.92,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800,
                                        color: EashColors.white,
                                        letterSpacing: 0.5,
                                        shadows: <Shadow>[
                                          Shadow(
                                            color: Colors.black.withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Center photo + floating 3D icons (matches reference layout).
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 78,
                                    bottom: 0,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        _heroImage(_kVerifyComplete, width: 318),
                                        Positioned(
                                          left: 0,
                                          top: 20,
                                          child: _heroImage(_kBluePlane, width: 58),
                                        ),
                                        Positioned(
                                          right: 4,
                                          top: 4,
                                          child: _heroImage(_kTrophy, width: 54),
                                        ),
                                        Positioned(
                                          right: 2,
                                          top: 96,
                                          child: _heroImage(_kGreenLightning, width: 48),
                                        ),
                                        Positioned(
                                          left: 20,
                                          bottom: 52,
                                          child: _heroImage(_kLightbulb, width: 50),
                                        ),
                                        Positioned(
                                          right: 28,
                                          bottom: 44,
                                          child: _heroImage(_kSpeechChat, width: 48),
                                        ),
                                        Positioned(
                                          left: 4,
                                          bottom: 8,
                                          child: _heroImage(_kFire, width: 46),
                                        ),
                                        Positioned(
                                          right: 4,
                                          bottom: 4,
                                          child: _heroImage(_kThumbs, width: 52),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ColoredBox(
                          color: EashColors.black,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: kContentWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Verification Complete',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: EashColors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: kTitleBlockGap),
                                      Text(
                                        'Your student visa and identity have been successfully verified. '
                                        'Welcome to the EASH Social House community!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: EashColors.white.withValues(alpha: 0.88),
                                          fontSize: 14,
                                          height: 1.45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: kContentWidth,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: EashColors.white.withValues(alpha: 0.22),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 20,
                                        color: EashColors.white.withValues(alpha: 0.9),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Your credentials are securely encrypted and safely stored to '
                                          'protect your information.',
                                          style: TextStyle(
                                            color: EashColors.white.withValues(alpha: 0.75),
                                            fontSize: 12,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: kContentWidth,
                                  child: EashGradientButton(
                                    label: 'Go To Dashboard',
                                    height: 52,
                                    fontSize: 15,
                                    fillGradient: EashGradients.primary,
                                    contourGradient: kCtaRim,
                                    contourInset: 2,
                                    onPressed: () => _goDashboard(context),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Center(
                                  child: TextButton(
                                    onPressed: () => _goProfile(context),
                                    child: Text(
                                      'View My Profile',
                                      style: TextStyle(
                                        color: EashColors.white.withValues(alpha: 0.95),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            EashColors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            if (scaledH > h + 0.5) {
              return SingleChildScrollView(child: canvas);
            }
            return canvas;
          },
        ),
      ),
    );
  }
}
