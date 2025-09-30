abstract class IClientHttp {
  Future<Response<dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
  Future<Response<dynamic>> post(String url, dynamic body,
      {Map<String, String>? headers, Map<String, dynamic>? query});
  Future<Response<dynamic>> postFormData(String url, dynamic body,
      {Map<String, String>? headers});
  Future<Response<dynamic>> put(String url, dynamic body,
      {Map<String, String>? headers});
  Future<Response<dynamic>> delete(String url,
      {Map<String, dynamic>? queryParameters, Map<String, String>? headers});
}

class Response<T> {
  final int statusCode;
  final Map<String, dynamic> headers;
  final T data;

  Response({
    required this.statusCode,
    required this.headers,
    required this.data,
  });
}
