import 'package:vitrine_ufma/app/core/components/svg_asset.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String? icon;
  final String? label;
  final String? fontWeight;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? color;
  final double? hPadding;
  final double? vPadding;
  final double? iconSize;
  final double? fontSize;

  const BottomButton({
    super.key,
    this.icon,
    this.label,
    this.backgroundColor,
    this.color,
    this.hPadding,
    this.vPadding,
    this.fontSize,
    this.iconColor,
    this.iconSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: hPadding ?? 20, vertical: vPadding ?? 18),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.black,
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              SizedBox(
                width: iconSize ?? 20,
                height: iconSize ?? 20,
                child: AppSvgAsset(
                  imageH: iconSize ?? 20,
                  imageW: iconSize ?? 20,
                  image: icon!,
                  color: iconColor ?? AppColors.white,
                ),
              ),
            if (icon != null && label != null) const SizedBox(width: 12),
            if (label != null)
              AppText(
                text: label!,
                fontWeight: fontWeight ?? 'bold',
                color: color ?? AppColors.white,
                fontSize: fontSize ?? AppFontSize.fz06,
              ),
          ],
        ),
      ),
    );
  }
}
