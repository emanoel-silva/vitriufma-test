import 'package:vitrine_ufma/app/core/theme/i_app_theme.dart';
import 'package:flutter/material.dart';
import 'them_custom.dart';

class AppThemeDark implements IAppTheme {
  @override
  ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'regular',
      useMaterial3: true,
      // colorScheme: ColorScheme(
      //     brightness: Brightness.dark,
      //     primary: const Color(0xFF0a0a0a),
      //     onPrimary: Colors.white,
      //     secondary: '#BBC7DB'.toColor(),
      //     onSecondary: '#253140'.toColor(),
      //     error: '#D42B05'.toColor(),
      //     onError: '#FFFFFF'.toColor(),
      //     background: '#1A1C1E'.toColor(),
      //     onBackground: '#E2E2E6'.toColor(),
      //     surface: '#43474E'.toColor(),
      //     onSurface: '#C3C7CF'.toColor()),
      extensions: [
        ThemeCustom(
          textColor: const Color(0xFFFFFFFF),
          backgroundColor: Color(0xFF1E1E1E),
          fillColor: const Color(0xFF2C2D33),
          borderColor: const Color(0xFF585858),
        ),
      ],
    );
  }

  @override
  String themeToString() {
    return ThemeMode.light.toString();
  }
}
