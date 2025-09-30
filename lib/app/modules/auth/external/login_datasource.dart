import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/auth/errors/login_errros.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/datasources/login_datasource.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/models/logged_user_model.dart';

class LoginDatasource implements ILoginDatasource {
  final IClientHttp clientHttp;
  final GoogleSignIn googleSignIn;
  final localStorage = Modular.get<ILocalStorage>();

  LoginDatasource({required this.clientHttp, required this.googleSignIn});

  @override
  Future<LoggedUserModel> loginWithGoogle() async {
    final result = await googleSignIn.signIn();

//     OAuth2Client googleClient = GoogleOAuth2Client(
// 	redirectUri: 'localhost', //Just one slash, required by Google specs
// 	customUriScheme: 'com.googleusercontent.apps.514010377904-0uobls7k2iohlrhf0kna0mm1nl8btmlo',
// );

    if (result == null) {
      throw AnyGoogleAccountSelected(message: 'Nenhuma conta selecionada');
    }

    final bearer = await googleSignIn.currentUser?.authentication;
    return LoggedUserModel(
      id: result.id,
      email: result.email,
      name: result.displayName ?? "",
      image: result.photoUrl ?? "",
      key: result.id,
      lastLogin: DateTime.now().toString(),
      application: 'google',
      token: {'Authorization': bearer?.accessToken ?? ''},
    );
  }

  @override
  Future<void> logout() async {
    await googleSignIn.disconnect();
  }
}
