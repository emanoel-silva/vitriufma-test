import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/repositories/login_repository.dart';

abstract class ILoginWithGoogleUsecase {
  Future<Either<Failure, LoggedUser>> call();
}

class LoginWithGoogleUsecaseImpl implements ILoginWithGoogleUsecase {
  final ILoginRepository repository;

  LoginWithGoogleUsecaseImpl({required this.repository});

  @override
  Future<Either<Failure, LoggedUser>> call() async {
    final result = await repository.loginWithGoogle();
    return result;
  }
}
