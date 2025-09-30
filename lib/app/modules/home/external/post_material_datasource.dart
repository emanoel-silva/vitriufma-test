import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/post_material_datasource.dart';

class PostMaterialDatasource implements IIPostMaterialDatasource {
  final IClientHttp clientHttp;
  final FirebaseStorage storage = FirebaseStorage.instance;

  late ILocalStorage iLstorage = Modular.get<ILocalStorage>();

  PostMaterialDatasource({required this.clientHttp});

  @override
  Future<Map> postInfoMaterial(Map<String, dynamic> data) async {
    Map boxData = iLstorage.getKeyData(boxKey: 'data', dataKey: 'loggedUser');
    String authorization = boxData['token']['Authorization'];

    try {
      final result = await clientHttp
          .post('${AppConst.API_URL}/informational-material', {
        "title": data['title'],
        "author": data['author'],
        "publication_year": data['publication_year'],
        "cover_image": data['cover_image'],
        "abstract": data['abstract'],
        "matters": data['matters'],
        "sub_matters": data['sub_matters'],
        "address": data['address'],
        "summary": data['summary'],
        "availability": data['availability'],
        "tags": data['tags'],
        "number_of_pages": data['number_of_pages'],
        "isbn": data['isbn'],
        "issn": data['issn'],
        "typer": data['typer'],
        "language": data['language'],
        "publisher": data['publisher'],
        "volume": data['volume'],
        "series": data['series'],
        "edition": data['edition'],
        "reprint_update": data['reprint_update'],
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

  @override
  Future<List> uploadBook(Map<String, dynamic> data) async {
    print(jsonEncode({
      "title": data['title'],
      "author": data['author'],
      "publication_year": data['publication_year'],
      "cover_image": data['cover_image'],
      "abstract": data['abstract'],
      "matters": data['matters'],
      "tags": data['tags'],
      "number_of_pages": data['number_of_pages'],
      "isbn": data['isbn'],
      "issn": data['issn'],
      "typer": data['typer'],
      "language": data['language'],
      "publisher": data['publisher'],
      "volume": data['volume'],
      "series": data['series'],
      "edition": data['edition'],
      "reprint_update": data['reprint_update'],
      "file": data['file'],
    }));
    try {
      final result = await clientHttp.post('${AppConst.API_URL}/books', {
        "title": data['title'],
        "author": data['author'],
        "publication_year": data['publication_year'],
        "cover_image": data['cover_image'],
        "abstract": data['abstract'],
        "matters": data['matters'],
        "tags": data['tags'],
        "number_of_pages": data['number_of_pages'],
        "isbn": data['isbn'],
        "issn": data['issn'],
        "typer": data['typer'],
        "language": data['language'],
        "publisher": data['publisher'],
        "volume": data['volume'],
        "series": data['series'],
        "edition": data['edition'],
        "reprint_update": data['reprint_update'],
        "file": data['file'],
      }, headers: {}
          // await user!.authHeaders
          );
      var response = result.data;
      if (result.statusCode == 200) {
        debugPrint('response $response');
        return response;
      }
      throw DataSourceError(message: 'API error: ${response['message']}');
    } catch (e) {
      throw DataSourceError(message: e.toString());
    }
  }

  @override
  Future<String> uploadImage(List<int> imagePath, String fileName) async {
    try {
      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
      await storage
          .ref('images/$uniqueId$fileName')
          .putBlob(Uint8List.fromList(imagePath));
      return await storage.ref('images/$uniqueId$fileName').getDownloadURL();
    } on FirebaseException {
      debugPrint('FirebaseException: Failed to upload image');
      rethrow; // Re-throw the FirebaseException
    } catch (e) {
      throw Exception(
          'Failed to upload image: $e'); // Wrap other exceptions in a more generic one
    }
  }
}
