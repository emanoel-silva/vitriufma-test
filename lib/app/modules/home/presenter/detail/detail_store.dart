import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'detail_store.g.dart';

class DetailStore = _DetailStoreBase with _$DetailStore;

abstract class _DetailStoreBase with Store {
  TextEditingController searchController = TextEditingController();
  final TextEditingController listNameController = TextEditingController();

  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @observable
  bool loading = false;

  @observable
  ObservableList readingList = [].asObservable();

  @observable
  bool public = true;

  @action
  void setPublic(bool value) {
    public = value;
  }

  @observable
  ObservableMap<String, dynamic> filter = <String, dynamic>{
    "value": "all",
    "name": "Todos os Campos"
  }.asObservable();

  //Filtros
  List filters = [
    {"value": "all", "name": "Todos os Campos"},
    {"value": "title", "name": "Título"},
    {"value": "author", "name": "Autor"},
    {"value": "matters", "name": "Assunto"},
    {"value": "tags", "name": "Tags"}
  ];
  //METODO DE APLICAÇÃO DE FILTRO
  @action
  void applyFilter(Map<String, dynamic> newFilter) {
    filter = ObservableMap<String, dynamic>.of(newFilter);
  }

  //Pega tamanho da tela para definir a quantidade de cards
  int bookCount(double width) {
    if (width < 800) {
      return 2;
    } else if (width < 900) {
      return 3;
    } else if (width < 1024) {
      return 4;
    } else {
      return 5;
    }
  }

  //PEGA UM LIVRO PELO ID
  @observable
  late Book book;
  @action
  Future<void> getBookById(int id) async {
    Book? book;

    loading = true;
    try {
      var result = await infoMaterialUsecase.getDetailInfoMaterial(id);

      result.fold((l) {
        debugPrint("Error: $l");
        loading = false;
      }, (r) {
        book = Book.fromJson(Map<String, dynamic>.from(r));
        this.book = book!;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }

    loading = false;
  }

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

  // BUSCA MATERIAIS MAIS ACESSADOS
  @observable
  ObservableList mostAccessedMaterials = [].asObservable();
  @observable
  bool isLoadingMostAccessedMaterials = false; //
  @action
  Future<void> getMostAccessedMaterials(int limit) async {
    if (isLoadingMostAccessedMaterials) return;
    isLoadingMostAccessedMaterials = true;
    loading = true;
    mostAccessedMaterials.clear();

    var result = await infoMaterialUsecase.getMostAccessedMaterials(limit);

    result.fold((l) async {
      debugPrint("Error: $l");
      loading = false;
      isLoadingMostAccessedMaterials = false;
    }, (r) async {
      debugPrint("Success: ");
      for (var id in r) {
        var result = await infoMaterialUsecase.getDetailInfoMaterial(id);
        result.fold((l) {
          debugPrint("Error: $l");
          loading = false;
        }, (r) {
          mostAccessedMaterials
              .add(Book.fromJson(Map<String, dynamic>.from(r).asObservable()));
        });
      }
      mostAccessedMaterials = mostAccessedMaterials.asObservable();
      loading = false;
      isLoadingMostAccessedMaterials = false;
    });
  }

  // BUSCA MATERIS RELACIONADOS
  @observable
  ObservableList relatedBooks = [].asObservable();
  @action
  Future<void> getRelatedInfoMaterial(List<String> keywords) async {
    loading = true;
    relatedBooks.clear();
    debugPrint("Buscando materiais relacionados com keywords: $keywords");
    var result = await infoMaterialUsecase.getRelatedInfoMaterial(keywords);

    result.fold((l) async {
      debugPrint("Error ao buscar materiais relacionados: $l");
      loading = false;
    }, (r) {
      debugPrint("Success: Encontrados ${r.length} materiais relacionados");
      relatedBooks = r.asObservable();
      loading = false;
    });
  }

  @observable
  ObservableMap<String, ObservableList<Book>> relatedBooksMap =
      ObservableMap<String, ObservableList<Book>>().asObservable();
  @action
  Future<void> fetchRelatedBooks(String keyword) async {
    loading = true;
    var result = await infoMaterialUsecase.getRelatedInfoMaterial([keyword]);
    result.fold((l) async {
      debugPrint("Error: $l");
      loading = false;
    }, (r) {
      debugPrint("Success:");
      relatedBooksMap[keyword] = r.asObservable();
      loading = false;
    });
  }

  //ADICIONAR AOS FAVORITOS
  @action
  Future<void> addFavorite(int id) async {
    loading = true;
    // var result = await infoMaterialUsecase.addItemsToList(id: 1, idList: id);
    var result = await infoMaterialUsecase.addFavorite(id); 

    result.fold((l) async {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao acessar lista de favoritos");
      loading = false;
    }, (r) {
      debugPrint("Success:");
      showSnackbarSuccess("Item adicionado aos favoritos");
      loading = false;
    });
  }

  //ADICIONAR ITEM EM UMA LISTA DE MATERIAL INFORMATIVO
  @action
  Future<void> addItemsToList({required int id, required int idList}) async {
    loading = true;
    var result =
        await infoMaterialUsecase.addItemsToList(id: id, idList: idList);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao adicionar item a lista");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Item adicionado a lista");
      loading = false;
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

  //EXCLUIR MATERIAL INFORMATIVO
  Future<void> removeBook(int id) async {
    loading = true;

    //TODO open dialog to confirm

    var result = await infoMaterialUsecase.removeBook(id);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao excluir item");

      loading = false;
    }, (r) {
      debugPrint("Success");

      searchController.clear();
      filter = ObservableMap<String, dynamic>.of(filters.first);
      showSnackbarSuccess("Item excluído com sucesso");
      loading = false;
    });
  }

  //ADICIONAR TAG AO MATERIAL INFORMATIVO
  @action
  Future<void> addTagToMaterial(
      {required int bookId, required List<String> tags}) async {
    var result =
        await infoMaterialUsecase.addTagToMaterial(bookId: bookId, tags: tags);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao alterar tags");
    }, (r) {
      debugPrint("Success");
      book.tags = tags;
      // showSnackbarSuccess(
      //     "Tags alteradas com sucesso, atualize a página para vizualizar as alterações");
    });
  }

  //REMOVER TAG INDIVIDUAL DO MATERIAL INFORMATIVO
  @action
  Future<void> removeTagFromMaterial(
      {required int bookId, required String tagToRemove, required List<String> currentTags}) async {
    // Criar nova lista sem a tag a ser removida
    List<String> updatedTags = List.from(currentTags);
    updatedTags.remove(tagToRemove);
    
    // Usar o método existente para atualizar com a nova lista
    var result =
        await infoMaterialUsecase.addTagToMaterial(bookId: bookId, tags: updatedTags);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao remover tag");
    }, (r) {
      debugPrint("Success");
      // showSnackbarSuccess("Tag removida com sucesso");
      // Atualizar o livro local com as novas tags
      book.tags = updatedTags;
    });
  }

  //CRIAR LISTA DE MATERIAL INFORMATIVO
  @action
  Future<void> createListInfoMat(
      {required String name,
      bool public = true,
      required List<int> ids}) async {
    var result = await infoMaterialUsecase.createListInfoMat(
        name: name, public: public, ids: ids);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao criar lista");
    }, (r) {
      debugPrint("Success");
      // showSnackbarSuccess("Lista criada com sucesso");
    });
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

  // AVALIA MATERIAL INFORMATIVO
  @action
  Future<void> setReview({required int bookId, required double rating}) async {
    var result =
        await infoMaterialUsecase.setReview(bookId: bookId, rating: rating);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao avaliar item");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Item avaliado com sucesso");
      loading = false;
    });
  }

  // AVALIA MATERIAL INFORMATIVO
  @action
  Future<void> deleteReview({required int bookId}) async {
    var result = await infoMaterialUsecase.deleteReview(bookId: bookId);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao remover avaliação");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Avaliação removida");
      loading = false;
    });
  }
}
