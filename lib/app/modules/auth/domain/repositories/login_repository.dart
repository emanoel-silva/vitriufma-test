import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';

abstract class ILoginRepository {
  Future<Either<Failure, LoggedUser>> loginWithGoogle();
  Future<Either<Failure, Unit>> logout();
}
