import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'reading_list_store.g.dart';

class ReadingListStore = _ReadingListStoreBase with _$ReadingListStore;

abstract class _ReadingListStoreBase with Store {
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @observable
  bool loading = false;

  @observable
  ObservableList readingList = [].asObservable();
  @observable
  List<Book> listBooks = <Book>[];

  //PEGAR LISTA DE MATERIAL INFORMATIVO DO USUÁRIO
  @action
  Future<void> getMaterialList() async {
    loading = true;
    var result = await infoMaterialUsecase.getReadingList();

    result.fold((l) {
      debugPrint("Error: $l");
      loading = false;
    }, (r) {
      debugPrint("Success");

      readingList = r.asObservable();
      loading = false;
    });
  }

  //PEGA MATERIAL INFORMATIVO DA LISTA
  @action
  Future<void> getMaterialFromList(int listId) async {
    loading = true;
    listBooks.clear();

    try {
      if (readingList.isEmpty || listId >= readingList.length) {
        throw Exception('Invalid listId or readingList is empty');
      }

      var listInfoMats = readingList[listId]['listInfoMats'];
      if (listInfoMats == null || listInfoMats.isEmpty) {
        throw Exception('No materials found in the list');
      }

      for (var item in listInfoMats) {
        var result =
            await infoMaterialUsecase.getDetailInfoMaterial(item['id']);
        result.fold(
          (failure) {
            throw Exception('Failed to fetch material details: $failure');
          },
          (data) {
            listBooks.add(Book.fromJson(Map<String, dynamic>.from(data)));
          },
        );
      }
    } catch (e) {
      debugPrint('Error fetching materials from list: $e');
    } finally {
      loading = false;
    }
  }

  //PEGA LISTA COMPARTILHADA
  @action
  Future<void> getSharedList(int id) async {
    loading = true;
    var result =
            await infoMaterialUsecase.getDetailInfoMaterial(id);
        result.fold(
          (failure) {
            throw Exception('Failed to fetch material details: $failure');
          },
          (data) {
            listBooks.add(Book.fromJson(Map<String, dynamic>.from(data)));
          },
        );
  }

  //DELETAR LISTA DE MATERIAL INFORMATIVO
  @action
  Future<void> deleteListInfoMat({required int idList}) async {
    var result = await infoMaterialUsecase.deleteListInfoMat(idList: idList);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao excluir lista");
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Lista excluída com sucesso");
    });
  }

  //REMOVER ITEM DA LISTA DE MATERIAL INFORMATIVO
  @action
  Future<void> removeItemFromList(
      {required int id, required int idList}) async {
    loading = true;
    var result =
        await infoMaterialUsecase.removeItemFromList(id: id, idList: idList);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao remover item da lista");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Item removido da lista");
      loading = false;
    });
  }
}
