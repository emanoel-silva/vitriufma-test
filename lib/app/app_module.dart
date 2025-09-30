import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/app_widget_store.dart';
import 'package:vitrine_ufma/app/core/core_module.dart';
import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:vitrine_ufma/app/modules/auth/login_module.dart';
import 'package:vitrine_ufma/app/modules/home/home_module.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/modules/shared_module/shared_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton<AppWidgetStore>(AppWidgetStore.new);
    i.addSingleton<AuthStore>(AuthStore.new);


  }

  @override
  List<Module> get imports => [CoreModule(), SharedModule()];

  @override
  void routes(r) {
    r.module('/', module: CoreModule());
    // r.module('/start', module: StartModule());
    r.module('/auth', module: LoginModule());
    r.module('/home', module: HomeModule());
  }

  @override
  void exportedBinds(i) {
    i.addSingleton<AppWidgetStore>(AppWidgetStore.new);
    i.addSingleton<AuthStore>(AuthStore.new);
  }
}
