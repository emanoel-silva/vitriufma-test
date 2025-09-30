import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:universal_platform/universal_platform.dart';

class ScreenHelper {
  ScreenHelper._privateConstructor();

  static final ScreenHelper _instance = ScreenHelper._privateConstructor();

  factory ScreenHelper() {
    return _instance;
  }

  static var view = WidgetsBinding.instance.platformDispatcher.views.first;
  static var size = view.physicalSize;

  static bool get isMobile => size.width <= 550;
  static bool get isTablet => (size.width > 550) && (size.width < 1024);
  static bool get isDesktopOrWeb => size.width >= 1024;
  static double get width => size.width;
  static double get height => size.height;

  static double doubleWidth(double width) {
    return (isMobile &&
            (UniversalPlatform.isAndroid || UniversalPlatform.isIOS))
        ? (width).w
        : width;
  }

  static double doubleHeight(double height) {
    return (isMobile &&
            (UniversalPlatform.isAndroid || UniversalPlatform.isIOS))
        ? (height).w
        : height;
  }

  static double getValueDouble(dynamic) {
    return double.tryParse((dynamic ?? "").toString()) ?? 0.0;
  }

  static String? returnValueOrNull(dynamic value) {
    return (value ?? "").toString().trim().isEmpty
        ? null
        : (value ?? "").toString();
  }
}
