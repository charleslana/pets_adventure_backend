// ignore_for_file: sort_constructors_first

import 'dart:convert';

class TokenizationModel {
  final String accessToken;
  final String refreshToken;

  TokenizationModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory TokenizationModel.fromMap(Map<String, dynamic> map) {
    return TokenizationModel(
      accessToken: map['access_token'] ?? '',
      refreshToken: map['refresh_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenizationModel.fromJson(String source) =>
      TokenizationModel.fromMap(json.decode(source));
}
