# Keyboard Scrolling Implementation Guide

This document explains how to implement keyboard scrolling (arrow keys) functionality across the entire Vitrine UFMA website.

## Current Implementation

Keyboard scrolling is currently implemented in the `HomeBooksPage` component. The implementation uses:

1. A `RawKeyboardListener` to capture keyboard events
2. A `ScrollController` to control the scrolling behavior
3. A `FocusNode` to ensure the widget can receive keyboard focus

## How It Works

The current implementation in `lib/app/modules/home/presenter/home/home_books_page.dart`:

```dart
class _HomeBooksPageState extends State<HomeBooksPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

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
        child: Column(
          // Page content
        ),
      ),
    );
  }
}
```

## Enhanced Implementation

To improve the keyboard scrolling experience, additional keys can be supported:

```dart
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
      // Page up - scroll up by half the screen height
      final screenHeight = MediaQuery.of(context).size.height;
      _scrollController.animateTo(
        _scrollController.offset - screenHeight * 0.8,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
      // Page down - scroll down by half the screen height
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
```

## Applying to Other Pages

To apply keyboard scrolling to other pages:

1. Add the necessary imports:
```dart
import 'package:flutter/services.dart';
```

2. Add the controller and focus node to the state:
```dart
final ScrollController _scrollController = ScrollController();
final FocusNode _focusNode = FocusNode();
```

3. Initialize focus in `initState`:
```dart
@override
void initState() {
  super.initState();
  // Request focus for keyboard navigation
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _focusNode.requestFocus();
  });
}
```

4. Dispose of resources in `dispose`:
```dart
@override
void dispose() {
  _scrollController.dispose();
  _focusNode.dispose();
  super.dispose();
}
```

5. Wrap the page content with `RawKeyboardListener` and `SingleChildScrollView`:
```dart
@override
Widget build(BuildContext context) {
  return RawKeyboardListener(
    focusNode: _focusNode,
    onKey: _handleKeyEvent,
    child: SingleChildScrollView(
      controller: _scrollController,
      child: // Your page content here
    ),
  );
}
```

## Global Implementation

For a global implementation across the entire website, the keyboard scrolling could be implemented at the app level in `AppWidget`. However, this requires careful consideration as it may interfere with other input fields.

An alternative approach is to create a reusable widget:

```dart
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
    // Implementation as shown above
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
```

This wrapper can then be used to wrap any page that needs keyboard scrolling functionality.