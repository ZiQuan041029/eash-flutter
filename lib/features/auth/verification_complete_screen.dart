import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../home/home_screen.dart';

/// Post-registration success screen — Figma `03g-verification complete` (477:3350).
///
/// Layout is a fixed 393×852 canvas scaled with [FittedBox] so every `top`/`left`
/// value matches the Figma frame exactly.
class VerificationCompleteScreen extends StatelessWidget {
  const VerificationCompleteScreen({super.key});

  static const double kDesignW = 393;
  static const double kDesignH = 852;

  static const Color _white80 = Color(0xFFCCCCCC);

  static const LinearGradient kInfoBackground = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF525252), Color(0xFF737373)],
  );

  static const LinearGradient kCtaFill = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );

  static const String _kBanner = 'assets/images/verify_complete_banner.png';
  static const String _kInfoIcon = 'assets/images/verify_complete_info_icon.png';

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
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints c) {
          final double w = c.maxWidth;
          final double h = c.maxHeight;
          final double scaledH = kDesignH * (w / kDesignW);
          final double canvasH = scaledH > h ? scaledH : h;

          final Widget canvas = SizedBox(
            width: w,
            height: canvasH,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: kDesignW,
                height: kDesignH,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    const Positioned.fill(
                      child: ColoredBox(color: EashColors.black),
                    ),
                    // 477:3363 — full hero banner export (logo, icons, people photo).
                    const Positioned(
                      left: 0,
                      top: 0,
                      width: kDesignW,
                      height: 432,
                      child: _FigmaAsset(
                        _kBanner,
                        width: kDesignW,
                        height: 432,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 477:3353 — title block.
                    const Positioned(
                      left: 20,
                      right: 20,
                      top: 477,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Verification Complete',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: EashColors.white,
                              fontFamily: 'Helvetica',
                              fontFamilyFallback: <String>[
                                'Arial',
                                'sans-serif',
                              ],
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              height: 30 / 24,
                              letterSpacing: 0,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your student visa and identity have been\n'
                            'successfully verified. Welcome to the EASH\n'
                            'Social House community!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _white80,
                              fontFamily: 'Helvetica',
                              fontFamilyFallback: <String>[
                                'Arial',
                                'sans-serif',
                              ],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 22 / 16,
                              letterSpacing: 0,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 477:3356 — info box + CTAs.
                    Positioned(
                      left: 20,
                      right: 20,
                      top: 630,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: kInfoBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFFD9D9D9)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const _FigmaAsset(
                                    _kInfoIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Your credentials are securely encrypted and safely stored to '
                                      'protect your information.',
                                      style: TextStyle(
                                        color: _white80,
                                        fontFamily: 'Helvetica',
                                        fontFamilyFallback: const <String>[
                                          'Arial',
                                          'sans-serif',
                                        ],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 15 / 12,
                                        letterSpacing: 0,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _FigmaPrimaryButton(
                            label: 'Go to Dashboard',
                            onPressed: () => _goDashboard(context),
                          ),
                          SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () => _goProfile(context),
                              style: TextButton.styleFrom(
                                foregroundColor: EashColors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                              ),
                              child: const Text(
                                'View My Profile',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontFamilyFallback: <String>[
                                    'Arial',
                                    'sans-serif',
                                  ],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 25 / 18,
                                  letterSpacing: 0,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
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

class _FigmaAsset extends StatelessWidget {
  const _FigmaAsset(
    this.asset, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, Object? err, StackTrace? st) => SizedBox(
        width: width,
        height: height,
      ),
    );
  }
}

/// Figma 477:3361 — single gradient pill with 2px #FF4BFA border (no outer rim).
class _FigmaPrimaryButton extends StatelessWidget {
  const _FigmaPrimaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: VerificationCompleteScreen.kCtaFill,
        border: Border.all(color: const Color(0xFFFF4BFA), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: EashColors.white,
                  fontFamily: 'Helvetica',
                  fontFamilyFallback: <String>['Arial', 'sans-serif'],
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 25 / 18,
                  letterSpacing: 0,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
