import 'package:vitrine_ufma/app/core/errors/failures.dart';

class LoginGoogleError extends Failure {
  LoginGoogleError({message = 'Erro ao logar'}) : super(message);
}

class AnyGoogleAccountSelected extends Failure {
  AnyGoogleAccountSelected({message = ''}) : super(message);
}

class InsertUserError extends Failure {
  InsertUserError({message = ''}) : super(message);
}

class LogoutGoogleError extends Failure {
  LogoutGoogleError({message = 'Erro ao deslogar'}) : super(message);
}

class EmailNotFound extends Failure {
  EmailNotFound({message = 'E-mail não encontrado'}) : super(message);
}

class InvalidPinLength extends Failure {
  InvalidPinLength({message = 'Tamanho de Pin incorreto'}) : super(message);
}
