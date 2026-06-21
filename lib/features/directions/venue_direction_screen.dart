import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/location/external_map_launcher.dart';
import '../../core/location/google_maps_embed.dart';
import '../../core/theme/eash_theme.dart';
import '../../widgets/eash_gradient_header.dart';

/// Directions page — embedded Google Map preview + Start Navigation (Figma 06c).
class VenueDirectionScreen extends StatefulWidget {
  const VenueDirectionScreen({
    super.key,
    required this.name,
    required this.address,
    required this.directionLabel,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String address;
  final String directionLabel;
  final double? latitude;
  final double? longitude;

  static const Color _white80 = Color(0xFFCCCCCC);
  static const Color _panelGrey = Color(0xFF1D1D1D);
  static const Color _pinkBorder = Color(0xFFFF4BFA);

  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );

  @override
  State<VenueDirectionScreen> createState() => _VenueDirectionScreenState();
}

class _VenueDirectionScreenState extends State<VenueDirectionScreen> {
  late final WebViewController _mapController;
  bool _mapLoading = true;

  @override
  void initState() {
    super.initState();
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1D1D1D))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _mapLoading = false);
            }
          },
        ),
      )
      ..loadHtmlString(
        buildGoogleMapsEmbedHtml(
          name: widget.name,
          address: widget.address,
          latitude: widget.latitude,
          longitude: widget.longitude,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EashColors.black,
      child: Column(
        children: <Widget>[
          EashGradientTitleHeader(
            title: 'Directions',
            trailing: const Icon(
              Icons.ios_share_rounded,
              color: EashColors.white,
              size: 22,
            ),
            titleStyle: const TextStyle(
              color: EashColors.white,
              fontFamily: 'Helvetica',
              fontFamilyFallback: <String>['Arial', 'sans-serif'],
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 25 / 18,
              letterSpacing: 0,
              decoration: TextDecoration.none,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: WebViewWidget(controller: _mapController),
                ),
                if (_mapLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0xFF1D1D1D),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: EashColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: _DirectionSheet(
                        name: widget.name,
                        address: widget.address,
                        directionLabel: widget.directionLabel,
                        onStart: () => startExternalNavigation(
                          context,
                          name: widget.name,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          address: widget.address,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionSheet extends StatelessWidget {
  const _DirectionSheet({
    required this.name,
    required this.address,
    required this.directionLabel,
    required this.onStart,
  });

  final String name;
  final String address;
  final String directionLabel;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
      decoration: BoxDecoration(
        color: VenueDirectionScreen._panelGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: EashColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) =>
                      VenueDirectionScreen._buttonGradient.createShader(bounds),
                  child: const Icon(
                    Icons.location_on,
                    color: EashColors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                        color: EashColors.white,
                        fontFamily: 'Helvetica',
                        fontFamilyFallback: <String>['Arial', 'sans-serif'],
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 20 / 16,
                        letterSpacing: 0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions_walk_rounded,
                          size: 18,
                          color: VenueDirectionScreen._white80,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            directionLabel,
                            style: const TextStyle(
                              color: VenueDirectionScreen._white80,
                              fontFamily: 'Helvetica',
                              fontFamilyFallback: <String>[
                                'Arial',
                                'sans-serif',
                              ],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 15 / 14,
                              letterSpacing: 0,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (address.isNotEmpty) ...<Widget>[
            const SizedBox(height: 18),
            Text(
              address,
              style: const TextStyle(
                color: VenueDirectionScreen._white80,
                fontFamily: 'Helvetica',
                fontFamilyFallback: <String>['Arial', 'sans-serif'],
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 22 / 16,
                letterSpacing: 0,
                decoration: TextDecoration.none,
              ),
            ),
          ],
          const SizedBox(height: 23),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onStart,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: VenueDirectionScreen._buttonGradient,
                  border: Border.all(
                    color: VenueDirectionScreen._pinkBorder,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Start Navigation',
                    style: TextStyle(
                      color: EashColors.white,
                      fontFamily: 'Helvetica',
                      fontFamilyFallback: <String>['Arial', 'sans-serif'],
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 25 / 18,
                      letterSpacing: 0,
                      decoration: TextDecoration.none,
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
}
