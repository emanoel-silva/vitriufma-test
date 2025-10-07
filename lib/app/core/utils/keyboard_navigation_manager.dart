import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global keyboard navigation manager that handles keyboard shortcuts across the entire app
class KeyboardNavigationManager {
  static final KeyboardNavigationManager _instance = KeyboardNavigationManager._internal();
  factory KeyboardNavigationManager() => _instance;
  KeyboardNavigationManager._internal();

  /// Registers global keyboard shortcuts for the app
  static void registerGlobalShortcuts(BuildContext context) {
    // This is handled by Flutter's built-in focus traversal
  }

  /// Handles focus traversal between interactive elements
  static void handleTabTraversal({bool reverse = false}) {
    // Flutter handles this automatically with FocusTraversalGroup and FocusScope
  }

  /// Handles activation of focused elements
  static void handleEnterActivation() {
    // Flutter handles this automatically
  }

  /// Handles space activation for checkboxes and buttons
  static void handleSpaceActivation() {
    // Flutter handles this automatically
  }

  /// Handles escape key for closing dialogs/menus
  static void handleEscape(BuildContext context) {
    Navigator.maybePop(context);
  }

  /// Handles arrow key navigation
  static void handleArrowNavigation(LogicalKeyboardKey key) {
    // Custom arrow key handling can be implemented here
  }

  /// Handles home/end navigation
  static void handleHomeEndNavigation(bool isHome) {
    // Home/End navigation handling
  }

  /// Handles Ctrl+Home/End navigation
  static void handleCtrlHomeEndNavigation(bool isHome) {
    // Ctrl+Home/End navigation handling
  }

  /// Handles shift+arrow selection
  static void handleShiftArrowSelection(LogicalKeyboardKey key) {
    // Shift+arrow selection handling
  }
}

/// A widget that provides global keyboard navigation support
class GlobalKeyboardNavigation extends StatefulWidget {
  final Widget child;

  const GlobalKeyboardNavigation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GlobalKeyboardNavigation> createState() => _GlobalKeyboardNavigationState();
}

class _GlobalKeyboardNavigationState extends State<GlobalKeyboardNavigation> {
  final FocusNode _focusNode = FocusNode();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle global keyboard shortcuts
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        KeyboardNavigationManager.handleEscape(context);
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
        child: widget.child,
      ),
    );
  }
}