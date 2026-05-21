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
    this.leading,
    /// Inner pill fill; default [EashGradients.primary] when null.
    this.fillGradient,
    /// Outer ring gradient; default [EashContour.rimGradient] when null.
    this.contourGradient,
    /// Gap between rim and fill; default [EashContour.inset].
    this.contourInset,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final double fontSize;
  final double height;
  final FontWeight fontWeight;
  final Widget? leading;
  final LinearGradient? fillGradient;
  final LinearGradient? contourGradient;
  final double? contourInset;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effective = enabled ? onPressed : null;
    final TextStyle textStyle = TextStyle(
      color: EashColors.white,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );

    final Widget labelWidget = Text(label, style: textStyle);

    final LinearGradient? innerFill =
        enabled ? (fillGradient ?? EashGradients.primary) : null;
    final LinearGradient outerRim =
        enabled
            ? (contourGradient ?? EashContour.rimGradient)
            : EashContour.rimGradientDisabled;

    final double insetPx = contourInset ?? EashContour.inset;
    final double innerRadius = height * 0.5;
    final BorderRadius innerBorderRadius = BorderRadius.circular(innerRadius);
    final BorderRadius outerBorderRadius = BorderRadius.circular(
      innerRadius + insetPx,
    );

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: outerBorderRadius,
          gradient: outerRim,
        ),
        padding: EdgeInsets.all(insetPx),
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: effective,
            borderRadius: innerBorderRadius,
            child: Ink(
              decoration: BoxDecoration(
                gradient: innerFill,
                color: enabled ? null : EashColors.disabledButton,
                borderRadius: innerBorderRadius,
              ),
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: Center(
                  child:
                      leading == null
                          ? labelWidget
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              leading!,
                              SizedBox(width: fontSize >= 18 ? 18 : 14),
                              labelWidget,
                            ],
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
    this.outerRimWidth = EashContour.inset,
    this.innerRimWidth = 2,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final FontWeight labelFontWeight;
  final Widget? leading;
  final double height;
  final double labelFontSize;
  /// Padding before the inner gradient ring (vertical rim visibility).
  final double outerRimWidth;
  /// Padding between inner gradient and white fill.
  final double innerRimWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: EashContour.rimGradient,
      ),
      padding: EdgeInsets.all(outerRimWidth),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: EashGradients.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: EdgeInsets.all(innerRimWidth),
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
      ),
    );
  }
}
