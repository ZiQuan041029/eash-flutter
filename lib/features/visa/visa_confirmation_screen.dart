import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/network/auth_api.dart';
import '../../core/network/upload_api.dart';
import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_exit_icon_button.dart';
import '../../widgets/eash_gradient_button.dart';
import '../auth/register_screen.dart';
import 'visa_document_frame_layout.dart';

/// Retake / confirm: **tall fixed-height** grey card; preview matches capture frame geometry.
class VisaConfirmationScreen extends StatelessWidget {
  const VisaConfirmationScreen({super.key, this.capturedImagePath});

  /// Local file from camera capture; when set, [Next] uploads to R2 then continues.
  final String? capturedImagePath;

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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewport) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: viewport.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VisaDocumentFrameLayout.captureHorizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: _kHeaderTopInset),
                          Row(
                            children: <Widget>[
                              EashExitIconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
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
                                                      VisaDocumentFrameLayout.innerClipRadius,
                                                    ),
                                                    child:
                                                        capturedImagePath != null &&
                                                                capturedImagePath!.isNotEmpty
                                                            ? Image.file(
                                                                File(capturedImagePath!),
                                                                fit: BoxFit.cover,
                                                                errorBuilder:
                                                                    (_, _, _) =>
                                                                        const ColoredBox(
                                                                          color: Color(
                                                                            0xFF151515,
                                                                          ),
                                                                        ),
                                                              )
                                                            : const ColoredBox(
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
                                                outerRimWidth: 1.25,
                                                innerRimWidth: 1.25,
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: _kBottomBlockPadding,
                        ),
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
                              onPressed: () async {
                                final String? path = capturedImagePath;
                                int? uploadId;
                                if (path != null && path.isNotEmpty) {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(
                                      child: CircularProgressIndicator(
                                        color: EashColors.white,
                                      ),
                                    ),
                                  );
                                  try {
                                    final res = await UploadApi(
                                      http.Client(),
                                    ).uploadVisaGuest(File(path));
                                    uploadId = res.uploadId;
                                  } on ApiException catch (e) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.message,
                                          ),
                                        ),
                                      );
                                    }
                                    return;
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('$e')),
                                      );
                                    }
                                    return;
                                  }
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                                if (!context.mounted) return;
                                if (uploadId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Upload id missing. Please try again.'),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        RegisterScreen(visaUploadId: uploadId),
                                  ),
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
          },
        ),
      ),
    );
  }
}
