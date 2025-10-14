import 'dart:io';
import 'dart:convert';

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Server running on localhost:8080');
  
  await for (HttpRequest request in server) {
    if (request.method == 'GET') {
      // Serve index.html for the root path
      var path = request.uri.path == '/' ? '/index.html' : request.uri.path;
      
      // Remove leading slash
      path = path.substring(1);
      
      // Default to index.html if path is a directory
      if (path.isEmpty || path.endsWith('/')) {
        path += 'index.html';
      }
      
      // Construct file path
      var filePath = 'web-build/$path';
      
      // Check if file exists
      var file = File(filePath);
      if (await file.exists()) {
        // Set content type based on file extension
        var contentType = _getContentType(filePath);
        request.response.headers.contentType = ContentType.parse(contentType);
        
        // Serve the file
        await file.openRead().pipe(request.response);
      } else {
        // File not found
        request.response
          ..statusCode = HttpStatus.notFound
          ..write('File not found: $filePath')
          ..close();
      }
    } else {
      // Method not allowed
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Method not allowed')
        ..close();
    }
  }
}

String _getContentType(String filePath) {
  if (filePath.endsWith('.html')) return 'text/html';
  if (filePath.endsWith('.css')) return 'text/css';
  if (filePath.endsWith('.js')) return 'application/javascript';
  if (filePath.endsWith('.json')) return 'application/json';
  if (filePath.endsWith('.png')) return 'image/png';
  if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) return 'image/jpeg';
  if (filePath.endsWith('.gif')) return 'image/gif';
  if (filePath.endsWith('.svg')) return 'image/svg+xml';
  if (filePath.endsWith('.ico')) return 'image/x-icon';
  if (filePath.endsWith('.woff')) return 'font/woff';
  if (filePath.endsWith('.woff2')) return 'font/woff2';
  if (filePath.endsWith('.ttf')) return 'font/ttf';
  if (filePath.endsWith('.otf')) return 'font/otf';
  return 'application/octet-stream';
}