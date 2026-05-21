import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/assets/eash_images.dart';
import '../core/theme/eash_theme.dart';

/// 2×2 trending grid — per-icon Figma x/y/size/rotation on 172×150 cards.
class DiscoverTrendingCategories extends StatelessWidget {
  const DiscoverTrendingCategories({super.key, this.onCategoryTap});

  final void Function(String label)? onCategoryTap;

  static const double _spacing = 12;
  static const double _designCardW = 172;
  static const double _designCardH = 150;
  static const double _aspectRatio = _designCardW / _designCardH;

  static const List<_TrendCategoryItem> _items = <_TrendCategoryItem>[
    _TrendCategoryItem(
      label: 'F&B',
      layers: <_FigmaIconLayer>[
        _FigmaIconLayer(
          asset: EashImages.trendNasiLemak,
          width: 120,
          height: 90,
          left: 60,
          top: 10,
        ),
      ],
    ),
    _TrendCategoryItem(
      label: 'Clubs',
      layers: <_FigmaIconLayer>[
        _FigmaIconLayer(
          asset: EashImages.trendBluePlane,
          width: 75.02,
          height: 75.02,
          left: 20,
          top: -1,
          rotationDeg: 8.9,
        ),
        _FigmaIconLayer(
          asset: EashImages.trendPinkMegaphone,
          width: 46,
          height: 48,
          left: 68,
          top: 56,
          rotationDeg: 8.45,
        ),
        _FigmaIconLayer(
          asset: EashImages.trendTrophy,
          width: 75,
          height: 89,
          left: 95,
          top: 12,
          rotationDeg: 15,
        ),
      ],
    ),
    _TrendCategoryItem(
      label: 'Events',
      layers: <_FigmaIconLayer>[
        _FigmaIconLayer(
          asset: EashImages.trendFair,
          width: 149,
          height: 90,
          top: 10,
          right: -8,
        ),
      ],
    ),
    _TrendCategoryItem(
      label: 'Housing',
      layers: <_FigmaIconLayer>[
        _FigmaIconLayer(
          asset: EashImages.trendHousing,
          width: 131,
          height: 104,
          left: 44,
          top: 6,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxW =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
        final double tileWidth = (maxW - _spacing) / 2;
        final double tileHeight = tileWidth / _aspectRatio;

        Widget row(int left, int right) {
          return Row(
            children: <Widget>[
              SizedBox(
                width: tileWidth,
                height: tileHeight,
                child: _TrendCategoryTile(
                  item: _items[left],
                  onTap: () => onCategoryTap?.call(_items[left].label),
                ),
              ),
              const SizedBox(width: _spacing),
              SizedBox(
                width: tileWidth,
                height: tileHeight,
                child: _TrendCategoryTile(
                  item: _items[right],
                  onTap: () => onCategoryTap?.call(_items[right].label),
                ),
              ),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            row(0, 1),
            const SizedBox(height: _spacing),
            row(2, 3),
          ],
        );
      },
    );
  }
}

/// One Figma-placed asset relative to the 172×150 card.
class _FigmaIconLayer {
  const _FigmaIconLayer({
    required this.asset,
    required this.width,
    required this.height,
    required this.top,
    this.left,
    this.right,
    this.rotationDeg = 0,
    this.flipX = false,
    this.flipY = false,
  }) : assert(left != null || right != null);

  final String asset;
  final double width;
  final double height;
  final double? left;
  final double? right;
  final double top;
  final double rotationDeg;
  final bool flipX;
  final bool flipY;
}

class _TrendCategoryItem {
  const _TrendCategoryItem({required this.label, required this.layers});

  final String label;
  final List<_FigmaIconLayer> layers;
}

class _TrendCategoryTile extends StatelessWidget {
  const _TrendCategoryTile({required this.item, this.onTap});

  final _TrendCategoryItem item;
  final VoidCallback? onTap;

  static const double _radius = 10;
  static const double _border = 2;
  static const double _labelLeft = 16;
  static const double _labelBottom = 20;
  static const double _labelFontSize = 18;

  static const LinearGradient _fillGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF5656D2),
      Color(0xFF8F33C2),
      Color(0xFFCC2A82),
      Color(0xFFF3702C),
    ],
  );

  static const LinearGradient _rimGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFF3702C), Color(0xFFCC2A82), Color(0xFFE300EC)],
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double tileW = constraints.maxWidth;
        final double scale = tileW / DiscoverTrendingCategories._designCardW;

        final double border = _border * scale;
        final double radius = _radius * scale;
        final double innerRadius = radius - border;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                gradient: _rimGradient,
              ),
              padding: EdgeInsets.all(border),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  fit: StackFit.expand,
                  children: <Widget>[
                    const DecoratedBox(
                      decoration: BoxDecoration(gradient: _fillGradient),
                    ),
                    for (final _FigmaIconLayer layer in item.layers)
                      _FigmaPlacedIcon(layer: layer, scale: scale),
                    Positioned(
                      left: _labelLeft * scale,
                      bottom: _labelBottom * scale,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          color: EashColors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: _labelFontSize * scale,
                          height: 1.1,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FigmaPlacedIcon extends StatelessWidget {
  const _FigmaPlacedIcon({required this.layer, required this.scale});

  final _FigmaIconLayer layer;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double w = layer.width * scale;
    final double h = layer.height * scale;
    final double top = layer.top * scale;
    final double? left = layer.left != null ? layer.left! * scale : null;
    final double? right = layer.right != null ? layer.right! * scale : null;
    final double radians = layer.rotationDeg * math.pi / 180;

    Widget image = Image.asset(
      layer.asset,
      width: w,
      height: h,
      fit: BoxFit.contain,
      alignment: right != null ? Alignment.centerRight : Alignment.center,
      filterQuality: FilterQuality.high,
      errorBuilder:
          (_, Object? e, StackTrace? st) => Icon(
            Icons.image_outlined,
            color: EashColors.white.withValues(alpha: 0.7),
            size: math.min(w, h) * 0.65,
          ),
    );

    if (layer.flipX || layer.flipY) {
      image = Transform.flip(
        flipX: layer.flipX,
        flipY: layer.flipY,
        child: image,
      );
    }

    if (layer.rotationDeg != 0) {
      image = Transform.rotate(
        angle: radians,
        alignment: Alignment.center,
        child: image,
      );
    }

    return Positioned(
      left: left,
      right: right,
      top: top,
      width: w,
      height: h,
      child: image,
    );
  }
}
