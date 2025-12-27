import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';

/// Um componente de zoom de imagem de rede acessível que exibe imagens em um diálogo modal
/// quando clicado/tocado, com transições suaves e suporte completo a teclado.
class AccessibleNetworkImageZoom extends StatefulWidget {
  /// A URL da imagem de rede
  final String imageUrl;

  /// Texto alternativo opcional para acessibilidade
  final String? altText;

  /// Largura opcional para a imagem
  final double? width;

  /// Altura opcional para a imagem
  final double? height;

  /// Ajuste opcional para a imagem
  final BoxFit? fit;

  /// Construtor opcional para carregamento
  final ImageLoadingBuilder? loadingBuilder;

  /// Construtor opcional para erro
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Habilita tradução VLibras para texto alternativo
  final bool enableVLibras;

  const AccessibleNetworkImageZoom({
    Key? key,
    required this.imageUrl,
    this.altText,
    this.width,
    this.height,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder,
    this.enableVLibras = true,
  }) : super(key: key);

  @override
  State<AccessibleNetworkImageZoom> createState() => _AccessibleNetworkImageZoomState();
}

class _AccessibleNetworkImageZoomState extends State<AccessibleNetworkImageZoom> {
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
        return _NetworkImageZoomDialog(
          imageUrl: widget.imageUrl,
          altText: widget.altText,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          loadingBuilder: widget.loadingBuilder,
          errorBuilder: widget.errorBuilder,
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
            child: Image.network(
              widget.imageUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              loadingBuilder: widget.loadingBuilder,
              errorBuilder: widget.errorBuilder,
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

class _NetworkImageZoomDialog extends StatefulWidget {
  final String imageUrl;
  final String? altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final VoidCallback onClose;
  final bool enableVLibras;

  const _NetworkImageZoomDialog({
    Key? key,
    required this.imageUrl,
    this.altText,
    this.width,
    this.height,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder,
    required this.onClose,
    this.enableVLibras = true,
  }) : super(key: key);

  @override
  State<_NetworkImageZoomDialog> createState() => _NetworkImageZoomDialogState();
}

class _NetworkImageZoomDialogState extends State<_NetworkImageZoomDialog> with WidgetsBindingObserver {
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
    
    // Apenas recalcula se o tamanho ou orientação da tela mudar
    if (_screenSize != currentScreenSize || _orientation != currentOrientation) {
      _screenSize = currentScreenSize;
      _orientation = currentOrientation;
      
      // Define escala inicial para 1.0 (escala normal)
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
                  // Calcula as restrições responsivas com base no tamanho da tela
                  final maxWidth = constraints.maxWidth * 0.9;
                  final maxHeight = constraints.maxHeight * 0.9;
                  
                  // Garante tamanho mínimo para telas muito pequenas
                  final minWidth = MediaQuery.of(context).size.width * 0.5;
                  final minHeight = MediaQuery.of(context).size.height * 0.5;
                  
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minWidth,
                      minHeight: minHeight,
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                    ),
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.5,
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
                      child: Image.network(
                        widget.imageUrl,
                        // Ignora largura/altura passada do pai para visualização modal
                        // width: widget.width,
                        // height: widget.height,
                        fit: BoxFit.contain, // Garante que se encaixe na tela
                        loadingBuilder: widget.loadingBuilder,
                        errorBuilder: widget.errorBuilder,
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