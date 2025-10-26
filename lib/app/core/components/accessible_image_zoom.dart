import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/components/vlibras_clickable_text.dart';

/// An accessible image zoom component that displays images in a modal dialog
/// when clicked/tapped, with smooth transitions and full keyboard support.
class AccessibleImageZoom extends StatefulWidget {
  /// The image asset path
  final String image;

  /// Optional alt text for accessibility
  final String? altText;

  /// Optional width for the image
  final double? width;

  /// Optional height for the image
  final double? height;

  /// Optional fit for the image
  final BoxFit? fit;

  /// Enable VLibras translation for alt text
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
    
    // Add VLibras support for alt text if enabled and on web
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
    // Request focus when dialog opens for keyboard accessibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogFocusNode.requestFocus();
      // Set initial scale based on screen size for better responsiveness
      _calculateInitialScale();
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Recalculate scale when screen metrics change (orientation, etc.)
    if (mounted) {
      _calculateInitialScale();
    }
  }

  void _calculateInitialScale() {
    final mediaQuery = MediaQuery.of(context);
    final currentScreenSize = mediaQuery.size;
    final currentOrientation = mediaQuery.orientation;
    
    // Only recalculate if screen size or orientation changed
    if (_screenSize != currentScreenSize || _orientation != currentOrientation) {
      _screenSize = currentScreenSize;
      _orientation = currentOrientation;
      
      // Set initial scale to 1.0 (normal scale)
      _initialScale = 1.0;
      
      // Apply the scale
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
        // Close dialog when ESC is pressed
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
                  // Calculate responsive constraints based on screen size
                  final maxWidth = constraints.maxWidth * 0.9;
                  final maxHeight = constraints.maxHeight * 0.9;
                  
                  // Ensure minimum size for very small screens
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
                      maxScale: 10, // Keep max scale for zooming capabilities
                      onInteractionEnd: (details) {
                        // Reset scale when double tapping
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
    
    // Add VLibras support for alt text if enabled and on web
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