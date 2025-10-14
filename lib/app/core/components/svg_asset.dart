import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitrine_ufma/app/core/components/accessible_svg_zoom.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';

class AppSvgAsset extends StatelessWidget {
  final String image;
  final double imageW;
  final double imageH;
  final Color? color;
  final String? altText;
  final bool enableZoom;

  const AppSvgAsset({
    Key? key,
    required this.image,
    this.imageW = 30,
    this.imageH = 30,
    this.color,
    this.altText,
    this.enableZoom = false, // SVGs typically don't need zooming
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enableZoom) {
      return AccessibleSvgZoom(
        image: image,
        altText: altText ?? image,
        width: imageW,
        height: imageH,
        color: color,
      );
    } else {
      return SvgPicture.asset(
        'assets/icons/$image',
        width: ScreenHelper.doubleWidth(imageW),
        height: ScreenHelper.doubleHeight(imageH),
        color: color,
        semanticsLabel: altText,
      );
    }
  }
}