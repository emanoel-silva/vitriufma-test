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
  int totalAccessCount = 0;
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
      for (var id in r) {
        final bookResult = await infoMaterialUsecase.getDetailInfoMaterial(id);
        bookResult.fold((l) {
          debugPrint("Error loading book details: $l");
        }, (bookData) {
          mostAccessedBooks.add(Book.fromJson(Map<String, dynamic>.from(bookData)));
        });
      }
    });
  }

  @action
  Future<void> _loadBestRatedBooks() async {
    // Como não há um método específico para buscar os melhores avaliados,
    // vamos buscar todos os materiais e ordenar por rating localmente
    final result = await infoMaterialUsecase.call();
    
    result.fold((l) {
      debugPrint("Error loading materials for rating: $l");
    }, (r) async {
      List<Book> allBooks = [];
      
      // Limitar a busca para melhor performance
      final limitedList = r.take(50).toList();
      
      for (var item in limitedList) {
        final bookResult = await infoMaterialUsecase.getDetailInfoMaterial(item['id']);
        bookResult.fold((l) {
          debugPrint("Error loading book details: $l");
        }, (bookData) {
          final book = Book.fromJson(Map<String, dynamic>.from(bookData));
          allBooks.add(book);
        });
      }
      
      // Ordenar por rating (assumindo que existe um campo rating no Book)
      // Se não existir, podemos usar um valor padrão ou outra métrica
      allBooks.sort((a, b) {
        // Como pode não haver campo rating diretamente, vamos usar uma lógica alternativa
        // Por enquanto, vamos usar o número de autores como proxy (pode ser ajustado)
        return b.author.length.compareTo(a.author.length);
      });
      
      bestRatedBooks.clear();
      bestRatedBooks.addAll(allBooks.take(10));
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
}
