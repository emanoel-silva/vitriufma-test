import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/repositories/login_repository.dart';
import 'package:vitrine_ufma/app/modules/auth/errors/login_errros.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/datasources/login_datasource.dart';

class LoginRepositoryImpl implements ILoginRepository {
  final ILoginDatasource datasource;
  final ILocalStorage localStorage;

  LoginRepositoryImpl({required this.datasource, required this.localStorage});

  @override
  Future<Either<Failure, LoggedUser>> loginWithGoogle() async {
    try {
      var result = await datasource.loginWithGoogle();
      return Right(result);
    } on EmailNotFound catch (e) {
      return Left(e);
    } on AnyGoogleAccountSelected catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LoginGoogleError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await datasource.logout();
      return const Right(unit);
    } on LogoutGoogleError catch (e) {
      return Left(e);
    } catch (e) {
      return Left(LogoutGoogleError(message: 'Erro ao tentar fazer logout $e'));
    }
  }
}
