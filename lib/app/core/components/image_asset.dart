import 'package:flutter/material.dart';

class AppImageAsset extends StatelessWidget {
  final String image;
  final double? imageW;
  final double? imageH;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final BlendMode? colorBlendMode;
  final Color? color;
  const AppImageAsset(
      {Key? key,
      required this.image,
      this.imageW,
      this.imageH,
      this.fit,
      this.colorBlendMode,
      this.color,
      this.filterQuality = FilterQuality.low})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$image',
      width: imageW,
      height: imageH,
      fit: fit,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      color: color,
    );
  }
}
