import 'package:pets_adventure_backend/src/core/service/dot_env/dot_env_service.dart';
import 'package:test/test.dart';

void main() {
  test('dot env service ...', () async {
    final service = DotEnvService(mocks: {
      'DATABASE_URL': 'postgres://postgres:postgres@localhost:5432',
    });
    expect(
        service['DATABASE_URL'], 'postgres://postgres:postgres@localhost:5432');
  });
}
