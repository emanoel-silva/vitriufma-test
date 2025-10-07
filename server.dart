import 'dart:io';
import 'dart:convert';

void main() async {
  final port = 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  
  print('Server running on http://localhost:$port');
  
  await for (HttpRequest request in server) {
    final path = request.requestedUri.path == '/' 
        ? '/index.html' 
        : request.requestedUri.path;
    
    final file = File('build/web$path');
    
    if (await file.exists()) {
      request.response
        ..headers.contentType = _getContentType(path)
        ..addStream(file.openRead());
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not found: $path');
    }
    
    await request.response.close();
  }
}

ContentType _getContentType(String path) {
  if (path.endsWith('.html')) return ContentType('text', 'html');
  if (path.endsWith('.css')) return ContentType('text', 'css');
  if (path.endsWith('.js')) return ContentType('application', 'javascript');
  if (path.endsWith('.json')) return ContentType('application', 'json');
  if (path.endsWith('.png')) return ContentType('image', 'png');
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return ContentType('image', 'jpeg');
  if (path.endsWith('.ico')) return ContentType('image', 'x-icon');
  if (path.endsWith('.svg')) return ContentType('image', 'svg+xml');
  if (path.endsWith('.woff')) return ContentType('font', 'woff');
  if (path.endsWith('.woff2')) return ContentType('font', 'woff2');
  if (path.endsWith('.ttf')) return ContentType('font', 'ttf');
  return ContentType('text', 'plain');
}