import 'package:flutter/material.dart';

/// Theme constants for keyboard focus indicators
class KeyboardFocusTheme {
  // Focus ring colors
  static const Color primaryFocusColor = Color(0xFF2196F3);
  static const Color secondaryFocusColor = Color(0xFF1976D2);
  static const Color errorFocusColor = Color(0xFFE53935);
  static const Color warningFocusColor = Color(0xFFFF9800);
  static const Color successFocusColor = Color(0xFF4CAF50);

  // Focus ring styles
  static const double focusRingWidth = 2.0;
  static const double focusRingOffset = 2.0;
  static const BorderRadius focusRingRadius = BorderRadius.all(Radius.circular(4));

  // Animation durations
  static const Duration focusAnimationDuration = Duration(milliseconds: 150);
  static const Duration hoverAnimationDuration = Duration(milliseconds: 100);

  // Background colors for focused elements
  static const Color focusBackgroundColor = Color(0x1A2196F3);
  static const Color hoverBackgroundColor = Color(0x0D2196F3);

  /// Get focus decoration for a widget
  static BoxDecoration getFocusDecoration({
    Color? focusColor,
    double? width,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        color: focusColor ?? primaryFocusColor,
        width: width ?? focusRingWidth,
      ),
      borderRadius: borderRadius ?? focusRingRadius,
    );
  }

  /// Get hover decoration for a widget
  static BoxDecoration getHoverDecoration({
    Color? hoverColor,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: hoverColor ?? hoverBackgroundColor,
      borderRadius: borderRadius ?? focusRingRadius,
    );
  }

  /// Get combined focus and hover decoration
  static BoxDecoration getCombinedDecoration({
    required bool isFocused,
    required bool isHovered,
    Color? focusColor,
    Color? hoverColor,
    double? focusWidth,
    BorderRadius? borderRadius,
  }) {
    if (isFocused) {
      return getFocusDecoration(
        focusColor: focusColor,
        width: focusWidth,
        borderRadius: borderRadius,
        backgroundColor: isHovered ? (hoverColor ?? hoverBackgroundColor) : null,
      );
    } else if (isHovered) {
      return getHoverDecoration(
        hoverColor: hoverColor,
        borderRadius: borderRadius,
      );
    }
    return const BoxDecoration();
  }

  /// Create a focus-aware container decoration
  static Widget buildFocusContainer({
    required Widget child,
    required bool isFocused,
    bool isHovered = false,
    Color? focusColor,
    Color? hoverColor,
    double? focusWidth,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
  }) {
    return AnimatedContainer(
      duration: animationDuration ?? focusAnimationDuration,
      decoration: getCombinedDecoration(
        isFocused: isFocused,
        isHovered: isHovered,
        focusColor: focusColor,
        hoverColor: hoverColor,
        focusWidth: focusWidth,
        borderRadius: borderRadius,
      ),
      padding: padding,
      child: child,
    );
  }

  /// Create a skip link style decoration
  static BoxDecoration getSkipLinkDecoration() {
    return BoxDecoration(
      color: primaryFocusColor,
      borderRadius: BorderRadius.circular(4),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Get text style for focused elements
  static TextStyle getFocusedTextStyle({
    TextStyle? baseStyle,
    Color? focusColor,
  }) {
    return (baseStyle ?? const TextStyle()).copyWith(
      color: focusColor ?? primaryFocusColor,
      fontWeight: FontWeight.w600,
    );
  }

  /// Get outline input border for focused text fields
  static OutlineInputBorder getFocusedInputBorder({
    Color? focusColor,
    double? width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: focusColor ?? primaryFocusColor,
        width: width ?? focusRingWidth,
      ),
    );
  }
}

/// Mixin for widgets that need focus and hover states
mixin FocusHoverMixin<T extends StatefulWidget> on State<T> {
  bool _isFocused = false;
  bool _isHovered = false;

  bool get isFocused => _isFocused;
  bool get isHovered => _isHovered;

  void setFocused(bool focused) {
    if (_isFocused != focused) {
      setState(() {
        _isFocused = focused;
      });
    }
  }

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      setState(() {
        _isHovered = hovered;
      });
    }
  }

  BoxDecoration getStateDecoration({
    Color? focusColor,
    Color? hoverColor,
    double? focusWidth,
    BorderRadius? borderRadius,
  }) {
    return KeyboardFocusTheme.getCombinedDecoration(
      isFocused: _isFocused,
      isHovered: _isHovered,
      focusColor: focusColor,
      hoverColor: hoverColor,
      focusWidth: focusWidth,
      borderRadius: borderRadius,
    );
  }
}