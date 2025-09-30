import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/core_module.dart';
import 'package:vitrine_ufma/app/core/service/modular/widget_module.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/repositories/login_repository.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:vitrine_ufma/app/modules/auth/external/login_datasource.dart';
import 'package:vitrine_ufma/app/modules/auth/presenter/login_page.dart';
import 'package:vitrine_ufma/app/modules/auth/presenter/login_store.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/datasources/login_datasource.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/repositories/login_repository.dart';

class LoginModule extends WidgetModule {
  @override
  void binds(i) {
    i.addSingleton<LoginStore>(LoginStore.new);
    i.add<ILoginRepository>(LoginRepositoryImpl.new);
    i.add<ILoginDatasource>(LoginDatasource.new);
    i.add<ILoginWithGoogleUsecase>(LoginWithGoogleUsecaseImpl.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child(
      '/',
      child: (ctx) => LoginPage(),
      transition: TransitionType.downToUp,
    );
  }

  @override
  Widget get view => LoginPage();
}
