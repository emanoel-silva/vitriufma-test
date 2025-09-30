import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/login/');

  @override
  Future<bool> canActivate(String path, ModularRoute router) async {
    return Modular.get<AuthStore>().user != null;
  }
}
