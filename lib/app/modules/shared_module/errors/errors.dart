import 'package:vitrine_ufma/app/core/errors/failures.dart';

class SaveUserDataError extends Failure {
  SaveUserDataError({message = 'Erro ao salvar dados do usuário'})
      : super(message);
}

class CanNotCheckBiometric extends Failure {
  CanNotCheckBiometric({message = 'Não foi possível checar a biometria'})
      : super(message);
}

class CanNotAuthenticateWithBiometrics extends Failure {
  CanNotAuthenticateWithBiometrics(
      {message = 'Não foi possível autenticar com biometria'})
      : super(message);
}

class NoBiometricsFound extends Failure {
  NoBiometricsFound({message = 'Nenhuma biometria encontrada'})
      : super(message);
}

class NotAuthorized extends Failure {
  NotAuthorized({message = 'Biometria não autorizada'}) : super(message);
}

class SaveAuthPreferencesError extends Failure {
  SaveAuthPreferencesError({message = 'Error ao salvar preferências de login'})
      : super(message);
}
