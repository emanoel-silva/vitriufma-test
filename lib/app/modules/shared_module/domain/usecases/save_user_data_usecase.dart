import 'package:dartz/dartz.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';
import 'package:vitrine_ufma/app/modules/shared_module/domain/repositories/share_module_repository.dart';

abstract class ISaveUserDataUsecase {
  Future<Either<Failure, Unit>> call({required LoggedUser user});
}

class SaveUserDataUsecaseImpl implements ISaveUserDataUsecase {
  final IShareModuleRepository repository;

  SaveUserDataUsecaseImpl({required this.repository});

  @override
  Future<Either<Failure, Unit>> call({required LoggedUser user}) async {
    return await repository.saveUserData(user: user);
  }
}
