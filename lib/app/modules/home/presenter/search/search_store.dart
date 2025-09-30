import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'search_store.g.dart';

class SearchStore = _SearchStoreBase with _$SearchStore;

abstract class _SearchStoreBase with Store {
  TextEditingController searchController = TextEditingController();
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();

  @observable
  List<Book> booksFiltered = <Book>[];
  @observable
  bool loading = false;

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

  //METODOS DE BUSCA
  @action
  Future<void> searchWithFilters() async {
    search(searchController.text);
    
    // Modular.to.pushNamed('./result/${searchController.text}');
  
    booksFiltered.clear();
    
  }

  @action
  Future<void> search(String search) async {

    if (search.isEmpty) {
      loading = true;
      booksFiltered.clear();
      loading = false;
      return;
    }

    loading = true;

    print('Buscando $search com o filtro ${filter['value']}');

    var result = await infoMaterialUsecase.getFilteredMaterial(
        search, filter['value'], null);

    result.fold((l) {
      showSnackbarError(l.message);
    }, (r) {
      booksFiltered = List<Book>.of(r);

      Modular.to.pushNamed('./result/${searchController.text}', arguments: booksFiltered);
    });

    loading = false;
  }

  @action
  Future<void> advancedSearchMethod(Map<String, dynamic> query) async {
    try {
      loading = true;
      booksFiltered.clear();

      print('Busca avançada com query: ${query.toString()}');

      // Verificar se a query é apenas uma busca simples disfarçada
      if (_isSimpleSearchQuery(query)) {
        String searchTerm = _extractSearchTermFromQuery(query);
        if (searchTerm.isNotEmpty) {
          debugPrint("Query avançada detectada como busca simples, redirecionando...");
          searchController.text = searchTerm;
          await search(searchTerm);
          return;
        }
      }

      // Para busca avançada, o parâmetro search pode ser vazio já que a query é completa
      var result = await infoMaterialUsecase.getFilteredMaterial(
          "", "all", query);

      result.fold((error) {
        debugPrint("Error in advanced search: ${error.message}");
        showSnackbarError(error.message);
        loading = false;
      }, (books) {
        booksFiltered = List<Book>.from(books);
        if (booksFiltered.isEmpty) {
          showSnackbarError("Nenhum resultado encontrado para os critérios de busca");
        } else {
          // Navigate to search results page with the filtered books
          // Use consistent navigation pattern with simple search
          Modular.to.pushNamed('./result/advanced_search', arguments: booksFiltered);
        }
        loading = false;
      });
    } catch (e) {
      debugPrint("Unexpected error in advanced search: $e");
      showSnackbarError("Erro inesperado durante a busca. Tente novamente.");
      loading = false;
    }
  }

  @action
  void clearSearch() {
    searchController.clear();
    booksFiltered.clear();
    filter = ObservableMap<String, dynamic>.of({
      "value": "all",
      "name": "Todos os Campos"
    });
  }

  // Métodos auxiliares para detectar se uma query avançada é na verdade uma busca simples
  bool _isSimpleSearchQuery(Map<String, dynamic> query) {
    if (!query.containsKey('query')) return false;
    
    var queryContent = query['query'];
    
    // Verificar se é uma query OR simples (como a gerada para busca "all")
    if (queryContent is Map && queryContent.containsKey('or')) {
      var orConditions = queryContent['or'];
      if (orConditions is List && orConditions.isNotEmpty) {
        // Verificar se todas as condições têm o mesmo valor (busca simples)
        String? searchValue;
        List<String> expectedFields = ['title', 'author', 'matters', 'sub_matters', 'language', 'tags', 'isbn', 'issn'];
        
        for (var condition in orConditions) {
          if (condition is Map && condition.length == 1) {
            var field = condition.keys.first;
            var value = condition.values.first;
            
            if (!expectedFields.contains(field)) return false;
            
            if (searchValue == null) {
              searchValue = value.toString();
            } else if (searchValue != value.toString()) {
              return false;
            }
          } else {
            return false;
          }
        }
        
        return searchValue != null && searchValue.isNotEmpty;
      }
    }
    
    return false;
  }

  String _extractSearchTermFromQuery(Map<String, dynamic> query) {
    if (!query.containsKey('query')) return '';
    
    var queryContent = query['query'];
    
    if (queryContent is Map && queryContent.containsKey('or')) {
      var orConditions = queryContent['or'];
      if (orConditions is List && orConditions.isNotEmpty) {
        var firstCondition = orConditions.first;
        if (firstCondition is Map && firstCondition.isNotEmpty) {
          return firstCondition.values.first.toString();
        }
      }
    }
    
    return '';
  }




}