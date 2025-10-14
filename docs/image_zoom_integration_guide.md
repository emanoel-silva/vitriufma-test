# Image Zoom Integration Guide

This guide explains how to integrate and use the accessible image zoom feature in the Vitrine UFMA project.

## Overview

The accessible image zoom feature allows users to click on images to view them in a larger, modal dialog with a darkened background. The feature is fully accessible and works with keyboard navigation, screen readers, and touch devices.

## Component: AccessibleImageZoom

The main component is [AccessibleImageZoom](file:///C:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitriufma-test/lib/app/core/components/accessible_image_zoom.dart#L35-L223), located at `lib/app/core/components/accessible_image_zoom.dart`.

### Properties

- `image` (required): The name of the image file in the `assets/images/` directory
- `altText` (optional): Alternative text for screen readers
- `width` (optional): Width of the image
- `height` (optional): Height of the image
- `fit` (optional): How the image should be fitted (e.g., BoxFit.cover)

### Features

1. **Visual Feedback**: Changes mouse cursor to indicate clickable behavior
2. **Keyboard Navigation**: 
   - Enter/Space keys to activate
   - ESC key to close
3. **Touch Support**: Tap to open, tap outside to close
4. **Accessibility**: 
   - Proper semantic labels
   - Screen reader support
   - Focus management
5. **Responsive Design**: 
   - Adapts to different screen sizes
   - Maintains aspect ratio
6. **Interactive Viewer**: 
   - Pinch to zoom
   - Pan functionality

## Usage

### Basic Usage

```dart
import 'package:vitrine_ufma/app/core/components/accessible_image_zoom.dart';

AccessibleImageZoom(
  image: 'example_image.jpg',
  altText: 'Description of the image for screen readers',
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### In Book Cards

To add zoom functionality to book covers in the book card component:

1. Open `lib/app/core/components/book_card.dart`
2. Replace the existing Image.network widget with AccessibleImageZoom:

```dart
// Before
Image.network(
  book.coverImage,
  // ... other properties
)

// After
AccessibleImageZoom(
  image: book.coverImage.split('/').last, // Extract filename from URL
  altText: 'Capa do livro ${book.title}',
  width: 120,
  height: 160,
  fit: BoxFit.cover,
)
```

Note: You may need to adjust the image path depending on how your images are stored.

## Accessibility Features

### Keyboard Navigation

- Users can tab to focus on the image
- Press Enter or Space to open the zoom dialog
- Press ESC to close the dialog
- Focus is automatically returned to the original image after closing

### Screen Reader Support

- Images have proper semantic labels
- The zoom button role is announced
- Focus changes are communicated to screen readers

### Visual Design

- High contrast mode support
- Clear focus indicators
- Appropriate sizing for different zoom levels

## Testing

The component includes unit tests located at `test/accessible_image_zoom_test.dart`. To run the tests:

```bash
flutter test test/accessible_image_zoom_test.dart
```

## Customization

### Styling

To customize the appearance of the zoom dialog, modify the [_ZoomDialog](file:///C:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitriufma-test/lib/app/core/components/accessible_image_zoom.dart#L152-L222) widget in the [accessible_image_zoom.dart](file:///C:/Users/EmanoelSL/OneDrive/Documentos/GitHub/vitriufma-test/lib/app/core/components/accessible_image_zoom.dart) file:

- Change the background opacity by modifying `Colors.black.withOpacity(0.7)`
- Adjust the maximum size by changing the constraints
- Modify the InteractiveViewer properties for different zoom behavior

### Behavior

- To change the zoom limits, adjust `minScale` and `maxScale` in InteractiveViewer
- To modify the double-tap behavior, update the `onInteractionEnd` callback
- To change keyboard shortcuts, modify the `shortcuts` in FocusableActionDetector

## Troubleshooting

### Image Not Loading

1. Verify the image exists in `assets/images/`
2. Check that the image is included in `pubspec.yaml`
3. Run `flutter pub get` after adding new images

### Accessibility Issues

1. Ensure altText is provided for all images
2. Test with screen readers
3. Verify keyboard navigation works correctly

### Performance Issues

1. Optimize image sizes
2. Use appropriate BoxFit values
3. Limit maxScale in InteractiveViewer for memory efficiency

## Best Practices

1. Always provide meaningful altText for accessibility
2. Use appropriate image dimensions to balance quality and performance
3. Test the feature on different devices and screen sizes
4. Verify keyboard navigation and screen reader compatibility
5. Follow WCAG 2.1 guidelines for contrast and focus indicators