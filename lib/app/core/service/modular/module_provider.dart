import 'package:vitrine_ufma/app/core/core_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widget_module.dart';

class ModuloProvider extends WidgetModule {
  final Widget page;
  final Module module;

  const ModuloProvider({super.key, required this.page, required this.module});

  @override
  void binds(Injector i) {
    module.binds(i);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  Widget get view => page;
}
