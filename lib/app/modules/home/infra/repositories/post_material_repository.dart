import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/post_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/post_material_datasource.dart';


class PostMaterialRepositoryImpl implements IPostMaterialRepository {
  final IIPostMaterialDatasource datasource;

  PostMaterialRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, Map>> postInfoMaterial(Map<String, dynamic> data) async {
    try {
      var result = await datasource.postInfoMaterial(data);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List>> uploadBook(Map<String, dynamic> data) async {
    try {
      var result = await datasource.uploadBook(data);
      return Right(result);
    } on DataSourceError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<String> uploadImage(List<int> imagePath, String fileName) async {
    try {
      var result = await datasource.uploadImage(imagePath, fileName);
      return result;
    } on DataSourceError catch (e) {
      throw e;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
