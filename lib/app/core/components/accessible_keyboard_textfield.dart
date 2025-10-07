import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// An accessible text field that properly handles all keyboard interactions
/// Supports:
/// - All standard text field keyboard interactions
/// - Proper focus management
/// - Screen reader announcements
/// - Custom keyboard shortcuts
class AccessibleKeyboardTextField extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? semanticsLabel;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final TextEditingController? controller;
  final TextStyle? style;
  final InputDecoration? decoration;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final EdgeInsets? padding;
  final bool enableFeedback;

  const AccessibleKeyboardTextField({
    Key? key,
    this.value,
    this.onChanged,
    this.semanticsLabel,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.controller,
    this.style,
    this.decoration,
    this.onEditingComplete,
    this.onSubmitted,
    this.padding,
    this.enableFeedback = true,
  }) : super(key: key);

  @override
  State<AccessibleKeyboardTextField> createState() => _AccessibleKeyboardTextFieldState();
}

class _AccessibleKeyboardTextFieldState extends State<AccessibleKeyboardTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    if (widget.value != null) {
      _controller.text = widget.value!;
    }
    
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    
    _controller.removeListener(_handleTextChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    // Announce focus changes to screen readers
    if (_isFocused && widget.semanticsLabel != null) {
      SemanticsService.announce('${widget.semanticsLabel} focado', TextDirection.ltr);
    }
  }

  void _handleTextChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle custom keyboard shortcuts
      final isCtrlPressed = event.isKeyPressed(LogicalKeyboardKey.controlLeft) || 
                          event.isKeyPressed(LogicalKeyboardKey.controlRight);
      
      // Ctrl+A to select all
      if (isCtrlPressed && event.logicalKey == LogicalKeyboardKey.keyA) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
      
      // Ctrl+C, Ctrl+X, Ctrl+V are handled by the system
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create the text field widget
    Widget textField = TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      style: widget.style,
      decoration: widget.decoration ?? InputDecoration(
        labelText: widget.semanticsLabel,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
      ),
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
    );

    // Add padding if provided
    if (widget.padding != null) {
      textField = Padding(
        padding: widget.padding!,
        child: textField,
      );
    }

    // Wrap in RawKeyboardListener for custom keyboard shortcuts
    textField = RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyDown,
      child: textField,
    );

    // Wrap in Semantics for accessibility information
    return Semantics(
      label: widget.semanticsLabel,
      hint: widget.hintText,
      enabled: widget.enabled,
      focused: _isFocused,
      textField: true,
      child: textField,
    );
  }
}