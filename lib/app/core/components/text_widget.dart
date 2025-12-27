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
    // Cria o widget de texto base

    Widget textWidget = Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black),
    );
    
    // Se houver um callback onTap, envolva com GestureDetector

    if (onTap != null) {
      textWidget = GestureDetector(
        onTap: onTap,
        child: textWidget,
      );
    }
    
    // Se o VLibras estiver habilitado e estivermos na web, envolva com VLibrasClickableWrapper

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
