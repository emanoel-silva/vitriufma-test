import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/basic_material_info.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/info_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/info_material_datasource.dart';

class InfoMaterialRepositoryImpl implements IInfoMaterialRepository {
  final IIInfoMaterialDatasource datasource;

  InfoMaterialRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List>> getInfoMaterial() async {
    try {
      var result = await datasource.getInfoMaterial();
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BasicMaterialInfo>> getBasicMaterialInfo(
      {required int bookId}) async {
    try {
      var result = await datasource.getBasicMaterialInfo(bookId: bookId);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getFilteredMaterial(
      {required String search,
      required String filter,
      Map<String, dynamic>? query}) async {
    try {
      var result = await datasource.getFilteredMaterial(
          search: search, filter: filter, query: query);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getRelatedInfoMaterial(
      List<String> keywords) async {
    try {
      var result = await datasource.getRelatedInfoMaterial(keywords: keywords);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List>> getMostAccessedMaterials(int limit) async {
    try {
      var result = await datasource.getMostAccessedMaterials(limit);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List>> getTopRatedMaterials(int limit) async {
    try {
      var result = await datasource.getTopRatedMaterials(limit);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addTagToMaterial(
      {required int bookId, required List<String> tags}) async {
    try {
      var result =
          await datasource.addTagToMaterial(bookId: bookId, tags: tags);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBook(int id) async {
    try {
      var result = await datasource.removeBook(id);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List>> getPermissons() async {
    try {
      var result = await datasource.getPermissons();
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    try {
      var result = await datasource.setPermission(
          email: email, days: days, permissionType: permissionType);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map>> getDetailInfoMaterial(int id) async {
    try {
      var result = await datasource.getDetailInfoMaterial(id);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createListInfoMat(
      {required String name,
      bool public = true,
      required List<int> ids}) async {
    try {
      var result = await datasource.createListInfoMat(
          name: name, public: public, ids: ids);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListInfoMat({required int idList}) async {
    try {
      var result = await datasource.deleteListInfoMat(idList: idList);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map>> addFavorite(int id) async {
    try {
      var result = await datasource.addFavorite(id);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addItemsToList(
      {required int id, required int idList}) async {
    try {
      var result = await datasource.addItemsToList(id: id, idList: idList);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeItemFromList(
      {required int id, required int idList}) async {
    try {
      var result = await datasource.removeItemFromList(id: id, idList: idList);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setReview(
      {required int bookId, required double rating}) async {
    try {
      var result = await datasource.setReview(bookId: bookId, rating: rating);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview({required int bookId}) async {
    try {
      var result = await datasource.deleteReview(bookId: bookId);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List>> getReadingList() async {
    try {
      var result = await datasource.getReadingList();
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enableOrDisableUser(
      {required String email, required bool enable}) async {
    try {
      var result =
          await datasource.enableOrDisableUser(email: email, enable: enable);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }
}
