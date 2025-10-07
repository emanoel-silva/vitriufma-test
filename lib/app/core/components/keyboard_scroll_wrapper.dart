import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that enables keyboard scrolling (arrow keys) for its child content
class KeyboardScrollWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;

  const KeyboardScrollWrapper({
    Key? key,
    required this.child,
    this.scrollController,
  }) : super(key: key);

  @override
  State<KeyboardScrollWrapper> createState() => _KeyboardScrollWrapperState();
}

class _KeyboardScrollWrapperState extends State<KeyboardScrollWrapper> {
  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

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
      // Handle arrow key events for scrolling
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
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}