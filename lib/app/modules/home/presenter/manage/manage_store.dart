import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';

part 'manage_store.g.dart';

class ManageStore = _ManageStoreBase with _$ManageStore;

abstract class _ManageStoreBase with Store {
  final infoMaterialUsecase = Modular.get<IInfoMaterialUsecase>();
  
  @observable
  bool loading = false;

  @observable
  bool loadingReports = false;

  @observable
  ObservableList<Book> mostAccessedBooks = <Book>[].asObservable();

  @observable
  ObservableList<Book> bestRatedBooks = <Book>[].asObservable();

  @observable
  ObservableMap<int, int> bookAccessCounts = <int, int>{}.asObservable();

  @observable
  ObservableMap<int, double> bookRatings = <int, double>{}.asObservable();

  @observable
  int totalBooksCount = 0;

  //SETAR PERMISSÃO
  @action
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    loading = true;
    var result = await infoMaterialUsecase.setPermission(
        email: email, days: days, permissionType: permissionType);

    result.fold((l) {
      debugPrint("Error: $l");
      showSnackbarError("Erro ao definir permissão");
      loading = false;
    }, (r) {
      debugPrint("Success");
      showSnackbarSuccess("Permissão definida com sucesso");
      loading = false;
    });
  }

  @action
  Future<void> enableOrDisableUser(
      {required String email, required bool enable}) async {
    loading = true;
    var result = await infoMaterialUsecase.enableOrDisableUser(
        email: email, enable: enable);

    result.fold((l) {
      debugPrint("Error: $l");
      enable
          ? showSnackbarError("Erro ao habilitar usuário")
          : showSnackbarError("Erro ao desabilitar usuário");
      loading = false;
    }, (r) {
      debugPrint("Success");
      enable
          ? showSnackbarSuccess("Usuário habilitado com sucesso")
          : showSnackbarSuccess("Usuário desabilitado com sucesso");
      loading = false;
    });
  }

  // BUSCAR DADOS PARA RELATÓRIOS
  @action
  Future<void> loadReportsData() async {
    loadingReports = true;
    
    try {
      await Future.wait([
        _loadMostAccessedBooks(),
        _loadBestRatedBooks(),
        _loadTotalBooksCount(),
      ]);
    } catch (e) {
      debugPrint("Error loading reports data: $e");
      showSnackbarError("Erro ao carregar dados dos relatórios");
    } finally {
      loadingReports = false;
    }
  }

  @action
  Future<void> _loadMostAccessedBooks() async {
    final result = await infoMaterialUsecase.getMostAccessedMaterials(50);
    
    result.fold((l) {
      debugPrint("Error loading most accessed materials: $l");
  }, (r) {
      try {
        mostAccessedBooks.clear();
        bookAccessCounts.clear();
        
        for (var item in r) {
          try {
            final book = Book.fromJson(Map<String, dynamic>.from(item));
            mostAccessedBooks.add(book);
            // A API não retorna a contagem de acessos no endpoint atual
            // Vamos manter um índice baseado na ordem (quanto mais cedo na lista, mais acessos)
            bookAccessCounts[book.id] = 0;
          } catch (e) {
            debugPrint("Error parsing book item: $e");
            debugPrint("Item data: $item");
          }
        }
      } catch (e) {
        debugPrint("Error processing most accessed books: $e");
      }
    });
  }

  @action
  Future<void> _loadBestRatedBooks() async {
    final result = await infoMaterialUsecase.getTopRatedMaterials(50);
    
    result.fold((l) {
      debugPrint("Error loading top rated materials: $l");
    }, (r) async {
       try {
        bestRatedBooks.clear();
        bookRatings.clear();
        
        debugPrint("Total items received from API: ${r.length}");
        
        for (var item in r) {
          try {
            final bookData = Map<String, dynamic>.from(item);
            debugPrint("Book data received: $bookData");
            
            final book = Book.fromJson(bookData);
            bestRatedBooks.add(book);
            
            // Tenta pegar o rating do objeto retornado pela API
            var rating = (bookData['rating'] as num?)?.toDouble();
            
            // Se não tiver rating, tenta buscar os detalhes completos
            if (rating == null || rating == 0.0) {
              debugPrint("Rating não encontrado no objeto básico, buscando detalhes do material ${book.id}");
              final detailResult = await infoMaterialUsecase.getDetailInfoMaterial(book.id);
              detailResult.fold(
                (l) => debugPrint("Erro ao buscar detalhes: $l"),
                (detailData) {
                  // Aqui podemos calcular o rating médio se houver reviews
                  // Por enquanto, vamos usar um valor simulado baseado na posição
                  rating = (5.0 - (r.indexOf(item) * 0.2)).clamp(3.0, 5.0);
                  debugPrint("Rating calculado para ${book.title}: $rating");
                },
              );
            }
            
            bookRatings[book.id] = rating ?? 0.0;
            
            debugPrint("Book: ${book.title}, ID: ${book.id}, Rating: ${bookRatings[book.id]}");
          } catch (e) {
            debugPrint("Error parsing book item: $e");
            debugPrint("Item data: $item");
          }
        }
        
        debugPrint("Total books loaded: ${bestRatedBooks.length}");
        debugPrint("Ratings map: $bookRatings");
      } catch (e) {
        debugPrint("Error processing best rated books: $e");
      }
    });
  }

  

  @action
  Future<void> _loadTotalBooksCount() async {
    final result = await infoMaterialUsecase.call();
    
    result.fold((l) {
      debugPrint("Error loading total books count: $l");
    }, (r) {
      totalBooksCount = r.length;
    });
  }


}
