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
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: EashColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    size: 36,
                    color: EashColors.gradientMagenta,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Allow eash to take pictures and record video?',
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 24),
                EashGradientButton(
                  label: 'Allow',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const VisaDocumentCaptureScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(
                      color: EashColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              top: MediaQuery.paddingOf(context).top + 8,
              left: 8,
              right: 24,
              bottom: 20,
            ),
            decoration: const BoxDecoration(gradient: EashGradients.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: EashColors.white),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    Text(
                      'Step 2 of 3',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: EashColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Enable Camera',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: EashColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  kCameraRationale,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: EashColors.white.withValues(alpha: 0.95),
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: EashColors.cardGrey,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: <Widget>[
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: Text(
                        'Privacy Protected',
                        style: TextStyle(
                          color: EashColors.mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: EashColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          size: 56,
                          color: EashColors.gradientMagenta,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: EashGradientButton(
              label: 'Enable Camera',
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
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
