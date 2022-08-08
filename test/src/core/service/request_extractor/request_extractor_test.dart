import 'dart:convert';

import 'package:pets_adventure_backend/src/core/service/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extrator = RequestExtractor();

  test('getAuthorizationBearer', () async {
    final request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'bearer flfsdhfopwsuhgoiduhgfosiduhgoiugho',
    });
    final token = extrator.getAuthorizationBearer(request);
    expect(token, 'flfsdhfopwsuhgoiduhgfosiduhgoiugho');
  });

  test('getAuthorizationBasic', () async {
    var credentialAuth = 'example@example.com:123456';
    credentialAuth = base64Encode(credentialAuth.codeUnits);
    final request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'basic $credentialAuth',
    });
    final credential = extrator.getAuthorizationBasic(request);
    expect(credential.email, 'example@example.com');
    expect(credential.password, '123456');
  });
}
