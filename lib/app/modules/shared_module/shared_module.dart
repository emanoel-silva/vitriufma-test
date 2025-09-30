import 'package:flutter_modular/flutter_modular.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vitrine_ufma/app/core/core_module.dart';
import 'package:vitrine_ufma/app/modules/shared_module/domain/repositories/share_module_repository.dart';
import 'package:vitrine_ufma/app/modules/shared_module/domain/usecases/save_user_data_usecase.dart';
import 'package:vitrine_ufma/app/modules/shared_module/external/share_module_datasource_impl.dart';
import 'package:vitrine_ufma/app/modules/shared_module/infra/datasources/share_module_datasource.dart';
import 'package:vitrine_ufma/app/modules/shared_module/infra/repositories/share_module_repository_impl.dart';

class SharedModule extends Module {
  @override
  void binds(i) {
    if (UniversalPlatform.isWeb) {}
    i.add<IShareModuleDatasource>(ShareModuleDatasourceImpl.new);
    i.add<IShareModuleRepository>(ShareModuleRepositoryImpl.new);

    i.add<ISaveUserDataUsecase>(SaveUserDataUsecaseImpl.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(RouteManager r) {
    if (UniversalPlatform.isWeb) {
      return;
    }
  }
}
