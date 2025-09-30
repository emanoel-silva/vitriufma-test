import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';

abstract class IShareModuleRepository {
  Future<Either<Failure, Unit>> saveUserData({required LoggedUser user});
}
