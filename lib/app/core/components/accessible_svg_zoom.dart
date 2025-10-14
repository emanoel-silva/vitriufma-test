import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vitrine_ufma/app/core/utils/screen_helper.dart';

/// An accessible SVG zoom component that displays SVG images in a modal dialog
/// when clicked/tapped, with smooth transitions and full keyboard support.
class AccessibleSvgZoom extends StatefulWidget {
  /// The SVG image asset path
  final String image;

  /// Optional alt text for accessibility
  final String? altText;

  /// Optional width for the image
  final double? width;

  /// Optional height for the image
  final double? height;

  /// Optional color for the SVG
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
    return Focus(
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