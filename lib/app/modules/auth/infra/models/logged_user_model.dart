import 'dart:convert';

import 'package:vitrine_ufma/app/modules/auth/domain/entities/logged_user.dart';

class LoggedUserModel extends LoggedUser {
  LoggedUserModel({
    required super.id,
    required super.image,
    required super.application,
    super.lastLogin,
    required super.email,
    required super.name,
    required super.key,
    super.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'application': application,
      'lastLogin': lastLogin,
      'email': email,
      'name': name,
      'key': key,
      'token': token,
    };
  }

  factory LoggedUserModel.fromMap(Map<dynamic, dynamic> map) {
    return LoggedUserModel(
      id: map['id'] as String,
      image: map['image'] as String,
      application: map['application'] as String,
      lastLogin: map['lastLogin'],
      email: map['email'] ?? map['config']['email'],
      name: map['name'] ?? map['config']['name'],
      key: map['key'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoggedUserModel.fromJson(String source) =>
      LoggedUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LoggedUser(id: $id, image: $image, application: $application, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(covariant LoggedUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.image == image &&
        other.application == application &&
        other.lastLogin == lastLogin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        application.hashCode ^
        lastLogin.hashCode;
  }
}
