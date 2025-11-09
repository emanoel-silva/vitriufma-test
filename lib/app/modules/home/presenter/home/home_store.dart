import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  TextEditingController searchController = TextEditingController();
  final ILogoutUsecase logoutUsecase = Modular.get<ILogoutUsecase>();
  late ILocalStorage storage = Modular.get<ILocalStorage>();
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @action
  void setSelectedBook(Book value) {
    // selectedBook.clear();
    selectedBook = (value);
    print("Selected Book: ${selectedBook?.title}");
    Modular.to.pushNamed('/home/books/${value.id}', arguments: value);
    // Modular.to.pushNamed('/home/book/${value.id}', arguments: value);
  }

  //SCROLL CONTROLLERS
  List<ScrollController> scrollController = [];

  //SCROLL PARA A ESQUERDA
  void scrollToLeft(int index) {
    scrollController[index].animateTo(
        scrollController[index].position.minScrollExtent - 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn);
  }

  //SCROLL PARA A DIREITA
  void scrollToRight(int index) {
    scrollController[index].animateTo(
        scrollController[index].position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn);
  }

  @observable
  ObservableList<Book> books = ObservableList<Book>();

  @observable
  Book? selectedBook;

  @observable
  String searchQuery = '';

  @observable
  bool loading = false;

  @computed
  List<Book> get filteredBooks {
    if (searchQuery.isEmpty) {
      return books;
    }
    final query = searchQuery.toLowerCase();
    return books.where((Book) {
      return Book.title.toLowerCase().contains(query);
    }).toList();
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void setbooks(List<Book> newbooks) {
    books.clear();
    books.addAll(newbooks);
  }

  @action
  void selectBook(String? id) {}

  Future<void> loadbooks() async {
    await infoMaterialUsecase.call().then((value) {
      value.fold((l) {
        debugPrint("Error: $l");
      }, (r) {
        books.clear();

        for (var item in r) {
          var book = Book.fromJson(item);
          books.add(book);
        }
      });
    });
    scrollController = List.generate(books.length, (index) {
      return ScrollController();
    });
    // setbooks(mockbooks);
  }

  // BUSCA MATERIS RELACIONADOS
  @observable
  ObservableList relatedBooks = [].asObservable();
  @action
  Future<void> getRelatedInfoMaterial(List<String> keywords) async {
    loading = true;
    relatedBooks.clear();
    var result = await infoMaterialUsecase.getRelatedInfoMaterial(keywords);

    result.fold((l) async {
      debugPrint("Error: $l");
      loading = false;
    }, (r) {
      debugPrint("Success:");
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

  // BUSCA MATERIAIS MAIS ACESSADOS
  @observable
  ObservableList mostAccessedMaterials = [].asObservable();
  @observable
  bool isLoadingMostAccessedMaterials = false;
  @action
  Future<void> getMostAccessedMaterials(int limit) async {
  
    if (isLoadingMostAccessedMaterials) {
      debugPrint("getMostAccessedMaterials: Já está carregando, retornando...");
      return;
    }
    
    debugPrint("getMostAccessedMaterials: Iniciando carregamento com limit=$limit");
    isLoadingMostAccessedMaterials = true;
    loading = true;
    mostAccessedMaterials.clear();

    var result = await infoMaterialUsecase.getMostAccessedMaterials(limit);

    result.fold((l) async {
      debugPrint("getMostAccessedMaterials Error: $l");
      loading = false;
      isLoadingMostAccessedMaterials = false;
    }, (r) async {
      debugPrint("getMostAccessedMaterials Success: Recebidos ${r.length} materiais");
      
      // A API retorna objetos com estrutura {id, title, author, cover_image, rating}
      // Precisamos buscar os detalhes completos de cada material
      for (var item in r) {
        try {
          // Extrai o ID do item
          final id = item['id'];
          debugPrint("getMostAccessedMaterials: Buscando detalhes do material ID=$id (${item['title']})");
          
          var detailResult = await infoMaterialUsecase.getDetailInfoMaterial(id);
          detailResult.fold((l) {
            debugPrint("getMostAccessedMaterials Error ao buscar detalhes do ID $id: $l");
          }, (bookData) {
            debugPrint("getMostAccessedMaterials: Material ${bookData['title']} adicionado");
            mostAccessedMaterials
                .add(Book.fromJson(Map<String, dynamic>.from(bookData).asObservable()));
          });
        } catch (e) {
          debugPrint("getMostAccessedMaterials: Erro ao processar item: $e");
        }
      }

      mostAccessedMaterials = mostAccessedMaterials.asObservable();
      debugPrint("getMostAccessedMaterials: Total de ${mostAccessedMaterials.length} materiais carregados");
      loading = false;
      isLoadingMostAccessedMaterials = false;
    });
  }

  // BUSCA MATERIS MAIS BEM AVALIADOS
  @observable
  ObservableList topRatedMaterials = [].asObservable();
  @observable
  bool isLoadingTopRatedMaterials = false;
  @action
  Future<void> getTopRatedMaterials(int limit) async {

    if (isLoadingTopRatedMaterials) {
      debugPrint("getTopRatedMaterials: Já está carregando, retornando...");
      return;
    }
    
    debugPrint("getTopRatedMaterials: Iniciando carregamento com limit=$limit");
    isLoadingTopRatedMaterials = true;
    loading = true;
    topRatedMaterials.clear();

    var result = await infoMaterialUsecase.getTopRatedMaterials(limit);

    result.fold((l) async {
      debugPrint("getTopRatedMaterials Error: $l");
      loading = false;
      isLoadingTopRatedMaterials = false;
    }, (r) async {
      debugPrint("getTopRatedMaterials Success: Recebidos ${r.length} materiais");
      
      // A API retorna objetos com estrutura {id, title, author, cover_image, rating}
      // Precisamos buscar os detalhes completos de cada material
      for (var item in r) {
        try {
          // Extrai o ID do item
          final id = item['id'];
          debugPrint("getTopRatedMaterials: Buscando detalhes do material ID=$id (${item['title']})");
          
          var detailResult = await infoMaterialUsecase.getDetailInfoMaterial(id);
          detailResult.fold((l) {
            debugPrint("getTopRatedMaterials Error ao buscar detalhes do ID $id: $l");
          }, (bookData) {
            debugPrint("getTopRatedMaterials: Material ${bookData['title']} adicionado");
            topRatedMaterials
                .add(Book.fromJson(Map<String, dynamic>.from(bookData).asObservable()));
          });
        } catch (e) {
          debugPrint("getTopRatedMaterials: Erro ao processar item: $e");
        }
      }
      topRatedMaterials = topRatedMaterials.asObservable();
      debugPrint("getTopRatedMaterials: Total de ${topRatedMaterials.length} materiais carregados");
      loading = false;
      isLoadingTopRatedMaterials = false;
    });
  }
}
