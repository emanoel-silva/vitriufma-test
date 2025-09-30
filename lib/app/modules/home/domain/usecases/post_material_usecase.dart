import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/post_material_repository.dart';

abstract class IPostMaterialUsecase {
  Future<Either<Failure, Map>> call(Map<String, dynamic> data);
  Future<Either<Failure, List>> uploadBook(Map<String, dynamic> data);
  Future<String> uploadImage(List<int> imagePath,String fileName);
}

class PostMaterialUseCaseImpl implements IPostMaterialUsecase {
  final IPostMaterialRepository repository;

  PostMaterialUseCaseImpl({required this.repository});
  @override
  Future<Either<Failure, Map>> call(Map<String, dynamic> data) async {
    var result = await repository.postInfoMaterial(data);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, List>> uploadBook(Map<String, dynamic> data) async {
    var result = await repository.uploadBook(data);
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<String> uploadImage(List<int> imagePath,String fileName) async {
    return await repository.uploadImage(imagePath, fileName);
  }
}
