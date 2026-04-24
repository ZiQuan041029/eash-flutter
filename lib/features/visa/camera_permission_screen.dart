import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import 'visa_document_capture_screen.dart';

class CameraPermissionScreen extends StatelessWidget {
  const CameraPermissionScreen({super.key});

  Future<void> _showPermissionDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext ctx) {
        final Size size = MediaQuery.sizeOf(ctx);
        // Larger popup like requested (~4/10 to ~5/10), clamped for small screens.
        final double cardHeight = (size.height * 0.28).clamp(340.0, 460.0);

        return Stack(
          children: <Widget>[
            // Blur + dim the background while dialog is open.
            Positioned.fill(
              child: BackdropFilter(
                // Subtle blur (prototype-style). Heavy blur looks unprofessional.
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withOpacity(0.45)),
              ),
            ),
            Dialog(
              alignment: Alignment.bottomCenter,
              // Lower the popup (small bottom inset).
              // Wider like prototype (less side space).
              // Stick the popup to the very bottom edge.
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: SizedBox(
                width: double.infinity,
                height: cardHeight,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    22,
                    24,
                    18 + MediaQuery.paddingOf(ctx).bottom,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16),
                      // Icon INSIDE the box (not floating).
                      Container(
                        width: 90,
                        height: 90,
                        decoration: const BoxDecoration(
                          color: EashColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/camera.png',
                            // Make the icon itself clearly larger (not just the circle).
                            width: 85,
                            height: 85,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (_, _, _) => const Icon(
                                  Icons.photo_camera_outlined,
                                  size: 72,
                                  color: EashColors.gradientMagentaDark,
                                ),
                          ),
                        ),
                      ),
                      // Bigger gap between icon and text (as prototype).
                      const SizedBox(height: 20),
                      Text(
                        'Allow EASH to take pictures\nand record video?',
                        textAlign: TextAlign.center,
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          color: EashColors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: EashGradientButton(
                          label: 'Allow',
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder:
                                    (_) => const VisaDocumentCaptureScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Don\'t Allow',
                          style: TextStyle(
                            color: EashColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 20,
              left: 8,
              right: 24,
              // Taller purple header like prototype.
              bottom: 32,
            ),
            decoration: const BoxDecoration(gradient: EashGradients.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: EashColors.white,
                      ),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    Text(
                      'Step 2 of 3',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: EashColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  // Nudge title to the right without moving the back button row.
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Enable Camera',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: EashColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  // Same nudge for the subtitle/description.
                  padding: const EdgeInsets.only(left: 22),
                  child: ConstrainedBox(
                    // Constrain width so copy wraps to ~3 lines like the prototype.
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      kCameraRationale,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: EashColors.white.withOpacity(0.95),
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Slightly larger like prototype.
                  const double kCardHeight = 330;
                  const double kCardMaxWidth = 365;
                  final double cardWidth = math.min(
                    kCardMaxWidth,
                    constraints.maxWidth,
                  );

                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: cardWidth,
                          height: kCardHeight,
                          child: ColoredBox(
                            color: EashColors.cardGrey,
                            child: Center(
                              child: Image.asset(
                                'assets/images/Background_verify_2.png',
                                // IMPORTANT: don't crop/zoom the PNG.
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                filterQuality: FilterQuality.high,
                                errorBuilder:
                                    (_, _, _) => Icon(
                                      Icons.broken_image_outlined,
                                      size: 48,
                                      color: EashColors.white.withOpacity(0.4),
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: EashGradientButton(
              label: 'Enable Camera',
              fontSize: 15,
              onPressed: () => _showPermissionDialog(context),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text(
              'Maybe Later',
              style: TextStyle(
                color: EashColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          // Extra bottom safe-area padding so buttons sit higher on emulators.
          SizedBox(height: 12 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}