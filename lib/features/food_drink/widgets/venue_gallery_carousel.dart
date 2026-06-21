import 'package:flutter/material.dart';

import '../../../core/theme/eash_theme.dart';
import '../../../data/food_drink_mock_data.dart';

/// Swipeable banner gallery used on both the F&B list card and detail screen.
///
/// Renders [FoodVenue.gallery] images, or [FoodVenue.galleryPlaceholderCount]
/// blank slides while photos aren't available yet. Shows page dots when there
/// is more than one slide.
class VenueGalleryCarousel extends StatefulWidget {
  const VenueGalleryCarousel({
    super.key,
    required this.venue,
    required this.height,
    this.placeholderIconSize = 48,
    this.borderRadius = 0,
    this.border,
  });

  final FoodVenue venue;
  final double height;
  final double placeholderIconSize;

  /// Corner radius for the gallery frame. `0` keeps square corners.
  final double borderRadius;

  /// Optional frame border drawn around the gallery (Figma `Gallery`).
  final BoxBorder? border;

  @override
  State<VenueGalleryCarousel> createState() => _VenueGalleryCarouselState();
}

class _VenueGalleryCarouselState extends State<VenueGalleryCarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FoodVenue venue = widget.venue;
    final int count = venue.galleryLength;
    final BorderRadius radius = BorderRadius.circular(widget.borderRadius);

    final Widget stack = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (int i) => setState(() => _page = i),
            itemBuilder: (BuildContext context, int index) {
              final String? asset =
                  index < venue.gallery.length ? venue.gallery[index] : null;
              if (asset != null) {
                // White backing so images with transparent padding (e.g. logos)
                // render consistently on both the white list card and the dark
                // detail banner instead of showing the scaffold colour.
                return ColoredBox(
                  color: EashColors.white,
                  child: _galleryImage(asset),
                );
              }
              return _placeholder();
            },
          ),
          if (count > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < count; i++) _Dot(active: i == _page),
                ],
              ),
            ),
        ],
      );

    final bool framed = widget.border != null || widget.borderRadius > 0;
    Widget content = stack;
    if (framed) {
      // Inset the clipped image by the border width so the stroke stays
      // visible instead of being painted over by the image.
      final BoxBorder? b = widget.border;
      final double bw = b is Border ? b.top.width : 0;
      content = DecoratedBox(
        decoration: BoxDecoration(
          color: EashColors.white,
          borderRadius: radius,
          border: widget.border,
        ),
        child: Padding(
          padding: EdgeInsets.all(bw),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              widget.borderRadius - bw > 0 ? widget.borderRadius - bw : 0,
            ),
            child: stack,
          ),
        ),
      );
    }

    return SizedBox(height: widget.height, child: content);
  }

  Widget _placeholder() {
    return ColoredBox(
      color: EashColors.cardGrey.withValues(alpha: 0.15),
      child: Icon(
        Icons.restaurant_rounded,
        size: widget.placeholderIconSize,
        color: EashColors.black.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _galleryImage(String source) {
    final bool isNetwork = source.startsWith('http://') || source.startsWith('https://');
    if (isNetwork) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, Object? e, StackTrace? st) => _placeholder(),
      );
    }
    return Image.asset(
      source,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, Object? e, StackTrace? st) => _placeholder(),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  // Figma `Page Indicator`.
  static const LinearGradient _activeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF0033FF), Color(0xFFFF4BFA)],
  );
  static const LinearGradient _inactiveGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFD4D4D4), Color(0xFFFFFFFF)],
  );

  @override
  Widget build(BuildContext context) {
    final double size = active ? 8 : 6;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active ? _activeGradient : _inactiveGradient,
        border: active
            ? null
            : Border.all(color: const Color(0xFF737373), width: 0.5),
      ),
    );
  }
}
