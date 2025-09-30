import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/models/logged_user_model.dart';
import 'package:vitrine_ufma/app/modules/shared_module/domain/repositories/share_module_repository.dart';
import 'package:vitrine_ufma/app/modules/shared_module/errors/errors.dart';
import 'package:vitrine_ufma/app/modules/shared_module/infra/datasources/share_module_datasource.dart';

class ShareModuleRepositoryImpl implements IShareModuleRepository {
  final IShareModuleDatasource datasource;
  final ILocalStorage localStorage;

  ShareModuleRepositoryImpl({
    required this.datasource,
    required this.localStorage,
  });

  @override
  Future<Either<Failure, Unit>> saveUserData({required LoggedUser user}) async {
    try {
      final userMap = LoggedUserModel(
              id: user.id,
              image: user.image,
              application: user.application,
              email: user.email,
              name: user.name,
              key: user.key,
              token: user.token)
          .toMap();
      final result = await localStorage.saveKeyData(
          boxKey: 'data', dataKey: 'loggedUser', data: userMap);
      if (result) {
        return const Right(unit);
      }
      return Left(SaveUserDataError());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
