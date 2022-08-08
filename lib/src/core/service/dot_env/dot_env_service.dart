// ignore_for_file: sort_constructors_first

import 'dart:io';

class DotEnvService {
  final Map<String, String> _map = {};

  DotEnvService({Map<String, String>? mocks}) {
    if (mocks == null) {
      _init();
    } else {
      _map.addAll(mocks);
    }
  }

  void _init() {
    final file = File('.env');
    final envText = file.readAsStringSync();
    for (final line in envText.split('\n')) {
      if (line.isEmpty) {
        continue;
      }
      final lineSplit = line.split('=');
      if (lineSplit.length != 2) {
        continue;
      }
      _map[lineSplit[0]] = lineSplit[1].trim();
    }
  }

  String? operator [](String key) {
    return _map[key];
  }
}
