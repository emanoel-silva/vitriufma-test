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

    this.enableZoom = false, // SVGs normalmente não precisam de zoom
  }) : super(key: key);

  String _getDefaultAltText(String image) {

    // Fornece texto alternativo descritivo com base no nome do ícone SVG
    switch (image.toLowerCase().replaceAll('.svg', '')) {
      case 'book':
        return 'Ícone de livro';
      case 'check':
        return 'Ícone de verificação';
      case 'close':
        return 'Ícone de fechar';
      case 'close_snackbar':
        return 'Ícone de fechar notificação';
      case 'error':
        return 'Ícone de erro';
      case 'library_books':
        return 'Ícone de livros da biblioteca';
      case 'warning':
        return 'Ícone de aviso';
      case 'exclamation':
        return 'Ícone de exclamação';
      case 'caracol':
        return 'Ícone decorativo';
      default:
        return 'Ícone';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (enableZoom) {
      return AccessibleSvgZoom(
        image: image,
        altText: altText ?? _getDefaultAltText(image),
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
        semanticsLabel: altText ?? _getDefaultAltText(image),
      );
    }
  }
}