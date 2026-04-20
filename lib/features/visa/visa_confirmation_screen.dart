import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import '../home/home_screen.dart';
import 'visa_document_capture_screen.dart';

class VisaConfirmationScreen extends StatelessWidget {
  const VisaConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EashColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: EashColors.mutedText),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: EashColors.cardGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 200,
                                color: const Color(0xFF2C2C2E),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text('🪪', style: TextStyle(fontSize: 56)),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Malaysian Student’s Pass',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '(mock capture)',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: EashColors.mutedText,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 12,
                                      bottom: 10,
                                      child: Transform.rotate(
                                        angle: -0.35,
                                        child: Text(
                                          'sample',
                                          style: TextStyle(
                                            color: Colors.red.shade400,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            EashOutlinedGradientButton(
                              label: 'Retake',
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const VisaDocumentCaptureScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Verify Your Student Visa',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        kVisaInstruction,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: EashColors.white.withValues(alpha: 0.85),
                              height: 1.45,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              EashGradientButton(
                label: 'Next',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                    (Route<void> r) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
