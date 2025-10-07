# Keyboard Scrolling Integration Guide

## Overview

This guide explains how to implement keyboard scrolling functionality (arrow keys) across all pages of the Vitrine UFMA website.

## Implementation Steps

### 1. Add the Required Import

Add the following import to the top of your Dart file:

```dart
import 'package:vitrine_ufma/app/core/components/keyboard_scroll_wrapper.dart';
```

### 2. Wrap Your Content

Wrap your page content with the `KeyboardScrollWrapper` widget. The typical pattern is:

```dart
return Scaffold(
  // Your scaffold properties
  body: KeyboardScrollWrapper(
    child: Column(
      // Your content here
    ),
  ),
);
```

### 3. Replace SingleChildScrollView (if applicable)

If your page already uses `SingleChildScrollView`, replace it with `KeyboardScrollWrapper`:

**Before:**
```dart
return Scaffold(
  body: SingleChildScrollView(
    child: Column(
      // Your content
    ),
  ),
);
```

**After:**
```dart
return Scaffold(
  body: KeyboardScrollWrapper(
    child: Column(
      // Your content
    ),
  ),
);
```

## Example Implementation

Here's a complete example of how to implement keyboard scrolling:

```dart
import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/keyboard_scroll_wrapper.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardScrollWrapper(
        child: Column(
          children: [
            // Your page content here
            Container(
              height: 200,
              color: Colors.red,
              child: Text('Section 1'),
            ),
            Container(
              height: 200,
              color: Colors.blue,
              child: Text('Section 2'),
            ),
            Container(
              height: 200,
              color: Colors.green,
              child: Text('Section 3'),
            ),
            // Add more content as needed
          ],
        ),
      ),
    );
  }
}
```

## Supported Keys

The keyboard scrolling implementation supports the following keys:

- ↑ Arrow Up: Scroll up by 100 pixels
- ↓ Arrow Down: Scroll down by 100 pixels
- Page Up: Scroll up by 80% of screen height
- Page Down: Scroll down by 80% of screen height
- Home: Scroll to top of page
- End: Scroll to bottom of page

## Testing

To test the keyboard scrolling functionality:

1. Navigate to the page with the implementation
2. Press the arrow up/down keys to scroll in small increments
3. Press Page Up/Page Down to scroll in larger increments
4. Press Home to jump to the top of the page
5. Press End to jump to the bottom of the page

## Best Practices

1. Always wrap the main content, not the entire Scaffold
2. Make sure to import the KeyboardScrollWrapper component
3. Test the functionality on different screen sizes
4. Ensure that form inputs still work correctly with keyboard navigation

## Pages Already Updated

The following pages have already been updated with keyboard scrolling:

1. AboutUsPage (`lib/app/modules/home/presenter/about_us/about_us.dart`)
2. HelpPage (`lib/app/modules/home/presenter/help/help_page.dart`)
3. AcessibilitiesPage (`lib/app/modules/home/presenter/acessibilities/acessibilities_page.dart`)

## Adding to Other Pages

To add keyboard scrolling to other pages, follow these steps:

1. Add the import statement
2. Wrap your content with KeyboardScrollWrapper
3. Test the functionality

## Troubleshooting

If keyboard scrolling is not working:

1. Check that the import statement is correct
2. Verify that the content is wrapped with KeyboardScrollWrapper
3. Make sure the page has enough content to scroll
4. Check that there are no conflicting keyboard listeners
