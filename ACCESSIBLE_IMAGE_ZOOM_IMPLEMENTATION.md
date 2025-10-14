# Accessible Image Zoom Implementation Guide

This document provides implementation instructions for adding accessible image zoom functionality to the Vitrine UFMA project.

## Requirements

The image zoom feature should:
1. Display images in a modal dialog when clicked/tapped
2. Have a semi-transparent dark background
3. Center the zoomed image and occupy at most 90% of screen width/height
4. Support closing by clicking outside, tapping again, or pressing ESC
5. Change mouse cursor to indicate zoom capability
6. Work on both desktop and mobile devices
7. Be accessible with keyboard navigation and screen readers
8. Include alternative text for images
9. Not interfere with browser zoom functionality
10. Have smooth visual transitions

## Implementation Steps

### 1. Create the AccessibleImageZoom Component

Create a new file at `lib/app/core/components/accessible_image_zoom.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An accessible image zoom component that displays images in a modal dialog
/// when clicked/tapped, with smooth transitions and full keyboard support.
class AccessibleImageZoom extends StatefulWidget {
  /// The image asset path
  final String image;

  /// Optional alt text for accessibility
  final String? altText;

  /// Optional width for the image
  final double? width;

  /// Optional height for the image
  final double? height;

  /// Optional fit for the image
  final BoxFit? fit;

  const AccessibleImageZoom({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  State<AccessibleImageZoom> createState() => _AccessibleImageZoomState();
}

class _AccessibleImageZoomState extends State<AccessibleImageZoom> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _openZoomDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) {
        return _ZoomDialog(
          image: widget.image,
          altText: widget.altText,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.altText ?? 'Imagem ampliável',
      button: true,
      focused: _focusNode.hasFocus,
      child: GestureDetector(
        onTap: _openZoomDialog,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _openZoomDialog();
                  return null;
                },
              ),
            },
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
            },
            child: Image.asset(
              'assets/images/${widget.image}',
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              filterQuality: FilterQuality.high,
              semanticLabel: widget.altText,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomDialog extends StatelessWidget {
  final String image;
  final String? altText;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final VoidCallback onClose;

  const _ZoomDialog({
    Key? key,
    required this.image,
    this.altText,
    this.width,
    this.height,
    this.fit,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: onClose,
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: GestureDetector(
                  onTap: onClose,
                  child: Image.asset(
                    'assets/images/$image',
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    semanticLabel: altText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### 2. Usage Example

To use the component in your app:

```dart
// Import the component
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';

// Use it in your widget tree
AccessibleImageZoom(
  image: 'example_image.jpg', // Image file in assets/images/
  altText: 'Description of the image for screen readers',
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### 3. Accessibility Features

The implementation includes:

1. **Keyboard Navigation**: 
   - Enter/Space keys to activate
   - ESC key to close
   - Proper focus management

2. **Screen Reader Support**:
   - Semantic labels for images
   - Button role declaration
   - Focus state announcements

3. **Visual Indicators**:
   - Mouse cursor changes on hover
   - Focus indicators
   - Smooth transitions

4. **Responsive Design**:
   - Works on mobile and desktop
   - Adapts to browser zoom
   - Maintains aspect ratio

### 4. Testing the Implementation

1. **Visual Testing**:
   - Click/tap images to verify zoom functionality
   - Check that background is semi-transparent
   - Verify image is centered and properly sized

2. **Keyboard Testing**:
   - Tab to focus on image
   - Press Enter/Space to zoom
   - Press ESC to close

3. **Screen Reader Testing**:
   - Verify alt text is announced
   - Check that button role is identified
   - Confirm focus changes are announced

4. **Mobile Testing**:
   - Tap to zoom
   - Tap outside to close
   - Verify touch targets are adequate

### 5. Integration with Existing Components

To integrate with existing image components:

1. Replace existing [AppImageAsset](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/lib/app/core/components/image_asset.dart#L3-L34) usages with [AccessibleImageZoom](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/lib/app/core/components/accessible_image_zoom.dart#L35-L217) where zoom functionality is needed
2. Ensure all images have appropriate alt text
3. Test across different screen sizes and zoom levels

### 6. Performance Considerations

1. Use `FilterQuality.high` for crisp images
2. Limit maximum scale in InteractiveViewer to prevent excessive memory usage
3. Use proper asset sizing to avoid loading unnecessarily large images

### 7. Troubleshooting

If you encounter issues:

1. **Images not loading**: Verify asset paths in `pubspec.yaml`
2. **Accessibility not working**: Check that semantic labels are provided
3. **Keyboard navigation issues**: Ensure FocusNode is properly managed
4. **Layout problems**: Verify constraints and sizing parameters

This implementation follows Flutter best practices and the accessibility guidelines documented in the project's [ACCESSIBILITY_GUIDE.md](file:///c:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitrineufma/ACCESSIBILITY_GUIDE.md).