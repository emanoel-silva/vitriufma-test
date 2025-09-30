import 'package:flutter/material.dart';

class ThemeCustom extends ThemeExtension<ThemeCustom> {
  final Color? textColor;
  final Color? backgroundColor;
  final Color? fillColor;
  final Color? borderColor;

  ThemeCustom({
    required this.textColor,
    required this.backgroundColor,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  ThemeExtension<ThemeCustom> copyWith(
      {Color? textColor, Color? backgroundColor, Color? fillColor, Color? borderColor}) {
    return ThemeCustom(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ThemeExtension<ThemeCustom> lerp(
      covariant ThemeExtension<ThemeCustom>? other, double t) {
    if (other is! ThemeCustom) {
      return this;
    }

    return ThemeCustom(
      textColor: Color.lerp(textColor, other.textColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
    );
  }
}
