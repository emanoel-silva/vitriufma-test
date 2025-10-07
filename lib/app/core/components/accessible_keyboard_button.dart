import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// An accessible button that properly handles all keyboard interactions
/// Supports:
/// - Enter key activation
/// - Space key activation
/// - Proper focus management
/// - Screen reader announcements
class AccessibleKeyboardButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final String? semanticsLabel;
  final String? tooltip;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsets? padding;
  final BorderSide? borderSide;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final OutlinedBorder? shape;
  final double? elevation;
  final bool enableFeedback;

  const AccessibleKeyboardButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.semanticsLabel,
    this.tooltip,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.minWidth,
    this.minHeight,
    this.padding,
    this.borderSide,
    this.backgroundColor,
    this.foregroundColor,
    this.shape,
    this.elevation,
    this.enableFeedback = true,
  }) : super(key: key);

  @override
  State<AccessibleKeyboardButton> createState() => _AccessibleKeyboardButtonState();
}

class _AccessibleKeyboardButtonState extends State<AccessibleKeyboardButton> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _handlePress() {
    if (widget.onPressed != null && widget.enabled) {
      widget.onPressed!();
      
      // Provide haptic feedback
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      
      // Announce to screen readers
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} ativado', TextDirection.ltr);
      }
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null && widget.enabled) {
      widget.onLongPress!();
      
      // Provide haptic feedback
      if (widget.enableFeedback) {
        Feedback.forLongPress(context);
      }
      
      // Announce to screen readers
      if (widget.semanticsLabel != null) {
        SemanticsService.announce('${widget.semanticsLabel} pressionado longamente', TextDirection.ltr);
      }
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle Enter and Space key activation
      if (event.logicalKey == LogicalKeyboardKey.enter || 
          event.logicalKey == LogicalKeyboardKey.space) {
        _handlePress();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button style based on parameters
    ButtonStyle buttonStyle = widget.style ?? 
        ButtonStyle(
          // Minimum size for adequate touch target (44x44 pixels recommended)
          minimumSize: MaterialStateProperty.all<Size>(
            Size(
              widget.minWidth ?? 44.0,
              widget.minHeight ?? 44.0,
            ),
          ),
          // Proper padding
          padding: MaterialStateProperty.all<EdgeInsets>(
            widget.padding ?? const EdgeInsets.all(12.0),
          ),
          // Background color
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.5);
              }
              if (states.contains(MaterialState.pressed)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.8);
              }
              return widget.backgroundColor ?? Theme.of(context).primaryColor;
            },
          ),
          // Foreground color
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return (widget.foregroundColor ?? Colors.white)
                    .withOpacity(0.7);
              }
              return widget.foregroundColor ?? Colors.white;
            },
          ),
          // Border
          side: MaterialStateProperty.all<BorderSide>(
            widget.borderSide ??
                BorderSide(
                  color: widget.backgroundColor ?? Theme.of(context).primaryColor,
                  width: 1.0,
                ),
          ),
          // Shape
          shape: MaterialStateProperty.all<OutlinedBorder>(
            widget.shape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
          ),
          // Elevation
          elevation: MaterialStateProperty.all<double>(
            widget.elevation ?? 2.0,
          ),
          // Focus overlay
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.2);
              }
              if (states.contains(MaterialState.hovered)) {
                return (widget.backgroundColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.1);
              }
              return null;
            },
          ),
        );

    // Create the button widget
    Widget button = ElevatedButton(
      onPressed: widget.enabled ? _handlePress : null,
      onLongPress: widget.enabled ? _handleLongPress : null,
      style: buttonStyle,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: widget.child,
    );

    // Add tooltip if provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    // Wrap in RawKeyboardListener for keyboard activation
    button = RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyDown,
      child: button,
    );

    // Wrap in Semantics for accessibility information
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      enabled: widget.enabled,
      focused: _isFocused,
      child: button,
    );
  }
}