import 'package:flutter/material.dart';

import '../core/theme/eash_theme.dart';
import 'eash_exit_icon_button.dart';

/// Padding and height for gradient headers — matches [HomeScreen] top bar.
abstract final class EashGradientHeaderMetrics {
  /// Minimum height of the header content row (home search/noti icons use 48).
  static const double contentMinHeight = 48;

  static const double topBelowSafeArea = 14;
  static const double bottom = 14;
  static const double leading = 18;
  static const double leadingWithBack = 4;
  static const double trailing = 10;
  static const double trailingWithBack = 12;

  static EdgeInsets paddingOf(
    BuildContext context, {
    bool backButton = false,
    double? trailingOverride,
  }) {
    final double top = MediaQuery.paddingOf(context).top;
    return EdgeInsets.fromLTRB(
      backButton ? leadingWithBack : leading,
      top + topBelowSafeArea,
      trailingOverride ?? (backButton ? trailingWithBack : trailing),
      bottom,
    );
  }

  /// Symmetric gutters for centered titles (e.g. Profile tab without back).
  static EdgeInsets centeredTitlePadding(BuildContext context) {
    final double top = MediaQuery.paddingOf(context).top;
    return EdgeInsets.fromLTRB(
      leading,
      top + topBelowSafeArea,
      leading,
      bottom,
    );
  }
}

/// Blue → magenta bar used on Home and pushed screens.
class EashGradientHeader extends StatelessWidget {
  const EashGradientHeader({
    super.key,
    required this.child,
    this.padding,
    this.backButton = false,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: EashGradients.primary),
      padding:
          padding ??
          EashGradientHeaderMetrics.paddingOf(
            context,
            backButton: backButton,
          ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: EashGradientHeaderMetrics.contentMinHeight,
        ),
        child: child,
      ),
    );
  }
}

/// Back control using [EashImages.exit] (same as auth / visa flows).
class EashGradientHeaderBackButton extends StatelessWidget {
  const EashGradientHeaderBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return EashExitIconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      iconSize: 24,
      minTapSize: 48,
    );
  }
}

/// Centered title with optional back + trailing (balanced 48px slots).
class EashGradientTitleHeader extends StatelessWidget {
  const EashGradientTitleHeader({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.titleStyle,
    this.padding,
  });

  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;

  static const TextStyle _defaultTitleStyle = TextStyle(
    color: EashColors.white,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return EashGradientHeader(
      backButton: showBack,
      padding:
          padding ??
          (showBack
              ? EashGradientHeaderMetrics.paddingOf(context, backButton: true)
              : EashGradientHeaderMetrics.centeredTitlePadding(context)),
      child: Row(
        children: <Widget>[
          if (showBack)
            EashGradientHeaderBackButton(onPressed: onBack)
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? _defaultTitleStyle,
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: Center(child: trailing),
          ),
        ],
      ),
    );
  }
}
