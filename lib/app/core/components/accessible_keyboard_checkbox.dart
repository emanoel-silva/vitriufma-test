import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// An accessible checkbox that properly handles all keyboard interactions
/// Supports:
/// - Space key activation
/// - Enter key activation
/// - Proper focus management
/// - Screen reader announcements
class AccessibleKeyboardCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? semanticsLabel;
  final String? tooltip;
  final Color? activeColor;
  final Color? checkColor;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final double? size;
  final EdgeInsets? padding;
  final bool enableFeedback;

  const AccessibleKeyboardCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.semanticsLabel,
    this.tooltip,
    this.activeColor,
    this.checkColor,
    this.side,
    this.shape,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.size,
    this.padding,
    this.enableFeedback = true,
  }) : super(key: key);

  @override
  State<AccessibleKeyboardCheckbox> createState() => _AccessibleKeyboardCheckboxState();
}

class _AccessibleKeyboardCheckboxState extends State<AccessibleKeyboardCheckbox> {
  late FocusNode _focusNode;
  bool _isFocused = false;

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

  void _handleChange() {
    if (widget.onChanged != null && widget.enabled) {
      final newValue = !widget.value;
      widget.onChanged!(newValue);
      
      // Provide haptic feedback
      if (widget.enableFeedback) {
        Feedback.forTap(context);
      }
      
      // Announce to screen readers
      if (widget.semanticsLabel != null) {
        final state = newValue ? 'marcado' : 'desmarcado';
        SemanticsService.announce('${widget.semanticsLabel} $state', TextDirection.ltr);
      }
    }
  }

  void _handleKeyDown(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle Space and Enter key activation
      if (event.logicalKey == LogicalKeyboardKey.space || 
          event.logicalKey == LogicalKeyboardKey.enter) {
        _handleChange();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create the checkbox widget
    Widget checkbox = Checkbox(
      value: widget.value,
      onChanged: widget.enabled ? (widget.onChanged != null ? (_) => _handleChange() : null) : null,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      side: widget.side,
      shape: widget.shape,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    // Add padding if provided
    if (widget.padding != null) {
      checkbox = Padding(
        padding: widget.padding!,
        child: checkbox,
      );
    }

    // Add tooltip if provided
    if (widget.tooltip != null) {
      checkbox = Tooltip(
        message: widget.tooltip!,
        child: checkbox,
      );
    }

    // Wrap in RawKeyboardListener for keyboard activation
    checkbox = RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyDown,
      child: checkbox,
    );

    // Wrap in Semantics for accessibility information
    return Semantics(
      label: widget.semanticsLabel,
      enabled: widget.enabled,
      focused: _isFocused,
      checked: widget.value,
      child: checkbox,
    );
  }
}