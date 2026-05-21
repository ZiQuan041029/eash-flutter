import 'dart:async';
import 'dart:math' show Random, sin, pi;

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';
import '../auth/login_screen.dart';
import '../onboarding/interests_screen.dart';

/// Figma frame **01-welcome** — all layers positioned in this 390×882 box.
abstract final class _LandingFigma {
  static const double width = 390;
  static const double height = 882;
}

/// Horizontal / vertical scale from Figma frame → device (fills the screen).
({double sx, double sy}) _landingScales(double screenW, double screenH) {
  return (sx: screenW / _LandingFigma.width, sy: screenH / _LandingFigma.height);
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              EashImages.landingBack,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final ({double sx, double sy}) scales = _landingScales(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              return _LandingFigmaArtboard(
                screenWidth: constraints.maxWidth,
                screenHeight: constraints.maxHeight,
                scaleX: scales.sx,
                scaleY: scales.sy,
              );
            },
          ),
          // Random greeting bubbles drift left → right across the hero art.
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;
              final double topPad = MediaQuery.paddingOf(context).top;
              return _RandomGreetingBubbles(
                screenWidth: w,
                screenHeight: h,
                topPadding: topPad,
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
                    // Keep button left → right (prototype).
                    fillGradient: EashGradients.primary, // blue → pink (inner)
                    contourGradient: EashContour.rimContinueCta, // pink → blue (outer)
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

/// Full-screen Figma hero — paint order bottom → top.
class _LandingFigmaArtboard extends StatelessWidget {
  const _LandingFigmaArtboard({
    required this.screenWidth,
    required this.screenHeight,
    required this.scaleX,
    required this.scaleY,
  });

  final double screenWidth;
  final double screenHeight;
  final double scaleX;
  final double scaleY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // img-coffee — behind student
          _layer(
            EashImages.landingCoffeeCup,
            width: 220,
            height: 86,
            left: 227,
            top: 262,
            rotationDeg: 0,
          ),
          // img-student — wider than 390 Figma frame; span screen width
          _layer(
            EashImages.landingStudent,
            width: 471,
            height: 384,
            left: 0,
            top: 233,
            fit: BoxFit.fitWidth,
            alignment: Alignment.centerLeft,
            spanScreenWidth: true,
          ),
          // img-pizza
          _layer(
            EashImages.landingPizza,
            width: 122.08,
            height: 200.78,
            left: 50,
            top: 190,
            rotationDeg: 0,
          ),
          // img-nasi-lemak / malaysian food
          _layer(
            EashImages.landingFood,
            width: 210.24,
            height: 134.66,
            left: -55,
            top: 566,
            rotationDeg: 0,
          ),
          // img-pickleball
          _layer(
            EashImages.landingPickleball,
            width: 52,
            height: 53,
            left: 329,
            top: 557,
          ),
          // logo-ea-social-house (Landing_name.png)
          _layer(
            EashImages.landingName,
            width: 227,
            height: 158,
            left: 83,
            top: 81,
          ),
        ],
      ),
    );
  }

  Widget _layer(
    String asset, {
    required double width,
    required double height,
    required double left,
    required double top,
    double rotationDeg = 0,
    Alignment alignment = Alignment.center,
    BoxFit fit = BoxFit.contain,
    bool spanScreenWidth = false,
  }) {
    if (spanScreenWidth) {
      return Positioned(
        left: left * scaleX,
        top: top * scaleY,
        right: 0,
        height: height * scaleY,
        child: _LandingLayerImage(
          asset: asset,
          rotationDeg: rotationDeg,
          alignment: alignment,
          fit: fit,
        ),
      );
    }

    return Positioned(
      left: left * scaleX,
      top: top * scaleY,
      width: width * scaleX,
      height: height * scaleY,
      child: _LandingLayerImage(
        asset: asset,
        rotationDeg: rotationDeg,
        alignment: alignment,
        fit: fit,
      ),
    );
  }
}

class _LandingLayerImage extends StatelessWidget {
  const _LandingLayerImage({
    required this.asset,
    this.rotationDeg = 0,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double rotationDeg;
  final Alignment alignment;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Widget child = Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      width: fit == BoxFit.fitWidth ? double.infinity : null,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, Object? e, StackTrace? st) => const SizedBox.shrink(),
    );

    if (rotationDeg != 0) {
      child = Transform.rotate(
        angle: rotationDeg * pi / 180,
        child: child,
      );
    }

    return child;
  }
}

/// Greeting phrases (random pick for landing bubbles).
const List<String> _kLandingGreetingPhrases = <String>[
  'Hello',
  'Halo',
  'வணக்கம்',
  'नमस्ते',
  'হ্যালো',
  '你好',
  'নমস্কার',
  'สวัสดี',
  'Xin chào',
  'こんにちは',
  '안녕하세요',
  'مرحبا',
  'Habari',
  'Hola',
  'Bonjour',
  'Сәлем',
];

const List<List<Color>> _kBubbleGradients = <List<Color>>[
  <Color>[Color(0xFFDBFFB7), Color(0xFF80FF00)],
  <Color>[Color(0xFF91A3FF), Color(0xFF002BFF)],
  <Color>[Color(0xFFFFFFFF), Color(0xFFFFEA00)],
  <Color>[Color(0xFFFFB7E8), Color(0xFFFF0080)],
  <Color>[Color(0xFFB7FFF6), Color(0xFF00D4AA)],
  <Color>[Color(0xFFFFE0B7), Color(0xFFFF8C00)],
];

class _RandomGreetingBubbles extends StatefulWidget {
  const _RandomGreetingBubbles({
    required this.screenWidth,
    required this.screenHeight,
    required this.topPadding,
  });

  final double screenWidth;
  final double screenHeight;
  final double topPadding;

  @override
  State<_RandomGreetingBubbles> createState() => _RandomGreetingBubblesState();
}

class _RandomGreetingBubblesState extends State<_RandomGreetingBubbles> {
  static const int _maxBubbles = 7;
  final Random _random = Random();
  Timer? _spawnTimer;
  final List<_BubbleSpawn> _active = <_BubbleSpawn>[];
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _spawnBubble();
      _scheduleNextSpawn();
    });
  }

  void _scheduleNextSpawn() {
    _spawnTimer?.cancel();
    final int delayMs = 1600 + _random.nextInt(2200);
    _spawnTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      if (_active.length < _maxBubbles) {
        _spawnBubble();
      }
      _scheduleNextSpawn();
    });
  }

  void _spawnBubble() {
    if (_active.length >= _maxBubbles) return;
    final String phrase =
        _kLandingGreetingPhrases[_random.nextInt(_kLandingGreetingPhrases.length)];
    final List<Color> colors =
        _kBubbleGradients[_random.nextInt(_kBubbleGradients.length)];
    final bool lightText = colors.first.computeLuminance() < 0.45;
    final double top = widget.topPadding +
        widget.screenHeight * (0.20 + _random.nextDouble() * 0.38);
    final int durationMs = 9000 + _random.nextInt(8000);
    final double waveCycles = 2.0 + _random.nextDouble() * 3.0;
    final double bobAmplitude = 12.0 + _random.nextDouble() * 18.0;
    final int id = _nextId++;
    setState(() {
      _active.add(
        _BubbleSpawn(
          id: id,
          phrase: phrase,
          colors: colors,
          textColor: lightText ? Colors.white : Colors.black,
          top: top,
          durationMs: durationMs,
          waveCycles: waveCycles,
          bobAmplitude: bobAmplitude,
        ),
      );
    });
  }

  void _onBubbleDone(int id) {
    if (!mounted) return;
    setState(() {
      _active.removeWhere((_BubbleSpawn s) => s.id == id);
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        for (final _BubbleSpawn s in _active)
          _FloatingBubble(
            key: ValueKey<int>(s.id),
            id: s.id,
            phrase: s.phrase,
            colors: s.colors,
            textColor: s.textColor,
            top: s.top,
            screenWidth: widget.screenWidth,
            durationMs: s.durationMs,
            waveCycles: s.waveCycles ?? 3.0,
            bobAmplitude: s.bobAmplitude ?? 16.0,
            onDone: _onBubbleDone,
          ),
      ],
    );
  }
}

class _BubbleSpawn {
  _BubbleSpawn({
    required this.id,
    required this.phrase,
    required this.colors,
    required this.textColor,
    required this.top,
    required this.durationMs,
    this.waveCycles,
    this.bobAmplitude,
  });

  final int id;
  final String phrase;
  final List<Color> colors;
  final Color textColor;
  final double top;
  final int durationMs;
  /// Hot reload can leave older instances without these; coalesce when building.
  final double? waveCycles;
  final double? bobAmplitude;
}

class _FloatingBubble extends StatefulWidget {
  const _FloatingBubble({
    super.key,
    required this.id,
    required this.phrase,
    required this.colors,
    required this.textColor,
    required this.top,
    required this.screenWidth,
    required this.durationMs,
    required this.waveCycles,
    required this.bobAmplitude,
    required this.onDone,
  });

  final int id;
  final String phrase;
  final List<Color> colors;
  final Color textColor;
  final double top;
  final double screenWidth;
  final int durationMs;
  final double waveCycles;
  final double bobAmplitude;
  final void Function(int id) onDone;

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          widget.onDone(widget.id);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double offscreenLead = 280;
    final double travel = widget.screenWidth + offscreenLead + 120;
    return Positioned(
      top: widget.top,
      left: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double t = _controller.value;
          final double x = -offscreenLead + travel * t;
          final double y =
              widget.bobAmplitude * sin(t * widget.waveCycles * 2 * pi);
          return Transform.translate(
            offset: Offset(x, y),
            child: child,
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: _GreetingPill(
              colors: widget.colors,
              text: widget.phrase,
              textColor: widget.textColor,
              direction: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingPill extends StatelessWidget {
  const _GreetingPill({
    required this.colors,
    required this.text,
    required this.textColor,
    this.direction = Axis.horizontal,
  });

  final List<Color> colors;
  final String text;
  final Color textColor;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: direction == Axis.horizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: direction == Axis.horizontal ? Alignment.centerRight : Alignment.bottomCenter,
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