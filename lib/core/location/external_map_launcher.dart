import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/eash_theme.dart';
import 'user_location_store.dart';

enum ExternalMapApp { googleMaps, waze, appleMaps }

/// Opens Google Maps / Waze / Apple Maps picker for turn-by-turn navigation.
Future<void> startExternalNavigation(
  BuildContext context, {
  required String name,
  required double? latitude,
  required double? longitude,
  String? address,
}) async {
  await UserLocationStore.instance.ensureLocation(refresh: true);

  if (!context.mounted) {
    return;
  }

  if (UserLocationStore.instance.navigationOrigin == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not read your GPS. Try again.'),
      ),
    );
    return;
  }

  final String destinationLabel = formatDestinationLabel(
    title: name,
    address: address,
  );
  if (destinationLabel.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Directions are not available for this place yet.'),
      ),
    );
    return;
  }

  await showExternalMapPicker(
    context,
    destinationLabel: destinationLabel,
  );
}

bool locationReadyForDirections(LocationEnsureResult result) {
  return switch (result) {
    LocationEnsureResult.granted ||
    LocationEnsureResult.alreadyGranted =>
      UserLocationStore.instance.navigationOrigin != null,
    _ => false,
  };
}

String locationBlockedMessage(LocationEnsureResult result) {
  return switch (result) {
    LocationEnsureResult.serviceDisabled =>
      'Turn on location services to get directions.',
    LocationEnsureResult.denied =>
      'Allow location access on Discover first, then try again.',
    LocationEnsureResult.deniedForever =>
      'Location access is off. Enable it in Settings to get directions.',
    LocationEnsureResult.error => 'Could not read your location. Try again.',
    LocationEnsureResult.granted ||
    LocationEnsureResult.alreadyGranted =>
      'Could not read your GPS. Set your location and try again.',
  };
}

/// Venue label for map apps — name + address from synced database fields.
String formatDestinationLabel({
  required String title,
  String? address,
}) {
  final List<String> parts = <String>[];
  final String trimmedTitle = title.trim();
  final String trimmedAddress = address?.trim() ?? '';
  if (trimmedTitle.isNotEmpty) {
    parts.add(trimmedTitle);
  }
  if (trimmedAddress.isNotEmpty) {
    parts.add(trimmedAddress);
  }
  if (parts.isEmpty) {
    return trimmedTitle;
  }
  var label = parts.join(', ');
  if (!label.toLowerCase().contains('malaysia')) {
    label = '$label, Malaysia';
  }
  return label;
}

/// Bottom sheet — user picks which map app opens with full directions.
Future<void> showExternalMapPicker(
  BuildContext context, {
  required String destinationLabel,
}) async {
  if (!context.mounted) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF1D1D1D),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext sheetContext) {
      final List<_MapOption> options = <_MapOption>[
        _MapOption(
          app: ExternalMapApp.googleMaps,
          label: 'Google Maps',
          icon: Icons.map_outlined,
        ),
        _MapOption(
          app: ExternalMapApp.waze,
          label: 'Waze',
          icon: Icons.navigation_outlined,
        ),
        if (Platform.isIOS)
          _MapOption(
            app: ExternalMapApp.appleMaps,
            label: 'Apple Maps',
            icon: Icons.map_rounded,
          ),
      ];

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: EashColors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Open in Maps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: EashColors.white,
                  fontFamily: 'Helvetica',
                  fontFamilyFallback: <String>['Arial', 'sans-serif'],
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 25 / 18,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              for (final _MapOption option in options) ...<Widget>[
                _MapPickerTile(
                  label: option.label,
                  icon: option.icon,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    final bool opened = await launchExternalMap(
                      app: option.app,
                      destinationLabel: destinationLabel,
                    );
                    if (!context.mounted || opened) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open ${option.label}.'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      );
    },
  );
}

/// Opens turn-by-turn directions: device GPS → venue name/address label.
Future<bool> launchExternalMap({
  required ExternalMapApp app,
  required String destinationLabel,
}) async {
  switch (app) {
    case ExternalMapApp.googleMaps:
      return _launchGoogleMaps(destinationLabel: destinationLabel);
    case ExternalMapApp.waze:
      return _launchWaze(destinationLabel: destinationLabel);
    case ExternalMapApp.appleMaps:
      return _launchAppleMaps(destinationLabel: destinationLabel);
  }
}

/// Google Maps — no origin param (shows "Your location"); venue label as destination.
Future<bool> _launchGoogleMaps({required String destinationLabel}) async {
  final Uri uri = Uri.https(
    'www.google.com',
    '/maps/dir/',
    <String, String>{
      'api': '1',
      'destination': destinationLabel,
    },
  );
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> _launchWaze({required String destinationLabel}) async {
  final Uri uri = Uri.https(
    'waze.com',
    '/ul',
    <String, String>{
      'q': destinationLabel,
      'navigate': 'yes',
    },
  );
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<bool> _launchAppleMaps({required String destinationLabel}) async {
  final Uri uri = Uri.https(
    'maps.apple.com',
    '/',
    <String, String>{
      'daddr': destinationLabel,
      'dirflg': 'd',
    },
  );
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _MapOption {
  const _MapOption({
    required this.app,
    required this.label,
    required this.icon,
  });

  final ExternalMapApp app;
  final String label;
  final IconData icon;
}

class _MapPickerTile extends StatelessWidget {
  const _MapPickerTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EashColors.black,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              Icon(icon, color: EashColors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: EashColors.white,
                    fontFamily: 'Helvetica',
                    fontFamilyFallback: <String>['Arial', 'sans-serif'],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: EashColors.white.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
