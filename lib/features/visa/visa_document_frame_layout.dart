import 'package:flutter/material.dart';

/// Shared sizing rules for the visa document capture frame across screens.
///
/// This file is referenced by multiple Visa flow screens; keep this API stable.
class VisaDocumentFrameLayout {
  const VisaDocumentFrameLayout._();

  /// Horizontal padding used by capture/confirmation screens.
  ///
  /// Must be `const` because it is used inside `const EdgeInsets`.
  static const double captureHorizontalPadding = 24;

  /// Inner clip radius for the document preview/capture content.
  static const double innerClipRadius = 12;

  /// Approximate aspect ratio of an ID/visa card (width / height).
  static const double _kDocumentAspectRatio = 1.586;

  /// Returns a frame size that fits within the given bounds while preserving the
  /// document aspect ratio.
  static Size sizeWithin({
    required double maxWidth,
    required double maxHeight,
  }) {
    if (maxWidth <= 0 || maxHeight <= 0) return Size.zero;

    double width = maxWidth;
    double height = width / _kDocumentAspectRatio;

    if (height > maxHeight) {
      height = maxHeight;
      width = height * _kDocumentAspectRatio;
    }

    if (width.isNaN || height.isNaN || width <= 0 || height <= 0) {
      return Size.zero;
    }
    return Size(width, height);
  }

  /// Maximum width available for the capture frame on screens that use the
  /// shared horizontal padding.
  static double frameMaxWidth(MediaQueryData mq) {
    final double w = mq.size.width - (captureHorizontalPadding * 2);
    return w.isFinite ? w.clamp(0.0, double.infinity) : 0;
  }

  /// Approximate maximum height for the capture frame in the capture route.
  ///
  /// Used by confirmation screen to match the capture frame geometry without
  /// depending on the capture screen's internal constraints.
  static double frameMaxHeightForCaptureRoute(MediaQueryData mq) {
    final double h = mq.size.height * 0.26;
    return h.isFinite ? h.clamp(160.0, 320.0) : 0;
  }
}

