import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/visa/visa_document_capture_screen.dart';

/// Requests the **native** camera permission (Android / iOS system UI), then
/// opens the visa capture flow when granted.
Future<void> openVisaDocumentCapture(BuildContext context) async {
  final PermissionStatus status = await Permission.camera.request();
  if (!context.mounted) return;

  if (status.isGranted) {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const VisaDocumentCaptureScreen(),
      ),
    );
    return;
  }

  final String message = status.isPermanentlyDenied
      ? 'Camera access is off. Enable it in Settings to capture your visa.'
      : 'Camera access is needed to photograph your document.';

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
