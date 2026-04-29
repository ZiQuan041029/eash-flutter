import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import '../home/home_screen.dart';
import 'visa_document_frame_layout.dart';

/// Retake / confirm: **tall fixed-height** grey card; preview matches capture frame geometry.
class VisaConfirmationScreen extends StatelessWidget {
  const VisaConfirmationScreen({super.key});

  /// Same tall grey card as before (fraction of screen height), not shrink-wrapped.
  static const double _kCardHeightFraction = 0.535;

  /// Fixed gap between preview and Retake (prototype-style, not flush to card edge).
  static const double _kPreviewToRetakeGap = 50;

  /// More slack above preview than below Retake → shifts both **down** in the grey card.
  static const int _kCardUpperSpacerFlex = 2;
  static const int _kCardLowerSpacerFlex = 1;

  static const String _kRetakeIconAsset = 'assets/images/Retake.png';

  /// Space below status bar before back / step row.
  static const double _kHeaderTopInset = 10;

  /// Back row → grey card (tighter like prototype).
  static const double _kHeaderToCardGap = 16;

  /// Bottom block padding so it doesn't hug the edge.
  static const double _kBottomBlockPadding = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: VisaDocumentFrameLayout.captureHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: _kHeaderTopInset),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: EashColors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  Text(
                    'Step 2 of 3',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: EashColors.mutedText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _kHeaderToCardGap),
              Builder(
                builder: (BuildContext context) {
                  final MediaQueryData mq = MediaQuery.of(context);
                  final double viewportH = mq.size.height;
                  final bool shortScreen = viewportH < 720;
                  final double fraction =
                      shortScreen ? 0.56 : _kCardHeightFraction;

                  final double cardH =
                      (viewportH * fraction).clamp(240.0, 500.0);

                  // Card interior math:
                  // - Container padding: all(16) => 32px total vertical padding
                  // - Preview is the tall fixed-ish element
                  // - Gap between preview and Retake is fixed
                  // - Retake button height is fixed
                  //
                  // We size `frame` so the inner Column never exceeds cardH.
                  const double cardPaddingTotal = 32;
                  const double retakeButtonHeight = 58;
                  final double maxPreviewInCard =
                      cardH - cardPaddingTotal - _kPreviewToRetakeGap - retakeButtonHeight;
                  final double previewCap = maxPreviewInCard.clamp(
                    48.0,
                    VisaDocumentFrameLayout.frameMaxHeightForCaptureRoute(mq),
                  );

                  final Size frame = VisaDocumentFrameLayout.sizeWithin(
                    maxWidth: VisaDocumentFrameLayout.frameMaxWidth(mq),
                    maxHeight: previewCap,
                  );
                  return SizedBox(
                    height: cardH,
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: EashColors.cardGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          frame.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const Spacer(flex: _kCardUpperSpacerFlex),
                                  Center(
                                    child: SizedBox(
                                      width: frame.width,
                                      height: frame.height,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          VisaDocumentFrameLayout
                                              .innerClipRadius,
                                        ),
                                        child: const ColoredBox(
                                          color: Color(0xFF151515),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: _kPreviewToRetakeGap),
                                  EashOutlinedGradientButton(
                                    label: 'Retake',
                                    height: 58,
                                    labelFontSize: 18,
                                    labelFontWeight: FontWeight.w400,
                                    leading: Image.asset(
                                      _kRetakeIconAsset,
                                      width: 24,
                                      height: 24,
                                      filterQuality: FilterQuality.high,
                                    ),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                  const Spacer(flex: _kCardLowerSpacerFlex),
                                ],
                              ),
                    ),
                  );
                },
              ),
              // This spacer takes all remaining height so the bottom block
              // sits consistently near the bottom on every screen size.
              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: _kBottomBlockPadding),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Verify Your Student Visa',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: EashColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      kVisaInstruction,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: EashColors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                          ),
                    ),
                    const SizedBox(height: 20),
                    EashGradientButton(
                      label: 'Next',
                      height: 58,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomeScreen(),
                          ),
                          (Route<void> r) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
