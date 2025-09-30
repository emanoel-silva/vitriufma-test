import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/routes/api_routes.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:dio/dio.dart' as http;

class ClientHttpDioImpl implements IClientHttp {
  final http.Dio _dio;

  ClientHttpDioImpl({required http.Dio dio}) : _dio = dio {
    dio.options = options;
  }

  http.BaseOptions options = http.BaseOptions(
      baseUrl: ApiRoutes.BASE_URL,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 60));

  @override
  Future<Response<dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(url,
          options: http.Options(
            headers: headers,
            responseType: http.ResponseType.json,
          ));
      return Response(
        statusCode: response.statusCode ?? 500,
        headers: response.headers.map,
        data: response.data,
      );
    } on http.DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<Response<dynamic>> post(String url, dynamic body,
      {Map<String, String>? headers, Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.post(url,
          data: body,
          queryParameters: query,
          options: http.Options(
            headers: headers,
            responseType: http.ResponseType.json,
          ));
      return Response(
        statusCode: response.statusCode ?? 500,
        headers: response.headers.map,
        data: response.data,
      );
    } on http.DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<Response<dynamic>> postFormData(String url, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      final data = http.FormData.fromMap(body);
      final response = await _dio.post(url,
          data: data,
          options: http.Options(
            headers: headers,
            responseType: http.ResponseType.json,
          ));
      return Response(
        statusCode: response.statusCode ?? 500,
        headers: response.headers.map,
        data: response.data,
      );
    } on http.DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<Response<dynamic>> put(String url, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.put(url,
          data: body,
          options: http.Options(
            headers: headers,
            responseType: http.ResponseType.json,
          ));
      return Response(
        statusCode: response.statusCode ?? 500,
        headers: response.headers.map,
        data: response.data,
      );
    } on http.DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  @override
  Future<Response<dynamic>> delete(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers}) async {
    try {
      final response = await _dio.delete(url,
          queryParameters: queryParameters,
          options: http.Options(
            headers: headers,
            responseType: http.ResponseType.json,
          ));
      return Response(
        statusCode: response.statusCode ?? 500,
        headers: response.headers.map,
        data: response.data,
      );
    } on http.DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Response _handleError(http.DioException e) {
    if (e.response != null) {
      return Response(
          statusCode: e.response?.statusCode ?? 500,
          headers: e.response?.headers.map ?? {},
          data: e.response?.data);
    } else if (http.DioExceptionType.receiveTimeout == e.type) {
      throw DataSourceError(message: 'Tempo de solicitação esgotado');
    }
    throw DataSourceError(message: e.message);
  }
}
