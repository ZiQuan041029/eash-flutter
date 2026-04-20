import 'package:flutter/material.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import '../../widgets/eash_gradient_button.dart';
import 'camera_permission_screen.dart';

class VisaVerificationScreen extends StatelessWidget {
  const VisaVerificationScreen({super.key});

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
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: EashColors.cardGrey,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C2E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 48,
                                  color: EashColors.white.withValues(alpha: 0.85),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Document Preview',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: EashColors.white.withValues(alpha: 0.9),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(999),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => const CameraPermissionScreen(),
                                    ),
                                  );
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: EashGradients.primary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(Icons.photo_camera_outlined, color: EashColors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Take Photo',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: EashColors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
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
              const Opacity(
                opacity: 0.55,
                child: EashGradientButton(
                  label: 'Next',
                  enabled: false,
                  onPressed: null,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
