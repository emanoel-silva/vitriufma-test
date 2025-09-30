import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/store/auth/auth_store.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:vitrine_ufma/app/modules/auth/errors/login_errros.dart';
import 'package:vitrine_ufma/app/modules/shared_module/domain/usecases/save_user_data_usecase.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginWithGoogleUsecase = Modular.get<ILoginWithGoogleUsecase>();
  final saveUserDataUsecase = Modular.get<ISaveUserDataUsecase>();
  final authStore = Modular.get<AuthStore>();
  GoogleSignInAccount? currentUser;
  final GoogleSignIn googleSignIn = Modular.get<GoogleSignIn>();

  @observable
  bool loading = false;

  Future<void> login() async {
    final result = await loginWithGoogleUsecase();

    result.fold((error) async {
      if (error is EmailNotFound) {
        currentUser = Modular.get<GoogleSignIn>().currentUser;
        if (currentUser == null) {
          return;
        }

        // Modular.to.pushNamed('/start');

        return;
      }
      if (error is AnyGoogleAccountSelected) {
        return;
      }
      // showSnackbarError(error.message);
      return;
    }, (loggedUser) async {
      if (kIsWeb) {
        bool canAccessScope =
            await Modular.get<GoogleSignIn>().canAccessScopes([
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ]);

        Modular.to.pushNamed('/home');

        if (canAccessScope) {
          await saveUser(loggedUser);
          return;
        }
      }
    });
  }

  // Future<void> silentlyLogin() async {
  //   currentUser = await googleSignIn.signInSilently().whenComplete(() => Modular.to.pop());

  //   if (currentUser == null) {
  //     return;
  //   }
  //   debugPrint('currentUser: ${currentUser!.authentication}');
  // }

  Future<void> saveUser(LoggedUser user) async {
    final saveResult = await saveUserDataUsecase(user: user);
    authStore.storage
        .setBool(box: 'temp', key: 'alreadyLoggedInBefore', value: true);
    saveResult.fold((error) {
      showSnackbarError(error.message);
    }, (success) {
      authStore.checkLogin(); //go to home
    });
  }
}
