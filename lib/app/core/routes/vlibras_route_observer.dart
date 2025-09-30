import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

// Import condicional do VLibras helper
import '../utils/vlibras_helper_stub.dart' if (dart.library.html) '../utils/vlibras_helper.dart';

/// RouteObserver personalizado para integração com VLibras
class VLibrasRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final VLibrasRouteObserver _instance = VLibrasRouteObserver._internal();
  
  factory VLibrasRouteObserver() => _instance;
  
  VLibrasRouteObserver._internal();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _refreshVLibras();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _refreshVLibras();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _refreshVLibras();
  }

  void _refreshVLibras() {
    if (UniversalPlatform.isWeb) {
      // Delay para garantir que o DOM seja atualizado
      Future.delayed(Duration(milliseconds: 500), () {
        VLibrasHelper.refresh();
      });
    }
  }
}

/// Mixin para ser usado em StatefulWidgets que precisam de integração com VLibras
mixin VLibrasRouteMixin<T extends StatefulWidget> on State<T>, RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VLibrasRouteObserver().subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    VLibrasRouteObserver().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    _onRouteChange();
  }

  @override
  void didPush() {
    _onRouteChange();
  }

  @override
  void didPopNext() {
    _onRouteChange();
  }

  @override
  void didPushNext() {
    _onRouteChange();
  }

  void _onRouteChange() {
    if (UniversalPlatform.isWeb) {
      // Delay para permitir que a página seja renderizada
      Future.delayed(Duration(milliseconds: 300), () {
        VLibrasHelper.reinitialize();
      });
    }
  }
}
