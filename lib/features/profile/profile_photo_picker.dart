import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final ImagePicker _profileImagePicker = ImagePicker();

/// Opens the device camera and returns a profile photo file, or null if cancelled/denied.
Future<File?> captureProfilePhotoFromCamera(BuildContext context) {
  return pickProfilePhoto(context, source: ImageSource.camera);
}

/// Picks a profile photo from [source] (camera or gallery).
Future<File?> pickProfilePhoto(
  BuildContext context, {
  required ImageSource source,
}) async {
  if (source == ImageSource.camera) {
    final PermissionStatus cam = await Permission.camera.request();
    if (!cam.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required.')),
        );
      }
      return null;
    }
  }

  try {
    final XFile? picked = await _profileImagePicker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 88,
    );
    if (picked == null) {
      return null;
    }
    return File(picked.path);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick photo: $e')),
      );
    }
    return null;
  }
}
