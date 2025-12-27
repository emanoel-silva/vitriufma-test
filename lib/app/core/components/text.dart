import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/core/theme/them_custom.dart';
import 'package:vitrine_ufma/app/core/utils/text_styles.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils/nvda_helper_stub.dart' if (dart.library.html) '../utils/nvda_helper.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontWeight;
  final Color? color;
  final double? letterSpacing;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final Color? decorationColor;
  final double? decorationThickness;
  final bool? replaceAsterisks;
  final bool enableVLibras;
  final bool showVLibrasIcon;
  final String? vLibrasTooltip;
  final bool enableNVDA;
  
  const AppText({
    super.key,
    required this.text,
    this.fontSize = AppFontSize.fz05,
    this.fontWeight = "regular",
    this.color,
    this.letterSpacing,
    this.textAlign,
    this.height,
    this.maxLines,
    this.decoration,
    this.fontStyle,
    this.decorationColor,
    this.decorationThickness,
    this.replaceAsterisks,
    this.enableVLibras = true,
    this.showVLibrasIcon = false,
    this.vLibrasTooltip,
    this.enableNVDA = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeCustom theme = Theme.of(context).extension<ThemeCustom>()!;
    
    // Cria o estilo do texto
    final textStyleConfig = textStyle(
        color: color ?? theme.textColor,
        overflow: TextOverflow.ellipsis,
        fontSize: fontSize,
        fontStyle: fontStyle,
        height: height,
        fontWeight: fontWeight,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        letterSpacing: letterSpacing);
    
    // Cria o widget de texto base
    Widget textWidget = Container(
      color: Colors.transparent,
      child: EasyRichText(
        text,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        defaultStyle: textStyleConfig,
        patternList: [
          EasyRichTextPattern(
            targetString: '(\\*)(.*?)(\\*)',
            matchBuilder: (BuildContext? context, RegExpMatch? match) {
              return TextSpan(
                text: (replaceAsterisks ?? true)
                    ? match![0]!.replaceAll('*', '')
                    : match![0]!,
                style: textStyle(
                    color: color,
                    height: height,
                    fontSize: fontSize,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: "bold",
                    decoration: decoration,
                    letterSpacing: letterSpacing),
              );
            },
          ),
        ],
      ),
    );
    
    // Adiciona texto à fila do NVDA se habilitado e na web
    if (enableNVDA && UniversalPlatform.isWeb) {
      // Adiciona texto à fila do helper do NVDA quando o widget é construído
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (NVDAHelper.isAreaVisible) {
          NVDAHelper.addTextToQueue(text);
        }
      });
    }
    
    // Se o VLibras estiver habilitado e estivermos na web, envolve com VLibrasClickableWrapper
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