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
  int totalAccessCount = 0;

  @observable
  int totalBooksCount = 0;

  @observable
  ObservableList<int> weeklyAccessData = <int>[].asObservable();
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
        _loadTotalAccessCount(),
        _loadTotalBooksCount(),
        _loadWeeklyAccessData(),
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
    final result = await infoMaterialUsecase.getMostAccessedMaterials(10);
    
    result.fold((l) {
      debugPrint("Error loading most accessed materials: $l");
    }, (r) async {
      mostAccessedBooks.clear();
      bookAccessCounts.clear();
      
      for (var id in r) {
        final bookResult = await infoMaterialUsecase.getDetailInfoMaterial(id);
        bookResult.fold((l) {
          debugPrint("Error loading book details: $l");
        }, (bookData) {
          final book = Book.fromJson(Map<String, dynamic>.from(bookData));
          mostAccessedBooks.add(book);
          // Simular contagem de acessos para cada livro (seria vindo da API)
          bookAccessCounts[book.id] = (100 - r.indexOf(id) * 10).clamp(10, 100);
        });
      }
    });
  }

  @action
  Future<void> _loadBestRatedBooks() async {
    final result = await infoMaterialUsecase.getTopRatedMaterials(10);
    
    result.fold((l) {
      debugPrint("Error loading top rated materials: $l");
    }, (r) async {
      bestRatedBooks.clear();
      
      for (var id in r) {
        final bookResult = await infoMaterialUsecase.getDetailInfoMaterial(id);
        bookResult.fold((l) {
          debugPrint("Error loading book details: $l");
        }, (bookData) {
          final book = Book.fromJson(Map<String, dynamic>.from(bookData));
          bestRatedBooks.add(book);
          // Simular avaliação para cada livro (seria vindo da API)
          bookRatings[book.id] = (5.0 - (r.indexOf(id) * 0.3)).clamp(3.0, 5.0);
        });
      }
    });
  }

  @action
  Future<void> _loadTotalAccessCount() async {
    // Como não há um método específico para contar acessos totais,
    // vamos simular com base nos materiais mais acessados
    final result = await infoMaterialUsecase.getMostAccessedMaterials(100);
    
    result.fold((l) {
      debugPrint("Error loading access count: $l");
    }, (r) {
      // Simular contagem total de acessos
      totalAccessCount = r.length * 15; // Multiplicador simulado
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

  @action
  Future<void> _loadWeeklyAccessData() async {
    // Simular dados de acesso semanal (em um sistema real, viria da API)
    weeklyAccessData.clear();
    weeklyAccessData.addAll([45, 52, 38, 67, 82, 95, 78]);
  }
}
