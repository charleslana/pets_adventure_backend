import 'package:pets_adventure_backend/src/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular() async {
  final handler = Modular(module: AppModule(), middlewares: [
    logRequests(),
    jsonResponse(),
  ]);
  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      final response = await handler(request);
      if (!request.url.path.contains('documentation')) {
        return response.change(headers: {
          'Content-Type': 'application/json',
          ...response.headers,
        });
      }
      return response;
    };
  };
}
