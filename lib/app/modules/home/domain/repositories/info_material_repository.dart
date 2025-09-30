import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/basic_material_info.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';

abstract class IInfoMaterialRepository {
  Future<Either<Failure, List>> getInfoMaterial();
  Future<Either<Failure, List<Book>>> getFilteredMaterial(
      {required String search,
      required String filter,
      Map<String, dynamic>? query});
  Future<Either<Failure, BasicMaterialInfo>> getBasicMaterialInfo(
      {required int bookId});
  Future<Either<Failure, Map>> getDetailInfoMaterial(int id);
  Future<Either<Failure, List<Book>>> getRelatedInfoMaterial(
      List<String> keywords);
  Future<Either<Failure, List>> getMostAccessedMaterials(int limit);
  Future<Either<Failure, List>> getTopRatedMaterials(int limit);
  Future<Either<Failure, void>> addTagToMaterial(
      {required int bookId, required List<String> tags});
  Future<Either<Failure, void>> createListInfoMat(
      {required String name, bool public = true, required List<int> ids});
  Future<Either<Failure, void>> deleteListInfoMat({required int idList});
  Future<Either<Failure, Map>> addFavorite(int id);
  Future<Either<Failure, void>> addItemsToList(
      {required int id, required int idList});
  Future<Either<Failure, void>> removeItemFromList(
      {required int id, required int idList});
  Future<Either<Failure, List>> getReadingList();
  Future<Either<Failure, void>> setReview(
      {required int bookId, required double rating});
  Future<Either<Failure, bool>> deleteReview({required int bookId});
  Future<Either<Failure, List>> getPermissons();
  Future<Either<Failure, void>> setPermission(
      {required String email,
      required int days,
      required String permissionType});
  Future<Either<Failure, void>> removeBook(int id);
  Future<Either<Failure, void>> enableOrDisableUser(
      {required String email, required bool enable});
}
