import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';

/// Um componente de zoom SVG acessível que exibe imagens SVG em um diálogo modal
/// quando clicado/tocado, com transições suaves e suporte completo a teclado.
class AccessibleSvgZoom extends StatefulWidget {
  /// O caminho do asset da imagem SVG
  final String image;

  /// Texto alternativo opcional para acessibilidade
  final String? altText;

  /// Largura opcional para a imagem
  final double? width;

  /// Altura opcional para a imagem
  final double? height;

  /// Cor opcional para o SVG
  final Color? color;

  const AccessibleSvgZoom({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  State<AccessibleSvgZoom> createState() => _AccessibleSvgZoomState();
}

class _AccessibleSvgZoomState extends State<AccessibleSvgZoom> {
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
        return _SvgZoomDialog(
          image: widget.image,
          altText: widget.altText,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.altText ?? 'Imagem SVG ampliável',
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
            child: SvgPicture.asset(
              'assets/icons/${widget.image}',
              width: widget.width,
              height: widget.height,
              color: widget.color,
              semanticsLabel: widget.altText,
            ),
          ),
        ),
      ),
    );
  }
}

class _SvgZoomDialog extends StatefulWidget {
  final String image;
  final String? altText;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback onClose;

  const _SvgZoomDialog({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.color,
    required this.onClose,
  }) : super(key: key);

  @override
  State<_SvgZoomDialog> createState() => _SvgZoomDialogState();
}

class _SvgZoomDialogState extends State<_SvgZoomDialog> with WidgetsBindingObserver {
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
    return Focus(
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
                      child: SvgPicture.asset(
                        'assets/icons/${widget.image}',
                        width: widget.width,
                        height: widget.height,
                        color: widget.color,
                        semanticsLabel: widget.altText,
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
  }
}