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

  /// Grey card → title (modest gap; very large values + a bottom [Spacer] bunched the lower block).
  static const double _kCardToTitleGap = 70;

  /// Instruction block → [Next]; tune to match prototype.
  static const double _kInstructionToNextGap = 28;

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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: EashColors.mutedText),
                  ),
                ],
              ),
              SizedBox(height: _kHeaderToCardGap),
              Builder(
                builder: (BuildContext context) {
                  final MediaQueryData mq = MediaQuery.of(context);
                  final double cardH = mq.size.height * _kCardHeightFraction;
                  final Size frame = VisaDocumentFrameLayout.sizeWithin(
                    maxWidth: VisaDocumentFrameLayout.frameMaxWidth(mq),
                    maxHeight:
                        VisaDocumentFrameLayout.frameMaxHeightForCaptureRoute(mq),
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
                      child: frame.isEmpty
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
                                        VisaDocumentFrameLayout.innerClipRadius,
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
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                const Spacer(flex: _kCardLowerSpacerFlex),
                              ],
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: _kCardToTitleGap),
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
              SizedBox(height: _kInstructionToNextGap),
              EashGradientButton(
                label: 'Next',
                height: 58,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                    (Route<void> r) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}