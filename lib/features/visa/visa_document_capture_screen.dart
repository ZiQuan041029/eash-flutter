import 'dart:ui' show PathMetric;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/eash_theme.dart';
import '../../data/mock_data.dart';
import 'visa_confirmation_screen.dart';
import 'visa_document_frame_layout.dart';

/// Two-part layout: **upper** = wood + uniform light dim + dashed border over **live camera** preview;
/// **line** separator; **lower** = solid black dock + shutter centered in dock only.
class VisaDocumentCaptureScreen extends StatefulWidget {
  const VisaDocumentCaptureScreen({super.key});

  static const String _kBackgroundAsset = 'assets/images/background_visa.png';
  static const String _kShutterIconAsset = 'assets/images/camera_visa.png';

  static const double _kShutterDiameter = 84;
  static const double _kBlackBarCoreHeight = 120;

  static const double _kFrameInnerPadding = 10;
  static const double _kFrameInnerRadius = 12;

  /// Uniform dim over the **whole** upper area (frame included).
  static const double _kUpperDimAlpha = 0.56;

  @override
  State<VisaDocumentCaptureScreen> createState() => _VisaDocumentCaptureScreenState();
}

class _VisaDocumentCaptureScreenState extends State<VisaDocumentCaptureScreen> {
  CameraController? _camera;
  bool _initializing = true;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
    _setupCamera();
  }

  /// Android emulators often expose the virtual webcam as the **first** camera, not the back lens.
  CameraDescription _pickCamera(List<CameraDescription> cameras) {
    CameraDescription? back;
    CameraDescription? front;
    for (final CameraDescription c in cameras) {
      if (c.lensDirection == CameraLensDirection.back) {
        back = c;
      }
      if (c.lensDirection == CameraLensDirection.front) {
        front = c;
      }
    }
    return back ?? front ?? cameras.first;
  }

  Future<void> _setupCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _initializing = false;
            _cameraError = 'No camera available on this device.';
          });
        }
        return;
      }

      final CameraDescription chosen = _pickCamera(cameras);

      final CameraController controller = CameraController(
        chosen,
        // `high` is flaky on some emulators; `medium` still looks fine on device.
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      setState(() {
        _camera = controller;
        _initializing = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _initializing = false;
          _cameraError = e.toString();
        });
      }
    }
  }

  Future<void> _onShutter() async {
    final CameraController? c = _camera;
    if (c == null || !c.value.isInitialized) return;
    try {
      final XFile shot = await c.takePicture();
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => VisaConfirmationScreen(capturedImagePath: shot.path),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not capture photo: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(
                    VisaDocumentCaptureScreen._kBackgroundAsset,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: VisaDocumentCaptureScreen._kUpperDimAlpha),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: EashColors.white),
                                onPressed: () => Navigator.of(context).maybePop(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Verify Your Visa',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                kAlignVisaHint,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: EashColors.mutedText,
                                      fontSize: 17,
                                      height: 1.45,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: VisaDocumentFrameLayout.captureHorizontalPadding,
                            ),
                            child: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints c) {
                                final Size frame = VisaDocumentFrameLayout.sizeWithin(
                                  maxWidth: c.maxWidth,
                                  maxHeight: c.maxHeight,
                                );
                                return Align(
                                  alignment: const Alignment(0, -0.40),
                                  child: SizedBox(
                                    width: frame.width,
                                    height: frame.height,
                                    child: _buildFramePreview(frame),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 1,
            child: ColoredBox(color: Colors.white),
          ),
          SafeArea(
            top: false,
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: VisaDocumentCaptureScreen._kBlackBarCoreHeight + bottomInset,
                width: double.infinity,
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: EashContour.rimGradient,
                    ),
                    padding: const EdgeInsets.all(EashContour.inset),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: (_camera != null &&
                                _camera!.value.isInitialized &&
                                !_initializing)
                            ? _onShutter
                            : null,
                        child: Ink(
                          width: VisaDocumentCaptureScreen._kShutterDiameter,
                          height: VisaDocumentCaptureScreen._kShutterDiameter,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: (_camera != null &&
                                    _camera!.value.isInitialized &&
                                    !_initializing)
                                ? EashGradients.primary
                                : LinearGradient(
                                    colors: <Color>[
                                      EashColors.white.withValues(alpha: 0.25),
                                      EashColors.white.withValues(alpha: 0.15),
                                    ],
                                  ),
                          ),
                          child: Center(
                            child: Image.asset(
                              VisaDocumentCaptureScreen._kShutterIconAsset,
                              width: 38,
                              height: 38,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              color: (_camera != null &&
                                      _camera!.value.isInitialized &&
                                      !_initializing)
                                  ? null
                                  : EashColors.white.withValues(alpha: 0.4),
                              colorBlendMode: (_camera != null &&
                                      _camera!.value.isInitialized &&
                                      !_initializing)
                                  ? null
                                  : BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFramePreview(Size frame) {
    if (_cameraError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _cameraError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: EashColors.white),
          ),
        ),
      );
    }
    if (_initializing || _camera == null || !_camera!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: EashColors.white),
      );
    }

    final CameraController cam = _camera!;
    final double innerW = frame.width - 2 * VisaDocumentCaptureScreen._kFrameInnerPadding;
    final double innerH = frame.height - 2 * VisaDocumentCaptureScreen._kFrameInnerPadding;
    if (innerW <= 0 || innerH <= 0) {
      return const SizedBox.shrink();
    }

    // Sensor preview is landscape; `aspectRatio` is width/height. Scale to cover the clip rect.
    final double ar = cam.value.aspectRatio;
    final double previewW = innerW;
    // In portrait we want a taller preview so BoxFit.cover crops vertically and fills the frame.
    final double previewH = previewW * ar;

    return CustomPaint(
      painter: _DashedBorderPainter(
        color: EashColors.white.withValues(alpha: 0.85),
        strokeWidth: 2,
        radius: 20,
      ),
      child: Padding(
        padding: const EdgeInsets.all(VisaDocumentCaptureScreen._kFrameInnerPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(VisaDocumentCaptureScreen._kFrameInnerRadius),
          child: ColoredBox(
            color: Colors.black,
            child: SizedBox(
              width: innerW,
              height: innerH,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                child: SizedBox(
                  width: previewW,
                  height: previewH,
                  child: CameraPreview(cam),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final Path path = Path()..addRRect(rrect);
    // Prototype: 5px dash, 5px gap.
    final Path dashed = _dashPath(path, 5, 5);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source, double dashLength, double gapLength) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashLength;
        dest.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + gapLength;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth || oldDelegate.radius != radius;
  }
}
