import 'package:vitrine_ufma/app/core/theme/i_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';

import 'them_custom.dart';

class AppThemeLight implements IAppTheme {
  @override
  ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'regular',
      useMaterial3: true,
      // colorScheme: ColorScheme(
      //     brightness: Brightness.light,
      //     primary: '#0A0A0A'.toColor(),
      //     onPrimary: Colors.white,
      //     secondary: '#899A9D'.toColor(),
      //     onSecondary: '#FFFFFF'.toColor(),
      //     error: '#BA1A1A'.toColor(),
      //     onError: '#FFFFFF'.toColor(),
      //     background: '#FAFDFD'.toColor(),
      //     onBackground: '#191C1D'.toColor(),
      //     surface: '#9DEFFF'.toColor(),
      //     onSurface: '#004E59'.toColor()),
      extensions: [
        ThemeCustom(
          textColor: const Color(0xFF0a0a0a),
          backgroundColor: Colors.white,
          fillColor: const Color(0xFFF7931A),
          borderColor: const Color(0xFFD9D9D9),
        ),
      ],
    );
  }

  @override
  String themeToString() {
    return ThemeMode.light.toString();
  }
}
