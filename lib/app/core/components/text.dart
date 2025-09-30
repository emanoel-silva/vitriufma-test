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
  });

  @override
  Widget build(BuildContext context) {
    final ThemeCustom theme = Theme.of(context).extension<ThemeCustom>()!;
    
    // Create the text style
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
    
    // Create the base text widget
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
