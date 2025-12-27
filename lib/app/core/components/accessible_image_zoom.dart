import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';

/// Um componente de zoom de imagem acessível que exibe imagens em um diálogo modal
/// quando clicado/tocado, com transições suaves e suporte completo a teclado.
class AccessibleImageZoom extends StatefulWidget {
  /// O caminho do asset da imagem
  final String image;

  /// Texto alternativo opcional para acessibilidade
  final String? altText;

  /// Largura opcional para a imagem
  final double? width;

  /// Altura opcional para a imagem
  final double? height;

  /// Ajuste opcional para a imagem
  final BoxFit? fit;

  /// Habilita tradução VLibras para texto alternativo
  final bool enableVLibras;

  const AccessibleImageZoom({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
    this.enableVLibras = true,
  }) : super(key: key);

  @override
  State<AccessibleImageZoom> createState() => _AccessibleImageZoomState();
}

class _AccessibleImageZoomState extends State<AccessibleImageZoom> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openZoomDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) {
        return _ZoomDialog(
          image: widget.image,
          altText: widget.altText,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          enableVLibras: widget.enableVLibras,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedAltText = widget.altText ?? 'Imagem ampliável';
    
    Widget imageWidget = Semantics(
      label: resolvedAltText,
      button: true,
      focused: _focusNode.hasFocus,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _openZoomDialog();
              return null;
            },
          ),
        },
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
          LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _openZoomDialog,
            child: Image.asset(
              'assets/images/${widget.image}',
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              filterQuality: FilterQuality.high,
              semanticLabel: widget.altText,
            ),
          ),
        ),
      ),
    );
    
    // Adiciona suporte VLibras para texto alternativo se habilitado e na web
    if (widget.enableVLibras && UniversalPlatform.isWeb) {
      return VLibrasClickableWrapper(
        textToTranslate: resolvedAltText,
        tooltip: 'Passe o mouse para traduzir a descrição da imagem em Libras',
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }
}

class _ZoomDialog extends StatefulWidget {
  final String image;
  final String? altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final VoidCallback onClose;
  final bool enableVLibras;

  const _ZoomDialog({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
    required this.onClose,
    this.enableVLibras = true,
  }) : super(key: key);

  @override
  State<_ZoomDialog> createState() => _ZoomDialogState();
}

class _ZoomDialogState extends State<_ZoomDialog> with WidgetsBindingObserver {
  final TransformationController _transformationController =
      TransformationController();
  late FocusNode _dialogFocusNode;
  double _initialScale = 1.0;
  Size? _screenSize;
  Orientation? _orientation;

  @override
  void initState() {
    super.initState();
    _dialogFocusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);
    // Solicita foco quando o diálogo abre para acessibilidade por teclado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogFocusNode.requestFocus();
      // Define escala inicial com base no tamanho da tela para melhor responsividade
      _calculateInitialScale();
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Recalcula a escala quando as métricas da tela mudam (orientação, etc.)
    if (mounted) {
      _calculateInitialScale();
    }
  }

  void _calculateInitialScale() {
    final mediaQuery = MediaQuery.of(context);
    final currentScreenSize = mediaQuery.size;
    final currentOrientation = mediaQuery.orientation;
    
    // Recalcular somente se o tamanho ou a orientação da tela forem alterados.
    if (_screenSize != currentScreenSize || _orientation != currentOrientation) {
      _screenSize = currentScreenSize;
      _orientation = currentOrientation;
      
      // Defina a escala inicial para 1,0 (escala normal).
      _initialScale = 1.0;
      

      // Aplica a escala
      _transformationController.value = Matrix4.identity()..scale(_initialScale);

    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dialogFocusNode.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget dialogWidget = Focus(
      focusNode: _dialogFocusNode,
      onKeyEvent: (node, event) {
        // Fecha o diálogo quando ESC é pressionado
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onClose();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: widget.onClose,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final mediaQuery = MediaQuery.of(context);
                  final screenSize = mediaQuery.size;
                  final orientation = mediaQuery.orientation;
                  
                  // Calcula as restrições responsivas com base no tamanho da tela
                  double maxWidth = screenSize.width * 0.9;
                  double maxHeight = screenSize.height * 0.9;
                  
                  // Ajusta as restrições com base na orientação
                  if (orientation == Orientation.portrait) {
                    maxHeight = screenSize.height * 0.85;
                    maxWidth = screenSize.width * 0.95;
                  } else {
                    maxHeight = screenSize.height * 0.8;
                    maxWidth = screenSize.width * 0.7;
                  }
                  
                  // Garante tamanho mínimo para telas muito pequenas
                  final minWidth = screenSize.width * 0.4;
                  final minHeight = screenSize.height * 0.4;
                  
                  // Para dispositivos móveis, use dimensionamento mais restritivo
                  if (screenSize.width < 600) {
                    maxWidth = screenSize.width * 0.95;
                    maxHeight = screenSize.height * 0.7;
                  } else if (screenSize.width < 1024) {
                    maxWidth = screenSize.width * 0.85;
                    maxHeight = screenSize.height * 0.8;
                  }
                  
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minWidth,
                      minHeight: minHeight,
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                    ),
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: EdgeInsets.all(orientation == Orientation.portrait ? 10 : 20),
                      minScale: 0.1,

                      maxScale: 10, // Mantém escala máxima para capacidades de zoom
                      onInteractionEnd: (details) {
                        // Redefine a escala quando tocado duas vezes
                        if (details.pointerCount == 1) {
                          final scale = _transformationController.value.getMaxScaleOnAxis();
                          if (scale > 1.0) {
                            _transformationController.value = Matrix4.identity()..scale(_initialScale);
                          }
                        }
                      },
                      child: Image.asset(
                        'assets/images/${widget.image}',
                        width: widget.width,
                        height: widget.height,
                        fit: widget.fit ?? BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        semanticLabel: widget.altText,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    
    // Adiciona suporte VLibras para texto alternativo se habilitado e na web
    if (widget.enableVLibras && UniversalPlatform.isWeb) {
      return VLibrasClickableWrapper(
        textToTranslate: widget.altText ?? 'Imagem ampliável',
        tooltip: 'Passe o mouse para traduzir a descrição da imagem em Libras',
        child: dialogWidget,
      );
    }
    
    return dialogWidget;
  }
}