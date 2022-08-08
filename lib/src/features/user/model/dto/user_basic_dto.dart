// ignore_for_file: sort_constructors_first

import 'dart:convert';

class UserBasicDto {
  final int? id;
  final String? email;
  final String? name;

  UserBasicDto({
    this.id,
    this.email,
    this.name,
  });

  UserBasicDto copyWith({
    int? id,
    String? email,
    String? name,
  }) {
    return UserBasicDto(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory UserBasicDto.fromMap(Map<String, dynamic> map) {
    return UserBasicDto(
      id: map['id'] != null ? map['id'] as int : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBasicDto.fromJson(String source) =>
      UserBasicDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
