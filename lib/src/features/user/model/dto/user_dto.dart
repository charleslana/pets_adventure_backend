// ignore_for_file: sort_constructors_first

import 'dart:convert';

class UserDto {
  final int? id;
  final String? email;
  final String? password;
  final String? name;

  UserDto({
    this.id,
    this.email,
    this.password,
    this.name,
  });

  UserDto copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
  }) {
    return UserDto(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'] != null ? map['id'] as int : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDto.fromJson(String source) =>
      UserDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
