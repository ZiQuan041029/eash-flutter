import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import 'visa_confirmation_screen.dart';
import 'visa_document_frame_layout.dart';

/// Two-part layout: **upper** = wood + uniform light dim (including inside frame) + dashed border;
/// **line** separator; **lower** = solid black dock + shutter centered in dock only.
class VisaDocumentCaptureScreen extends StatelessWidget {
  const VisaDocumentCaptureScreen({super.key});

  static const String _kBackgroundAsset = 'assets/images/background_visa.png';
  static const String _kShutterIconAsset = 'assets/images/camera_visa.png';

  static const double _kShutterDiameter = 84;
  static const double _kBlackBarCoreHeight = 120;

  static const double _kFrameInnerPadding = 10;
  static const double _kFrameInnerRadius = 12;

  /// Uniform dim over the **whole** upper area (frame included).
  static const double _kUpperDimAlpha = 0.56;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(
                    _kBackgroundAsset,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: _kUpperDimAlpha),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: EashColors.white),
                                onPressed: () => Navigator.of(context).maybePop(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Verify Your Visa',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                kAlignVisaHint,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: EashColors.mutedText,
                                      fontSize: 17,
                                      height: 1.45,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: VisaDocumentFrameLayout.captureHorizontalPadding,
                          ),
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints c) {
                              final Size frame = VisaDocumentFrameLayout.sizeWithin(
                                maxWidth: c.maxWidth,
                                maxHeight: c.maxHeight,
                              );
                              return Align(
                                alignment: const Alignment(0, -0.35),
                                child: SizedBox(
                                  width: frame.width,
                                  height: frame.height,
                                  child: CustomPaint(
                                    painter: _DashedBorderPainter(
                                      color: EashColors.white.withValues(alpha: 0.85),
                                      strokeWidth: 2,
                                      radius: 16,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(_kFrameInnerPadding),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(_kFrameInnerRadius),
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White separator between upper camera stage and black dock.
          const SizedBox(
            height: 1,
            child: ColoredBox(color: Colors.white),
          ),
          SafeArea(
            top: false,
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: _kBlackBarCoreHeight + bottomInset,
                width: double.infinity,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const VisaConfirmationScreen(),
                          ),
                        );
                      },
                      child: Ink(
                        width: _kShutterDiameter,
                        height: _kShutterDiameter,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: EashGradients.primary,
                        ),
                        child: Center(
                          child: Image.asset(
                            _kShutterIconAsset,
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final Path path = Path()..addRRect(rrect);
    final Path dashed = _dashPath(path, 8, 6);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source, double dashLength, double gapLength) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        dest.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth || oldDelegate.radius != radius;
  }
}