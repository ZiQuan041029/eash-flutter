import 'dart:math' show max;

import 'package:flutter/material.dart';

/// Back / exit control using `assets/images/Exit.png`.
class EashExitIconButton extends StatelessWidget {
  const EashExitIconButton({
    super.key,
    required this.onPressed,
    this.iconSize = 24,
    this.minTapSize = 40,
  });

  final VoidCallback onPressed;
  final double iconSize;
  final double minTapSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: max(minTapSize, iconSize + 16),
        minHeight: max(minTapSize, iconSize + 16),
      ),
      icon: Image.asset(
        'assets/images/Exit.png',
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
      onPressed: onPressed,
    );
  }
}
