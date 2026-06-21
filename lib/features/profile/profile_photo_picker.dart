import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

final ImagePicker _profileImagePicker = ImagePicker();

Future<bool> _ensurePermission(
  BuildContext context,
  Permission permission, {
  required String deniedMessage,
}) async {
  final PermissionStatus status = await permission.request();
  if (status.isGranted) {
    return true;
  }

  if (!context.mounted) {
    return false;
  }

  final bool canOpenSettings = status.isPermanentlyDenied || status.isRestricted;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(deniedMessage),
      action:
          canOpenSettings
              ? SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              )
              : null,
    ),
  );
  return false;
}

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
    final bool ok = await _ensurePermission(
      context,
      Permission.camera,
      deniedMessage: 'Camera permission is required.',
    );
    if (!context.mounted) return null;
    if (!ok) return null;
  } else {
    // On Android 13+ this maps to READ_MEDIA_IMAGES; on iOS to Photos.
    // Some devices/old Androids still require storage permission.
    final bool photosOk = await _ensurePermission(
      context,
      Permission.photos,
      deniedMessage: 'Photo permission is required to pick from gallery.',
    );
    if (!context.mounted) return null;
    if (!photosOk) {
      final bool storageOk = await _ensurePermission(
        context,
        Permission.storage,
        deniedMessage: 'Storage permission is required to pick from gallery.',
      );
      if (!context.mounted) return null;
      if (!storageOk) return null;
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
