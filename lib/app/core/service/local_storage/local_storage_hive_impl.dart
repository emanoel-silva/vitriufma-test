import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:hive/hive.dart';

class LocalStorageHiveImpl implements ILocalStorage {
  @override
  Map getData({required key}) {
    try {
      return Hive.box(key).toMap();
    } catch (e) {
      return {};
    }
  }

  @override
  Future<bool> saveData({required String key, required Map data}) async {
    await Hive.box(key).putAll(data);
    return true;
  }

  @override
  Future<bool> getBool({required String box, required String key}) async {
    return await Hive.box(box).get(key, defaultValue: false);
  }

  @override
  Future<bool> setBool(
      {required String box, required String key, required bool value}) async {
    try {
      await Hive.box(box).put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Map getKeyData({required boxKey, required dataKey}) {
    try {
      return Hive.box(boxKey).get(dataKey) ?? {};
    } catch (e) {
      return {};
    }
  }

  @override
  Future<bool> saveKeyData(
      {required String boxKey,
      required String dataKey,
      required Map data}) async {
    try {
      await Hive.box(boxKey).put(dataKey, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearBox({required String boxKey}) async {
    Hive.box(boxKey).clear();
    return true;
  }

  @override
  Future<bool> deleteKeyData({required String boxKey, required String key}) {
    try {
      Hive.box(boxKey).delete(key);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> saveListData(
      {required String boxKey, required List<Map> data}) async {
    try {
      final box = Hive.box(boxKey);
      box.addAll(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List> getListData({required String boxKey}) {
    try {
      final box = Hive.box(boxKey);

      List<dynamic> dataList = [];
      for (int i = 0; i < box.length; i++) {
        dataList.add(box.getAt(i));
      }
      return Future.value(dataList);
    } catch (e) {
      // print("Erro ao recuperar dados: $e");
      return Future.value([]);
    }
  }

  @override
  Future<bool> addData({required String boxKey, required Map data}) async {
    try {
      await Hive.box(boxKey).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
