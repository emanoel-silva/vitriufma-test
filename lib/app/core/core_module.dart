import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vitrine_ufma/app/core/service/client/client_http_dio_impl.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:vitrine_ufma/app/core/service/local_file/file_access.dart';
import 'package:vitrine_ufma/app/core/service/local_file/i_file_access.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/local_storage_hive_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitrine_ufma/app/modules/home/home_module.dart';

class CoreModule extends Module {
  @override
  void binds(i) {
    i.addInstance(Dio());
    i.addInstance(LocalAuthentication());
    i.addInstance(ImagePicker());
    i.add<IFileAccess>(FileAccess.new);
    i.addSingleton<IClientHttp>(ClientHttpDioImpl.new);
    i.addSingleton<ILocalStorage>(LocalStorageHiveImpl.new);
    i.addInstance(GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
        clientId:
            '251785222871-8niradh81b3bul26a31vgphnv13m1867.apps.googleusercontent.com'));
  }

  @override
  void routes(r) {
    // if (isDesktop()) {
    webRoutes(r);
    //   return;
    // }
  }

  void webRoutes(RouteManager r) {
    r.module('/', module: HomeModule());
  }
}
