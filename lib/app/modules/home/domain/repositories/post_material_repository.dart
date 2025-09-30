import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';

abstract class IPostMaterialRepository {
  Future<Either<Failure, Map>> postInfoMaterial(Map<String, dynamic> data);
  Future<Either<Failure, List>> uploadBook(Map<String, dynamic> data);
  Future<String> uploadImage(List<int> imagePath,String fileName);
}
