class Failure implements Exception {
  final String message;

  Failure(this.message);

  @override
  String toString() {
    String? msg = message;
    return msg.trim().replaceAll('Exception: ', '') ?? "Erro";
  }
}

class DataSourceError extends Failure {
  DataSourceError({message = 'Erro na consulta'})
      : super(message ?? 'erro nulo');
}

class InvalidParamets extends Failure {
  InvalidParamets({message = 'Parametros inválidos'}) : super(message);
}

class ParametersEmptyError extends Failure {
  ParametersEmptyError({required String message}) : super(message);
}

class ServerException extends Failure {
  ServerException({required String message}) : super(message);
}
