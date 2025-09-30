import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vitrine_ufma/app/app_widget_store.dart';
import 'package:vitrine_ufma/app/core/theme/app_theme_dark.dart';
import 'package:vitrine_ufma/app/core/theme/app_theme_light.dart';
import 'package:vitrine_ufma/app/core/utils/remove_scrollglow.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/routes/vlibras_route_observer.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  AppWidgetStore appStore = Modular.get<AppWidgetStore>();

  @override
  void initState() {
    super.initState();
    super.initState();
  }

  double adjustScale(double devicePixelRatio) {
    if (devicePixelRatio <= 1) {
      return 1.0;
    } else if (devicePixelRatio <= 1.25) {
      double scale = 1.0 - (devicePixelRatio - 1) * 0.4;
      return 1;
    } else {
      return 1.0 - (devicePixelRatio - 1) * 0.4;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            Colors.transparent, // Cor da barra de navegação inferior
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Ícones escuros na barra de status
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light, // Ícones esc
      ),
    );

    Modular.setNavigatorKey(NavigationService.navigatorKey);
    return Observer(builder: (context) {
      var fFontFamily = appStore.fontFamily;
      var mainColor = appStore.mainColor;
      return MaterialApp.router(
        scrollBehavior: BehaviorRemoveScrollGlow(),
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        title: 'Vitrine Virtual',
        themeMode: appStore.isDark ? ThemeMode.dark : ThemeMode.light,
        theme: AppThemeLight().getTheme(),
        darkTheme: AppThemeDark().getTheme(),
        routerDelegate: Modular.routerDelegate,
        routeInformationParser: Modular.routeInformationParser,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          ScreenUtil.init(context, designSize: const Size(411.4, 797.7));
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(builder: (contex) {
              appStore.setContext(contex);

              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  devicePixelRatio: 1,
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: Transform.scale(
                  scale: 1,
                  //  adjustScale(
                  //   UniversalPlatform.isWeb
                  //       ? getWebScale()
                  //       : MediaQuery.of(context).devicePixelRatio,
                  // ),
                  child: child ?? const SizedBox(),
                ),
              );
            }),
          );
        },
      );
    });
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey();
}
