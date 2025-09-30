import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'auth_status.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final ILocalStorage storage;

  Map<String, dynamic> userMainJson = {};
  Map<String, dynamic> general = {};
  @observable
  LoggedUser? user;
  @action
  setUser(LoggedUser? user) => this.user = user;

  _AuthStoreBase(this.storage) {
    reaction((_) => status, (_) async {
      switch (status) {
        case AuthStatus.Onboard:
          Modular.to.navigate("/start/onboard");
          break;
        case AuthStatus.Start:
          // if (!await getUserMainJson()) {
          //   showSnackbarError(
          //       'Markup e comissão não encontrados para este usuário!');
          //   webLogout();
          //   return;
          // }
          Modular.to.navigate("/start/");
          return;
        case AuthStatus.Initial:
          if (alreadyLoggedInBefore()) {
            Modular.to.navigate("/login/initial");
            return;
          }
          Modular.to.navigate("/login/");
          break;
        default:
      }
    });
  }

  @observable
  AuthStatus? status;

  @action
  void setStatus(AuthStatus value) => status = value;

  void setGeneralJson({required Map<String, dynamic> json}) => general = json;

  bool alreadyLoggedInBefore() {
    try {
      Hive.box('temp').get('alreadyLoggedInBefore') as bool;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> checkOnboard() async {
    setStatus(AuthStatus.Start);
    // return;
    try {
      bool onboard = await storage.getBool(box: "data", key: "login");
      if (!onboard) {
        setStatus(AuthStatus.Initial);
        return;
      }
      setStatus(AuthStatus.Start);
      return;
    } catch (_) {
      setStatus(AuthStatus.Onboard);
    }
  }

  void onboardComplete() {
    storage.setBool(box: "data", key: "onboard", value: true);
    setStatus(AuthStatus.Start);
  }

  void logout() async {
    if (await storage.deleteKeyData(boxKey: 'data', key: 'loggedUser')) {
      userMainJson.clear();
      storage.deleteKeyData(boxKey: 'data', key: 'authWithBiometrics');
      await storage.clearBox(boxKey: 'bag');
      setStatus(AuthStatus.Initial);
      setUser(null);

      return;
    }
    showSnackbarError('Erro ao deletar dados');
    // storage.setBool(box: "data", key: "login", value: false);
  }

  void webLogout() async {
    if (await storage.deleteKeyData(boxKey: 'data', key: 'loggedUser')) {
      setStatus(AuthStatus.Initial);
      setUser(null);

      return;
    }
    showSnackbarError('Erro ao deletar dados');
  }

  Future<void> checkLogin() async {
    try {
      Map boxData = storage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
      if (((boxData["id"] ?? '')).isNotEmpty) {
        setUser(
          LoggedUser(
            id: boxData["id"],
            image: boxData["image"],
            application: boxData["application"],
            email: boxData["email"],
            name: boxData["name"],
            token: boxData["token"],
            key: boxData["key"],
          ),
        );

        Future.delayed(
          const Duration(milliseconds: 300),
          () {
            setStatus(AuthStatus.Start);
          },
        );
        return;
      }
      setStatus(AuthStatus.Initial);
      return;
    } catch (_) {
      setStatus(AuthStatus.Initial);
    }
  }

  Future<void> loadDatabase() async {
    //TODO remover ou refatorar para o novo banco de dados
    try {
      await Future.wait([
        Hive.openBox(
          "data",
          // encryptionCipher: HiveAesCipher(encryptionKey),
        ),
      ]);
    } catch (_) {
      exit(1);
    }
  }
}
