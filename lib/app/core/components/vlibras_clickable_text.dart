import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:async';
import '../utils/vlibras_helper_stub.dart' if (dart.library.html) '../utils/vlibras_helper.dart';

/// Widget que torna um texto clicável para tradução no VLibras
class VLibrasClickableText extends StatefulWidget {
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
  State<VLibrasClickableText> createState() => _VLibrasClickableTextState();
}

class _VLibrasClickableTextState extends State<VLibrasClickableText> {
  Timer? _hoverTimer;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _handleMouseEnter() {
    // Cancel any existing timer
    _hoverTimer?.cancel();
    
    // Start a new timer for 3 seconds
    _hoverTimer = Timer(Duration(seconds: 3), () {
      _handleHover();
    });
  }

  void _handleMouseExit() {
    // Cancel the timer if mouse leaves before 3 seconds
    _hoverTimer?.cancel();
  }

  void _handleHover() {
    try {
      if (VLibrasHelper.isAvailable) {
        VLibrasHelper.activateAndTranslate(widget.text);
      } else {
        // Se VLibras não estiver disponível, cria área de feedback
        VLibrasHelper.createTranslationArea(widget.text);
      }
    } catch (e) {
      print('Erro ao processar hover para VLibras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      // Em plataformas não-web, retorna apenas o texto normal
      return Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }

    return Tooltip(
      message: widget.tooltip ?? 'Passe o mouse e mantenha por 3 segundos para traduzir em Libras',
      child: MouseRegion(
        onEnter: (event) => _handleMouseEnter(),
        onExit: (event) => _handleMouseExit(),
        child: Container(
          padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                  widget.text,
                  style: widget.style,
                  textAlign: widget.textAlign,
                  maxLines: widget.maxLines,
                  overflow: widget.overflow,
                ),
              ),
              if (widget.showIcon) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.accessibility,
                  size: widget.iconSize,
                  color: widget.iconColor ?? 
                         Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget que envolve qualquer child tornando-o clicável para VLibras
class VLibrasClickableWrapper extends StatefulWidget {
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
    this.showFeedback = false, // Changed default to false to disable notifications
  }) : super(key: key);

  @override
  State<VLibrasClickableWrapper> createState() => _VLibrasClickableWrapperState();
}

class _VLibrasClickableWrapperState extends State<VLibrasClickableWrapper> {
  Timer? _hoverTimer;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _handleMouseEnter(BuildContext context) {
    // Cancel any existing timer
    _hoverTimer?.cancel();
    
    // Start a new timer for 3 seconds
    _hoverTimer = Timer(Duration(seconds: 3), () {
      _handleHover(context);
    });
  }

  void _handleMouseExit() {
    // Cancel the timer if mouse leaves before 3 seconds
    _hoverTimer?.cancel();
  }

  void _handleHover(BuildContext context) {
    try {
      if (VLibrasHelper.isAvailable) {
        VLibrasHelper.activateAndTranslate(widget.textToTranslate);
      } else {
        VLibrasHelper.createTranslationArea(widget.textToTranslate);
      }
    } catch (e) {
      print('Erro ao processar hover para VLibras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!UniversalPlatform.isWeb) {
      return widget.child;
    }

    return Tooltip(
      message: widget.tooltip ?? 'Passe o mouse e mantenha por 3 segundos para traduzir em Libras',
      child: MouseRegion(
        onEnter: (event) => _handleMouseEnter(context),
        onExit: (event) => _handleMouseExit(),
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
          ),
          child: widget.child,
        ),
      ),
    );
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