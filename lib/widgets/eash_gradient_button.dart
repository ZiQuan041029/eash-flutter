import 'package:flutter/material.dart';

import '../core/theme/eash_theme.dart';

class EashGradientButton extends StatelessWidget {
  const EashGradientButton({
    required this.label,
    super.key,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effective = enabled ? onPressed : null;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effective,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            decoration: BoxDecoration(
              gradient: enabled ? EashGradients.primary : null,
              color: enabled ? null : EashColors.disabledButton,
              borderRadius: BorderRadius.circular(999),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: EashColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EashOutlinedGradientButton extends StatelessWidget {
  const EashOutlinedGradientButton({
    required this.label,
    super.key,
    this.onPressed,
    this.foregroundColor = EashColors.black,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: EashGradients.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(2),
      child: Material(
        color: EashColors.white,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
