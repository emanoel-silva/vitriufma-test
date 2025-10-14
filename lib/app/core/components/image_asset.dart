import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';

class AppImageAsset extends StatelessWidget {
  final String image;
  final double? imageW;
  final double? imageH;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Color? color;
  final String? altText;
  final bool enableZoom;

  const AppImageAsset({
    Key? key,
    required this.image,
    this.imageW,
    this.imageH,
    this.fit,
    this.colorBlendMode,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.altText,
    this.enableZoom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enableZoom) {
      return AccessibleImageZoom(
        image: image,
        altText: altText ?? image,
        width: imageW,
        height: imageH,
        fit: fit,
      );
    } else {
      return Image.asset(
        'assets/images/$image',
        width: imageW,
        height: imageH,
        fit: fit,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        color: color,
        semanticLabel: altText,
      );
    }
  }
}