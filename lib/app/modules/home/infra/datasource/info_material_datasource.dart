import 'package:vitrine_ufma/app/modules/home/domain/entities/basic_material_info.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';

abstract class IIInfoMaterialDatasource {
  Future<List> getInfoMaterial();
  Future<BasicMaterialInfo> getBasicMaterialInfo({required int bookId});
  Future<List<Book>> getFilteredMaterial(
      {required String search,
      required String filter,
      Map<String, dynamic>? query});
  Future<Map> getDetailInfoMaterial(int id);
  Future<List<Book>> getRelatedInfoMaterial({required List<String> keywords});
  Future<List> getMostAccessedMaterials(int limit);
  Future<List> getTopRatedMaterials(int limit);
  Future<void> addTagToMaterial(
      {required int bookId, required List<String> tags});
  Future<Map> createListInfoMat(
      {required String name, bool public = true, required List<int> ids});
  Future<void> deleteListInfoMat({required int idList});
  Future<Map> addFavorite(int id);
  Future<void> addItemsToList({required int id, required int idList});
  Future<void> removeItemFromList({required int id, required int idList});
  Future<void> setReview({required int bookId, required double rating});
  Future<bool> deleteReview({required int bookId});
  Future<List> getReadingList();
  Future<List> getPermissons();
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType});
  Future<void> removeBook(int id);
  Future<void> enableOrDisableUser(
      {required String email, required bool enable});
}
