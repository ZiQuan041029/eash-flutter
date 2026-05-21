import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/assets/eash_images.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_button.dart';

/// Mark-all-read confirmation (Figma) — blur backdrop + bottom sheet.
Future<bool> showMarkAllReadSheet(BuildContext context) async {
  final bool? result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> _) {
      return _MarkAllReadDialog(animation: animation);
    },
  );
  return result ?? false;
}

class _MarkAllReadDialog extends StatelessWidget {
  const _MarkAllReadDialog({required this.animation});

  final Animation<double> animation;

  static const Color _sheetBackground = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final Animation<double> fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
    final Animation<Offset> slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FadeTransition(
            opacity: fade,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withValues(alpha: 0.45)),
              ),
            ),
          ),
          SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: _sheetBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: EashColors.white,
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                EashImages.notiRead,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (_, Object? e, StackTrace? st) => Icon(
                                  Icons.notifications_active_outlined,
                                  color: EashColors.gradientBlue,
                                  size: 36,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              'Allow all current notifications to be',
                              textAlign: TextAlign.center,
                              style: text.titleSmall?.copyWith(
                                color: EashColors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              'marked as read?',
                              textAlign: TextAlign.center,
                              style: text.titleSmall?.copyWith(
                                color: EashColors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 28),
                            EashGradientButton(
                              label: 'Confirm',
                              height: 52,
                              fontSize: 16,
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'Cancel',
                                style: text.titleSmall?.copyWith(
                                  color: EashColors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
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
