import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandler(Request request) {
  const path = 'specs/swagger.yaml';
  final handler = SwaggerUI(
    path,
    title: 'Pets Adventure',
    deepLink: true,
  );
  return handler(request);
}
