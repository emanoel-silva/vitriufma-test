import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/repositories/login_repository.dart';
import 'package:vitrine_ufma/app/modules/auth/errors/login_errros.dart';

abstract class ILogoutUsecase {
  Future<Either<Failure, Unit>> call();
}

class LogoutGoogleImpl implements ILogoutUsecase {
  final ILoginRepository repository;

  LogoutGoogleImpl({required this.repository});

  @override
  Future<Either<Failure, Unit>> call() async {
    try {
      final result = await repository.logout();
      return const Right(unit);
    } catch (e) {
      return Left(LogoutGoogleError(message: 'Erro ao tentar fazer logout $e'));
    }
  }
}
