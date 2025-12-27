import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';

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
  final bool enableVLibrasAltText;

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
    this.enableVLibrasAltText = true,
  }) : super(key: key);

  String _getDefaultAltText(String image) {
    // Fornece texto alternativo descritivo com base no nome da imagem
    switch (image.toLowerCase()) {
      case 'logo.png':
        return 'Logotipo da Vitrine Virtual';
      case 'home.jpeg':
        return 'Imagem de fundo da página inicial';
      case 'google.jpeg':
        return 'Logotipo do Google';
      case 'instagram.png':
        return 'Logotipo do Instagram';
      case 'youtube_logo.png':
        return 'Logotipo do YouTube';
      case 'example-ps-scaled.jpg':
        return 'Imagem de exemplo da biblioteca';
      default:
        // Para imagens de livros e outras, fornece uma descrição genérica
        if (image.contains('book')) {
          return 'Capa do livro';
        }
        return 'Imagem';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedAltText = altText ?? _getDefaultAltText(image);
    
    if (enableZoom) {
      Widget imageWidget = AccessibleImageZoom(
        image: image,
        altText: resolvedAltText,
        width: imageW,
        height: imageH,
        fit: fit,
      );
      
      // Adiciona suporte VLibras para texto alternativo se habilitado e na web
      if (enableVLibrasAltText && UniversalPlatform.isWeb) {
        return VLibrasClickableWrapper(
          textToTranslate: resolvedAltText,
          tooltip: 'Passe o mouse para traduzir a descrição da imagem em Libras',
          child: imageWidget,
        );
      }
      
      return imageWidget;
    } else {
      Widget imageWidget = Image.asset(
        'assets/images/$image',
        width: imageW,
        height: imageH,
        fit: fit,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        color: color,
        semanticLabel: resolvedAltText,
      );
      
      // Adiciona suporte VLibras para texto alternativo se habilitado e na web
      if (enableVLibrasAltText && UniversalPlatform.isWeb) {
        return VLibrasClickableWrapper(
          textToTranslate: resolvedAltText,
          tooltip: 'Passe o mouse para traduzir a descrição da imagem em Libras',
          child: imageWidget,
        );
      }
      
      return imageWidget;
    }
  }
}