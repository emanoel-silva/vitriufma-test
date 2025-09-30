import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/basic_material_info.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/info_material_datasource.dart';

class InfoMaterialDatasource implements IIInfoMaterialDatasource {
  final IClientHttp clientHttp;
  late ILocalStorage iLstorage = Modular.get<ILocalStorage>();

  InfoMaterialDatasource({required this.clientHttp});

  //LISTA DE MATERIAIS INFORMATIVO
  @override
  Future<List> getInfoMaterial() async {
    try {
      final result = await clientHttp.get(
        '${AppConst.API_URL}/informational-material',
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //Buscar informações de um material informativo
  @override
  Future<List<Book>> getFilteredMaterial(
      {required String search,
      required String filter,
      Map<String, dynamic>? query}) async {
    try {
      Map<String, dynamic> _query = {
        "query": {filter: search}
      };

      if (filter == "all") {
        _query = {
          "query": {
            "or": [
              {"title": search},
              {"author": search},
              {"matters": search},
              {"sub_matters": search},
              {"language": search},
              {"tags": search},
              {"isbn": search},
              {"issn": search},
            ]
          }
        };
      }
      print(jsonEncode(query));
      final result = await clientHttp.post(
        '${AppConst.API_URL}/informational-material/search/with-boolean-operators',
        query ?? _query,
      );
      var response = result.data;

      if(response.isEmpty){
        throw DataSourceError(message: 'Nenhum material encontrado');
      }
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return List<Book>.from(
            response.map((x) => Book.fromJson(x["__data__"])));
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

// BUSCAR INFORMAÇÕES BÁSICAS DE UM MATERIAL INFORMATIVO
  @override
  Future<BasicMaterialInfo> getBasicMaterialInfo({required int bookId}) async {
    try {
      final result = await clientHttp.get(
        '${AppConst.API_URL}/informational-material/$bookId',
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return BasicMaterialInfo.fromJson(response);
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // BUSCA MATERIAIS RELACIONADOS
  @override
  Future<List<Book>> getRelatedInfoMaterial(
      {required List<String> keywords}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    List<Book> books = [];
    try {
      final query = {
        "query": {
          "or": [
            ...keywords.map((keyword) => {"author": keyword}),
            ...keywords.map((keyword) => {"tags": keyword}),
            ...keywords.map((keyword) => {"matters": keyword}),
            ...keywords.map((keyword) => {"sub_matters": keyword}),
          ],
        },
      };

      final result = await clientHttp.post(
          '${AppConst.API_URL}/informational-material/search/with-boolean-operators',
          query,
          headers: {'Authorization': 'Bearer $authorization'});

      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        books = (response as List)
            .map((item) => Book.fromJson(item['__data__']))
            .toList();
        return books;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // BUSCA OS X MATERIAIS MAIS ACESSADOS
  @override
  Future<List> getMostAccessedMaterials(int limit) async {
    try {
      final result = await clientHttp.get(
        '${AppConst.API_URL}/informational-material-most-accessed',
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        List<int> ids =
            (response as List).map((item) => item['id'] as int).toList();
        return ids;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // BUSCA OS X MATERIAIS MAIS BEM AVALIADOS
  @override
  Future<List> getTopRatedMaterials(int limit) async {
    try {
      final result = await clientHttp.get(
        '${AppConst.API_URL}/top-rated-informational-materials',
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        List<int> ids =
            (response as List).map((item) => item['id'] as int).toList();
        return ids;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // ALTERA AS TAGS DE UM MATERIAL
  @override
  Future<void> addTagToMaterial(
      {required List<String> tags, required int bookId}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');

    if (boxData == null ||
        !boxData.containsKey('token') ||
        !boxData['token'].containsKey('Authorization')) {
      throw DataSourceError(message: 'Authorization token is missing');
    }

    String authorization = boxData['token']['Authorization'];

    try {
      print('tags $tags');
      final result =
          await clientHttp.put('${AppConst.API_URL}/informational-material', {
        "id": bookId,
        "attrs": {"tags": tags}
      }, headers: {
        'Authorization': 'Bearer $authorization',
        'Content-Type': 'application/json'
      });

      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //REMOVER MATERIAL INFORMATIVO
  @override
  Future<void> removeBook(int id) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.delete(
          '${AppConst.API_URL}/informational-material',
          queryParameters: {
            'info_mat_id': id
          },
          headers: {
            'Authorization': 'Bearer $authorization',
          });
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //PERMISSOES DE ACESSO
  @override
  Future<List> getPermissons() async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.get('${AppConst.API_URL}/permissions',
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //DETALHES DO MATERIAL INFORMATIVO
  @override
  Future<Map> getDetailInfoMaterial(int id) async {
    try {
      final result = await clientHttp.get(
        '${AppConst.API_URL}/informational-material/$id/details',
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //CRIAR LISTA DE MATERIAL INFORMATIVO FAVORITOS
  @override
  Future<Map> addFavorite(int id) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp
          .post('${AppConst.API_URL}/list-informational-material', {
        // aee20c6a981fe6633c17340037ebb6472f1d8eb9 é o id da lista de favoritos como nome
        'name': 'aee20c6a981fe6633c17340037ebb6472f1d8eb9',
        'public': false,
        'listIDsInfoMats': [id]
      }, headers: {
        'Authorization': 'Bearer $authorization'
      });
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // AVALIAR MATERIAL INFORMATIVO
  @override
  Future<void> setReview({required int bookId, required double rating}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.post(
          '${AppConst.API_URL}/informational-material/review', {},
          query: {'book_id': bookId, 'rating': rating},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // DELETA AVALIAÇÃO DE MATERIAL INFORMATIVO
  @override
  Future<bool> deleteReview({required int bookId}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.delete(
          '${AppConst.API_URL}/informational-material/review',
          queryParameters: {
            'book_id': bookId,
          },
          headers: {
            'Authorization': 'Bearer $authorization'
          });
      var response = result.data;

      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //CRIAR LISTA DE MATERIAL INFORMATIVO
  @override
  Future<Map> createListInfoMat(
      {required String name,
      bool public = true,
      required List<int> ids}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.post(
          '${AppConst.API_URL}/list-informational-material',
          {'name': name, 'public': public, 'listIDsInfoMats': ids},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //DELETAR LISTA DE MATERIAL INFORMATIVO
  @override
  Future<void> deleteListInfoMat({required int idList}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.delete(
          '${AppConst.API_URL}/list-informational-material',
          queryParameters: {'info_mat_list_id': idList},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //ADICIONAR ITEM EM UMA LISTA DE MATERIAL INFORMATIVO
  @override
  Future<void> addItemsToList({required int id, required int idList}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.post(
          '${AppConst.API_URL}/list-informational-material/item',
          {'info_mat_id': id, 'info_mat_list_id': idList},
          query: {'info_mat_id': id, 'info_mat_list_id': idList},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //REMOVER ITEM DE UMA LISTA DE MATERIAL INFORMATIVO
  @override
  Future<void> removeItemFromList(
      {required int id, required int idList}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.delete(
          '${AppConst.API_URL}/list-informational-material/item',
          queryParameters: {'item_id': id, 'list_id': idList},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['detail']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  //LISTAS DE MATERIAL INFORMATIVO DO USUÁRIO
  @override
  Future<List> getReadingList() async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.get(
          '${AppConst.API_URL}/list-informational-material',
          queryParameters: {'user_email': boxData['email']},
          headers: {'Authorization': 'Bearer $authorization'});
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // HABILITAR OU DESABILITAR USUÁRIO
  @override
  Future<void> enableOrDisableUser(
      {required String email, required bool enable}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final url = enable
          ? '${AppConst.API_URL}/enable-user'
          : '${AppConst.API_URL}/disable-user';
      final result = await clientHttp.post(
        url,
        {'target': email},
        query: {'target': email},
        headers: {'Authorization': 'Bearer $authorization'},
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  // ALTERAR PERMISSÃO DE USUÁRIO
  @override
  Future<void> setPermission(
      {required String email,
      required int days,
      required String permissionType}) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];
    try {
      final result = await clientHttp.post(
        '${AppConst.API_URL}/set-permission',
        {'value': permissionType},
        query: {'target': email, 'days': days},
        headers: {'Authorization': 'Bearer $authorization'},
      );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: response['message']);
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }
}
