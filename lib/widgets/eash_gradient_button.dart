import 'package:flutter/material.dart';

import '../core/theme/eash_theme.dart';

class EashGradientButton extends StatelessWidget {
  const EashGradientButton({
    required this.label,
    super.key,
    this.onPressed,
    this.enabled = true,
    this.fontSize = 16,
    this.height = 54,
    this.fontWeight = FontWeight.w700,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final double fontSize;
  final double height;
  final FontWeight fontWeight;

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
              height: height,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: EashColors.white,
                    fontWeight: fontWeight,
                    fontSize: fontSize,
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
    this.labelFontWeight = FontWeight.w700,
    this.leading,
    this.height = 50,
    this.labelFontSize = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final FontWeight labelFontWeight;
  final Widget? leading;
  final double height;
  final double labelFontSize;

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
            height: height,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (leading != null) ...<Widget>[
                    leading!,
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: foregroundColor,
                      fontWeight: labelFontWeight,
                      fontSize: labelFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
