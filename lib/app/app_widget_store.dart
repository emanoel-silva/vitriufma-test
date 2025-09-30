import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/scheduler.dart';

import 'core/constants/fonts_family.dart';

part 'app_widget_store.g.dart';

class AppWidgetStore = _AppWidgetStoreBase with _$AppWidgetStore;

abstract class _AppWidgetStoreBase with Store {
  @observable
  Color? mainColor;

  @action
  setMainColor(Color value) => mainColor = value;

  @observable
  FontsFamily fontFamily = FontsFamily.PlusJakartaSans;

  @action
  setFontsFamily(FontsFamily value) => fontFamily = value;

  String getFontFamily(String fFontFamily) {
    switch (fontFamily) {
      case FontsFamily.PlusJakartaSans:
        switch (fFontFamily) {
          case 'light':
            return 'plusjakartasans-light';
          case 'regular':
            return 'plusjakartasans-regular';
          case 'medium':
            return 'plusjakartasans-medium';
          case 'bold':
            return 'plusjakartasans-extra-bold';
          case 'extra-bold':
            return 'plusjakartasans-extra-bold';
          case 'semi-bold':
            return 'plusjakartasans-semi-bold';
        }
      case FontsFamily.GoogleEsans:
        switch (fFontFamily) {
          case 'light':
            return 'googleesans-light';
          case 'regular':
            return 'googleesans-regular';
          case 'medium':
            return 'googleesans-medium';
          case 'bold':
            return 'googleesans-bold';
          case 'extra-bold':
            return 'googleesans-extra-bold';
          case 'semi-bold':
            return 'googleesans-semi-bold';
        }
      case FontsFamily.Inter:
        switch (fFontFamily) {
          case 'light':
            return 'inter-light';
          case 'regular':
            return 'inter-regular';
          case 'medium':
            return 'inter-medium';
          case 'bold':
            return 'inter-bold';
          case 'extra-bold':
            return 'inter-extra-bold';
          case 'semi-bold':
            return 'inter-semi-bold';
        }

      case FontsFamily.Urbanist:
        switch (fFontFamily) {
          case 'light':
            return 'urbanist-light';
          case 'regular':
            return 'urbanist-regular';
          case 'medium':
            return 'urbanist-medium';
          case 'bold':
            return 'urbanist-bold';
          case 'extra-bold':
            return 'urbanist-extra-bold';
          case 'semi-bold':
            return 'urbanist-semi-bold';
        }

      case FontsFamily.Manrope:
        switch (fFontFamily) {
          case 'light':
            return 'manrope-light';
          case 'regular':
            return 'manrope-regular';
          case 'medium':
            return 'manrope-medium';
          case 'bold':
            return 'manrope-bold';
          case 'extra-bold':
            return 'manrope-extra-bold';
          case 'semi-bold':
            return 'manrope-semi-bold';
        }

      case FontsFamily.DmSans:
        switch (fFontFamily) {
          case 'light':
            return 'dmsans-light';
          case 'regular':
            return 'dmsans-regular';
          case 'medium':
            return 'dmsans-medium';
          case 'bold':
            return 'dmsans-bold';
          case 'extra-bold':
            return 'dmsans-extra-bold';
          case 'semi-bold':
            return 'dmsans-semi-bold';
        }
    }

    return 'plusjakartasans-regular';
  }

  @observable
  BuildContext? appContext;

  @action
  setContext(BuildContext value) => appContext = value;

  static const String themePreferenceKey = 'selectedTheme';
  @observable
  int selectedTheme = 0; // 0: Claro, 1: Escuro, 2: Sistema

  @computed
  bool get isDark {
    if (selectedTheme == 2) {
      // Aplica o tema do sistema automaticamente
      return getSystemTheme() == Brightness.dark;
    }
    return selectedTheme ==
        1; // Usa tema escuro se o usuário selecionou explicitamente
  }

  Brightness getSystemTheme() {
    // Obtém o tema do dispositivo
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }
}
