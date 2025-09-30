import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'layout_store.g.dart';

class LayoutStore = _LayoutStoreBase with _$LayoutStore;

abstract class _LayoutStoreBase with Store {
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();
  
    //PERMISSÕES
  @observable
  ObservableList permissions = [].asObservable();
  @action
  Future<void> getPemission() async {
    var result = await infoMaterialUsecase.getPermissons();

    result.fold((l) {
      debugPrint("Error: $l");
    }, (r) {
      permissions = ObservableList.of(r);
      debugPrint('Usuário autenticado');
    });
  }

  //SETAR PERMISSÃO
  @action
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    var result = await infoMaterialUsecase.setPermission(
        email: email, days: days, permissionType: permissionType);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao definir permissão");
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Permissão definida com sucesso");
    });
  }

}

