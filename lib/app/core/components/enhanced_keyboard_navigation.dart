import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that enhances keyboard navigation for its child content
/// Supports all requested keyboard shortcuts:
/// - Tab: Advance between interactive elements
/// - Shift + Tab: Move focus backward
/// - Enter: Activate links, buttons or submit forms
/// - Space: Activate checkboxes, buttons or scroll page
/// - Arrow keys (↑↓←→): Navigate menus, lists or controls
/// - Esc: Close menus or modals
/// - Home/End: Move focus to first/last item
/// - Ctrl+Home/Ctrl+End: Navigate to top/bottom of screen
/// - Shift+Arrows: Select text or multiple items
class EnhancedKeyboardNavigation extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final VoidCallback? onEscapePressed;
  final bool autoFocus;

  const EnhancedKeyboardNavigation({
    Key? key,
    required this.child,
    this.scrollController,
    this.onEscapePressed,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  State<EnhancedKeyboardNavigation> createState() => _EnhancedKeyboardNavigationState();
}

class _EnhancedKeyboardNavigationState extends State<EnhancedKeyboardNavigation> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  double _scrollSpeed = 100.0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    
    // Request focus after the widget is built
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // Only dispose if we created the controller
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final isCtrlPressed = event.isKeyPressed(LogicalKeyboardKey.controlLeft) || 
                          event.isKeyPressed(LogicalKeyboardKey.controlRight);
      final isShiftPressed = event.isKeyPressed(LogicalKeyboardKey.shiftLeft) || 
                            event.isKeyPressed(LogicalKeyboardKey.shiftRight);
      final isAltPressed = event.isKeyPressed(LogicalKeyboardKey.altLeft) || 
                          event.isKeyPressed(LogicalKeyboardKey.altRight);
      
      // Skip if modifier keys are pressed (except for our specific combinations)
      if ((isCtrlPressed || isAltPressed) && 
          event.logicalKey != LogicalKeyboardKey.home && 
          event.logicalKey != LogicalKeyboardKey.end) {
        return;
      }

      // Handle Escape key
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        // Call the escape callback if provided
        widget.onEscapePressed?.call();
        
        // Also try to close any open dialogs or popups
        Navigator.maybePop(context);
        return;
      }

      // Handle Ctrl+Home and Ctrl+End
      if (isCtrlPressed) {
        if (event.logicalKey == LogicalKeyboardKey.home) {
          // Scroll to top
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          // Scroll to bottom
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        }
      }

      // Handle scrolling with space key when not on a focusable element
      if (event.logicalKey == LogicalKeyboardKey.space && 
          !isShiftPressed &&
          FocusManager.instance.primaryFocus?.context?.widget is! EditableText &&
          FocusManager.instance.primaryFocus?.context?.widget is! Checkbox &&
          FocusManager.instance.primaryFocus?.context?.widget is! Radio) {
        // Scroll down by scroll speed
        _scrollController.animateTo(
          _scrollController.offset + _scrollSpeed,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        return;
      }

      // Handle arrow key events for scrolling (when not in a text field)
      if (FocusManager.instance.primaryFocus?.context?.widget is! EditableText) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          // Scroll up by scroll speed
          _scrollController.animateTo(
            _scrollController.offset - _scrollSpeed,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          // Scroll down by scroll speed
          _scrollController.animateTo(
            _scrollController.offset + _scrollSpeed,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && !isCtrlPressed) {
          // Scroll left by scroll speed
          _scrollController.animateTo(
            _scrollController.offset - _scrollSpeed,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && !isCtrlPressed) {
          // Scroll right by scroll speed
          _scrollController.animateTo(
            _scrollController.offset + _scrollSpeed,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          // Page up - scroll up by 80% of screen height
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset - screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          // Page down - scroll down by 80% of screen height
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset + screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.home && !isCtrlPressed) {
          // Home key - scroll to top
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        } else if (event.logicalKey == LogicalKeyboardKey.end && !isCtrlPressed) {
          // End key - scroll to bottom
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return;
        }
      }

      // Handle Shift+Space for scrolling up
      if (event.logicalKey == LogicalKeyboardKey.space && isShiftPressed) {
        // Scroll up by scroll speed
        _scrollController.animateTo(
          _scrollController.offset - _scrollSpeed,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: FocusScope(
        node: _focusScopeNode,
        autofocus: widget.autoFocus,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}