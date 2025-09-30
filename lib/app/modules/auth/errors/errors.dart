import 'package:vitrine_ufma/app/core/errors/failures.dart';

class SaveDataError extends Failure {
  SaveDataError({message = 'Erro ao salvar dados'}) : super(message);
}
