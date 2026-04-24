import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/eash_theme.dart';
import 'camera_permission_screen.dart';

class VisaVerificationScreen extends StatelessWidget {
  const VisaVerificationScreen({super.key});

  static const String kVisaInstruction =
      'Ensure all details, including your full name, institution, and expiry date, are clearly legible in the preview above.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. HEADER ROW (Padded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: EashColors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Text(
                    'Step 2 of 3',
                    style: TextStyle(
                      color: EashColors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Tight gap under header so the review card sits higher (no huge empty band).
            const SizedBox(height: 4),

            // 2. THE GLASS CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: SizedBox(
                    // Give the card an explicit height so it can't collapse.
                    height: 550,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: EashColors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: EashColors.white.withOpacity(0.12),
                          width: 0,
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background fills the whole card; never crash if asset missing.
                          Image.asset(
                            'assets/images/background_verify.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            filterQuality: FilterQuality.high,
                            errorBuilder:
                                (_, _, _) =>
                                    const ColoredBox(color: Color(0xFF1C1C1E)),
                          ),
                          Container(color: Colors.black.withOpacity(0.22)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Fills space between top and button; preview sits upper area
                                // (no Spacer flex that shoves everything to the bottom).
                                Expanded(
                                  child: Align(
                                    // Lower in the card (above Take Photo); y toward +1 = further down.
                                    alignment: const Alignment(0, 0.35),
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/images/doc_prev.png',
                                            width: 48,
                                            height: 48,
                                            color: EashColors.white,
                                            errorBuilder:
                                                (_, _, _) => Icon(
                                                  Icons.insert_drive_file_outlined,
                                                  size: 48,
                                                  color: EashColors.white
                                                      .withOpacity(0.9),
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Text(
                                            'Document Preview',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: EashColors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const CameraPermissionScreen(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 300,
                                    height: 52,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: EashGradients.primary,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/photo_verify.png',
                                            width: 20,
                                            height: 20,
                                            color: EashColors.white,
                                            errorBuilder:
                                                (_, _, _) => const Icon(
                                                  Icons.photo_camera_outlined,
                                                  color: EashColors.white,
                                                  size: 20,
                                                ),
                                          ),
                                          const SizedBox(width: 20),
                                          const Text(
                                            'Take Photo',
                                            style: TextStyle(
                                              color: EashColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Small gap between card and title (avoid large dead space).
            const SizedBox(height: 16),

            // 3. TEXT DESCRIPTION SECTION (Padded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    'Verify Your Student Visa',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: EashColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    kVisaInstruction,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: EashColors.white.withOpacity(0.6),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. DISABLED "NEXT" BUTTON (Padded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: EashColors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: EashColors.white.withOpacity(0.3),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}