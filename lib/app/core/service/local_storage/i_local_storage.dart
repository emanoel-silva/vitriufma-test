abstract class ILocalStorage {
  Map getData({required key});
  Map getKeyData({required boxKey, required dataKey});
  Future<bool> setBool({
    required String box,
    required String key,
    required bool value,
  });
  Future<bool> getBool({required String box, required String key});
  Future<bool> saveData(
      {required String key, required Map<dynamic, dynamic> data});
  Future<bool> addData(
      {required String boxKey, required Map<dynamic, dynamic> data});
  Future<bool> saveKeyData(
      {required String boxKey,
      required String dataKey,
      required Map<dynamic, dynamic> data});

  /// Salva uma lista de dados em uma caixa Hive.
  ///
  /// Este método salva uma lista de dados na caixa Hive especificada.
  ///
  /// - [boxKey]: A chave da caixa Hive onde os dados serão armazenados.
  /// - [data]: A lista de mapas de dados a serem armazenados.
  ///
  /// **Importante**: Antes de chamar este método, certifique-se de que a caixa Hive
  /// correspondente tenha sido inicializada na inicialização do aplicativo. Você pode
  /// fazer isso chamando `Hive.openBox` na função `main` ou `auth_store` ou em algum lugar no início
  /// do ciclo de vida do aplicativo.
  ///
  /// Retorna um [Future] que eventualmente produz um valor booleano indicando se
  /// os dados foram salvos com sucesso. Retorna `true` se os dados foram salvos
  /// com sucesso e `false` se ocorrer um erro durante o processo de salvamento.
  Future<bool> saveListData(
      {required String boxKey, required List<Map<dynamic, dynamic>> data});

  Future<List<dynamic>> getListData({required String boxKey});
  Future<bool> clearBox({required String boxKey});
  Future<bool> deleteKeyData({required String boxKey, required String key});
}
