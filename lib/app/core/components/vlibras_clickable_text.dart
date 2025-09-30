import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils/vlibras_helper_stub.dart' if (dart.library.html) '../utils/vlibras_helper.dart';

/// Widget que torna um texto clicável para tradução no VLibras
class VLibrasClickableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool showIcon;
  final Color? iconColor;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final Color? highlightColor;
  final String? tooltip;

  const VLibrasClickableText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.showIcon = true,
    this.iconColor,
    this.iconSize = 16,
    this.padding,
    this.highlightColor,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      // Em plataformas não-web, retorna apenas o texto normal
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return Tooltip(
      message: tooltip ?? 'Passe o mouse para traduzir em Libras',
      child: MouseRegion(
        onEnter: (event) => _handleHover(),
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: style,
                  textAlign: textAlign,
                  maxLines: maxLines,
                  overflow: overflow,
                ),
              ),
              if (showIcon) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.accessibility,
                  size: iconSize,
                  color: iconColor ?? 
                         Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover() {
    try {
      if (VLibrasHelper.isAvailable) {
        VLibrasHelper.activateAndTranslate(text);
      } else {
        // Se VLibras não estiver disponível, cria área de feedback
        VLibrasHelper.createTranslationArea(text);
      }
    } catch (e) {
      print('Erro ao processar hover para VLibras: $e');
    }
  }
}

/// Widget que envolve qualquer child tornando-o clicável para VLibras
class VLibrasClickableWrapper extends StatelessWidget {
  final Widget child;
  final String textToTranslate;
  final EdgeInsetsGeometry? padding;
  final Color? highlightColor;
  final String? tooltip;
  final bool showFeedback;

  const VLibrasClickableWrapper({
    Key? key,
    required this.child,
    required this.textToTranslate,
    this.padding,
    this.highlightColor,
    this.tooltip,
    this.showFeedback = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      return child;
    }

    return Tooltip(
      message: tooltip ?? 'Passe o mouse para traduzir em Libras',
      child: MouseRegion(
        onEnter: (event) => _handleHover(context),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
          ),
          child: child,
        ),
      ),
    );
  }

  void _handleHover(BuildContext context) {
    try {
      if (VLibrasHelper.isAvailable) {
        VLibrasHelper.activateAndTranslate(textToTranslate);
        
        if (showFeedback) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Texto enviado para tradução em Libras'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        VLibrasHelper.createTranslationArea(textToTranslate);
        
        if (showFeedback) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('VLibras não disponível'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao processar hover para VLibras: $e');
      
      if (showFeedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar para VLibras'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Mixin para páginas que usam VLibras
mixin VLibrasPageMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isWeb) {
      // Aguarda o frame ser construído antes de inicializar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VLibrasHelper.reinitialize();
      });
    }
  }

  /// Traduz texto específico (pode ser acionado por hover ou clique)
  void translateText(String text) {
    if (UniversalPlatform.isWeb) {
      VLibrasHelper.activateAndTranslate(text);
    }
  }

  /// Força refresh do VLibras após mudanças de conteúdo
  void refreshVLibras() {
    if (UniversalPlatform.isWeb) {
      VLibrasHelper.refresh();
    }
  }
}
