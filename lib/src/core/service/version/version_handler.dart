import 'dart:async';

import 'package:shelf/shelf.dart';

FutureOr<Response> versionHandler() {
  const version = '1.0.0';
  return Response.ok(version);
}
