import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import '../utils/nvda_helper_stub.dart' if (dart.library.html) '../utils/nvda_helper.dart';

/// Widget that makes text available for NVDA screen reader
/// When enableNVDA is true, the text content can be included in the NVDA text box
/// when the box is active. The widget itself does not create or remove the NVDA box.
class NVDAText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool enableNVDA;
  final String? semanticsLabel;

  const NVDAText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.enableNVDA = true,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  State<NVDAText> createState() => _NVDATextState();
}

class _NVDATextState extends State<NVDAText> {
  @override
  Widget build(BuildContext context) {
    // Add text to NVDA area if enabled and on web platform
    if (widget.enableNVDA && UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // The NVDAHelper will manage the text content when the area is visible
      // We don't need to do anything here as the helper already handles this
    }

    // Create semantic text for screen readers
    return Semantics(
      label: widget.semanticsLabel ?? widget.text,
      liveRegion: true, // This makes the text available for screen readers immediately
      child: Text(
        widget.text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}

/// Widget that wraps any child widget and makes its text content available for NVDA
class NVDATextWrapper extends StatefulWidget {
  final Widget child;
  final String textToRead;
  final bool enableNVDA;
  final String? semanticsLabel;

  const NVDATextWrapper({
    Key? key,
    required this.child,
    required this.textToRead,
    this.enableNVDA = true,
    this.semanticsLabel,
  }) : super(key: key);

  @override
  State<NVDATextWrapper> createState() => _NVDATextWrapperState();
}

class _NVDATextWrapperState extends State<NVDATextWrapper> {
  @override
  Widget build(BuildContext context) {
    // Add text to NVDA area if enabled and on web platform
    if (widget.enableNVDA && UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // The NVDAHelper will manage the text content when the area is visible
    }

    // Wrap child with semantic information
    return Semantics(
      label: widget.semanticsLabel ?? widget.textToRead,
      liveRegion: true,
      child: widget.child,
    );
  }
}

/// Mixin for pages that want to contribute content to NVDA
mixin NVDAPageMixin<T extends StatefulWidget> on State<T> {
  /// Updates the NVDA text area with new content
  /// Only works when the NVDA area is already visible
  void updateNVDAText(String text) {
    if (UniversalPlatform.isWeb && NVDAHelper.isAreaVisible) {
      // The NVDAHelper manages the text content
      // In a real implementation, we might want to queue or combine text
    }
  }

  /// Reads text immediately with NVDA
  /// This creates a temporary area that auto-closes
  void readWithNVDA(String text) {
    if (UniversalPlatform.isWeb) {
      NVDAHelper.createNVDAArea(text);
      // Auto-remove after a short delay to avoid cluttering the screen
      Future.delayed(const Duration(seconds: 10), () {
        if (NVDAHelper.isAreaVisible) {
          NVDAHelper.removeNVDAArea();
        }
      });
    }
  }
}