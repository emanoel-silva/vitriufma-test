import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/basic_material_info.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/info_material_repository.dart';

abstract class IInfoMaterialUsecase {
  Future<Either<Failure, List>> call();
  Future<Either<Failure, BasicMaterialInfo>> getBasicMaterialInfo(
      {required int bookId});
  Future<Either<Failure, List<Book>>> getFilteredMaterial(
      String search, String filter, Map<String, dynamic>? query);
  Future<Either<Failure, Map>> getDetailInfoMaterial(int id);
  Future<Either<Failure, Map>> addFavorite(int id);
  Future<Either<Failure, void>> addItemsToList(
      {required int id, required int idList});
  Future<Either<Failure, void>> removeItemFromList(
      {required int id, required int idList});
  Future<Either<Failure, void>> createListInfoMat(
      {required String name, bool public = true, required List<int> ids});
  Future<Either<Failure, void>> deleteListInfoMat({required int idList});
  Future<Either<Failure, void>> setReview(
      {required int bookId, required double rating});
  Future<Either<Failure, bool>> deleteReview({required int bookId});
  Future<Either<Failure, List>> getReadingList();
  Future<Either<Failure, List>> getPermissons();
  Future<Either<Failure, void>> setPermission(
      {required String email,
      required int days,
      required String permissionType});
  Future<Either<Failure, void>> removeBook(int id);
  Future<Either<Failure, List<Book>>> getRelatedInfoMaterial(List<String> tags);
  Future<Either<Failure, List>> getMostAccessedMaterials(int limit);
  Future<Either<Failure, List>> getTopRatedMaterials(int limit);
  Future<Either<Failure, void>> addTagToMaterial(
      {required int bookId, required List<String> tags});
  Future<Either<Failure, void>> enableOrDisableUser(
      {required String email, required bool enable});
}

class InfoMaterialUseCaseImpl implements IInfoMaterialUsecase {
  final IInfoMaterialRepository repository;

  InfoMaterialUseCaseImpl({required this.repository});
  @override
  Future<Either<Failure, List>> call() async {
    var result = await repository.getInfoMaterial();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, BasicMaterialInfo>> getBasicMaterialInfo(
      {required int bookId}) async {
    var result = await repository.getBasicMaterialInfo(bookId: bookId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Book>>> getFilteredMaterial(
      String search, String filter, Map<String, dynamic>? query) async {
    var result = await repository.getFilteredMaterial(
        search: search, filter: filter, query: query);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List<Book>>> getRelatedInfoMaterial(
      List<String> keywords) async {
    var result = await repository.getRelatedInfoMaterial(keywords);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List>> getMostAccessedMaterials(int limit) async {
    var result = await repository.getMostAccessedMaterials(limit);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List>> getTopRatedMaterials(int limit) async {
    var result = await repository.getTopRatedMaterials(limit);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> addTagToMaterial(
      {required int bookId, required List<String> tags}) async {
    var result = await repository.addTagToMaterial(bookId: bookId, tags: tags);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> removeBook(int id) async {
    var result = await repository.removeBook(id);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List>> getPermissons() async {
    var result = await repository.getPermissons();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    var result = await repository.setPermission(
        email: email, days: days, permissionType: permissionType);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  Future<Either<Failure, Map>> getDetailInfoMaterial(int id) async {
    var result = await repository.getDetailInfoMaterial(id);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> createListInfoMat(
      {required String name,
      bool public = true,
      required List<int> ids}) async {
    var result = await repository.createListInfoMat(
        name: name, public: public, ids: ids);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> deleteListInfoMat({required int idList}) async {
    var result = await repository.deleteListInfoMat(idList: idList);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, Map>> addFavorite(int id) async {
    var result = await repository.addFavorite(id);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> addItemsToList(
      {required int id, required int idList}) async {
    var result = await repository.addItemsToList(id: id, idList: idList);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> removeItemFromList(
      {required int id, required int idList}) async {
    var result = await repository.removeItemFromList(id: id, idList: idList);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> setReview(
      {required int bookId, required double rating}) async {
    var result = await repository.setReview(bookId: bookId, rating: rating);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, bool>> deleteReview({required int bookId}) async {
    var result = await repository.deleteReview(bookId: bookId);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List>> getReadingList() async {
    var result = await repository.getReadingList();
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> enableOrDisableUser(
      {required String email, required bool enable}) async {
    var result =
        await repository.enableOrDisableUser(email: email, enable: enable);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
