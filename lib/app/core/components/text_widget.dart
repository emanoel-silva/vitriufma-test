import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
import 'package:universal_platform/universal_platform.dart';

class TextWidget extends StatelessWidget {
  String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  int? maxLines;
  TextAlign? textAlign;
  final VoidCallback? onTap;
  final bool enableVLibras;
  final String? vLibrasTooltip;

  TextWidget(
      {super.key,
      required this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.maxLines,
      this.textAlign,
      this.onTap,
      this.enableVLibras = true,
      this.vLibrasTooltip});

  @override
  Widget build(BuildContext context) {
    // Create the base text widget
    Widget textWidget = Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black),
    );
    
    // If there's an onTap callback, wrap with GestureDetector
    if (onTap != null) {
      textWidget = GestureDetector(
        onTap: onTap,
        child: textWidget,
      );
    }
    
    // If VLibras is enabled and we're on web, wrap with VLibrasClickableWrapper
    if (enableVLibras && UniversalPlatform.isWeb) {
      return VLibrasClickableWrapper(
        textToTranslate: text,
        tooltip: vLibrasTooltip ?? 'Passe o mouse para traduzir em Libras',
        child: textWidget,
      );
    }
    
    return textWidget;
  }
}
