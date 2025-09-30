// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_widget_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppWidgetStore on _AppWidgetStoreBase, Store {
  Computed<bool>? _$isDarkComputed;

  @override
  bool get isDark => (_$isDarkComputed ??= Computed<bool>(() => super.isDark,
          name: '_AppWidgetStoreBase.isDark'))
      .value;

  late final _$mainColorAtom =
      Atom(name: '_AppWidgetStoreBase.mainColor', context: context);

  @override
  Color? get mainColor {
    _$mainColorAtom.reportRead();
    return super.mainColor;
  }

  @override
  set mainColor(Color? value) {
    _$mainColorAtom.reportWrite(value, super.mainColor, () {
      super.mainColor = value;
    });
  }

  late final _$fontFamilyAtom =
      Atom(name: '_AppWidgetStoreBase.fontFamily', context: context);

  @override
  FontsFamily get fontFamily {
    _$fontFamilyAtom.reportRead();
    return super.fontFamily;
  }

  @override
  set fontFamily(FontsFamily value) {
    _$fontFamilyAtom.reportWrite(value, super.fontFamily, () {
      super.fontFamily = value;
    });
  }

  late final _$appContextAtom =
      Atom(name: '_AppWidgetStoreBase.appContext', context: context);

  @override
  BuildContext? get appContext {
    _$appContextAtom.reportRead();
    return super.appContext;
  }

  @override
  set appContext(BuildContext? value) {
    _$appContextAtom.reportWrite(value, super.appContext, () {
      super.appContext = value;
    });
  }

  late final _$selectedThemeAtom =
      Atom(name: '_AppWidgetStoreBase.selectedTheme', context: context);

  @override
  int get selectedTheme {
    _$selectedThemeAtom.reportRead();
    return super.selectedTheme;
  }

  @override
  set selectedTheme(int value) {
    _$selectedThemeAtom.reportWrite(value, super.selectedTheme, () {
      super.selectedTheme = value;
    });
  }

  late final _$_AppWidgetStoreBaseActionController =
      ActionController(name: '_AppWidgetStoreBase', context: context);

  @override
  dynamic setMainColor(Color value) {
    final _$actionInfo = _$_AppWidgetStoreBaseActionController.startAction(
        name: '_AppWidgetStoreBase.setMainColor');
    try {
      return super.setMainColor(value);
    } finally {
      _$_AppWidgetStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFontsFamily(FontsFamily value) {
    final _$actionInfo = _$_AppWidgetStoreBaseActionController.startAction(
        name: '_AppWidgetStoreBase.setFontsFamily');
    try {
      return super.setFontsFamily(value);
    } finally {
      _$_AppWidgetStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setContext(BuildContext value) {
    final _$actionInfo = _$_AppWidgetStoreBaseActionController.startAction(
        name: '_AppWidgetStoreBase.setContext');
    try {
      return super.setContext(value);
    } finally {
      _$_AppWidgetStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
mainColor: ${mainColor},
fontFamily: ${fontFamily},
appContext: ${appContext},
selectedTheme: ${selectedTheme},
isDark: ${isDark}
    ''';
  }
}
