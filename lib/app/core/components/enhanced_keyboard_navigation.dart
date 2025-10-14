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
class EnhancedKeyboardNavigation extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;
  final VoidCallback? onEscapePressed;

  const EnhancedKeyboardNavigation({
    Key? key,
    required this.child,
    this.scrollController,
    this.onEscapePressed,
  }) : super(key: key);

  @override
  State<EnhancedKeyboardNavigation> createState() => _EnhancedKeyboardNavigationState();
}

class _EnhancedKeyboardNavigationState extends State<EnhancedKeyboardNavigation> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
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
      // Handle scrolling with space key when not on a focusable element
      if (event.logicalKey == LogicalKeyboardKey.space && 
          !event.isKeyPressed(LogicalKeyboardKey.shift) &&
          FocusManager.instance.primaryFocus?.context?.widget is! EditableText) {
        // Scroll down by 100 pixels
        _scrollController.animateTo(
          _scrollController.offset + 100,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        return;
      }

      // Handle arrow key events for scrolling (when not in a text field)
      if (FocusManager.instance.primaryFocus?.context?.widget is! EditableText) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          // Scroll up by 100 pixels
          _scrollController.animateTo(
            _scrollController.offset - 100,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          // Scroll down by 100 pixels
          _scrollController.animateTo(
            _scrollController.offset + 100,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          // Page up - scroll up by 80% of screen height
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset - screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          // Page down - scroll down by 80% of screen height
          final screenHeight = MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            _scrollController.offset + screenHeight * 0.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.home) {
          // Home key - scroll to top
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (event.logicalKey == LogicalKeyboardKey.end) {
          // End key - scroll to bottom
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }

      // Handle Escape key
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        // Call the escape callback if provided
        widget.onEscapePressed?.call();
        
        // Also try to close any open dialogs or popups
        Navigator.maybePop(context);
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
        autofocus: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}