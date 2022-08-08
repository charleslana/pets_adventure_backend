// ignore_for_file: avoid_print

import 'package:pets_adventure_backend/pets_adventure_backend.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final handler = await startShelfModular();
  final server = await shelf_io.serve(handler, '0.0.0.0', 3000);
  print('Serving at http://${server.address.host}:${server.port}');
}
