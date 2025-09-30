import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';

abstract class ILoginDatasource {
  Future<LoggedUser> loginWithGoogle();
  Future<void> logout();
}
