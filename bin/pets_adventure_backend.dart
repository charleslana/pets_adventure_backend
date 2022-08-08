// ignore_for_file: avoid_print

import 'dart:io';

import 'package:pets_adventure_backend/pets_adventure_backend.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final handler = await startShelfModular();
  final env = Platform.environment;
  final port = env.entries.firstWhere((element) => element.key == 'PORT',
      orElse: () => const MapEntry('PORT', '3000'));
  final server =
      await shelf_io.serve(handler, '0.0.0.0', int.parse(port.value));
  print('Serving at http://${server.address.host}:${server.port}');
}
