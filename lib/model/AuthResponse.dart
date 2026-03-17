import 'dart:convert';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

class AuthResponse {
  final String? token;
  final User? user;

  AuthResponse({this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    token: json['token'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final int? clinicId;
  final String? clinicName;
  final String? clinicCode;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.clinicId,
    this.clinicName,
    this.clinicCode,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    clinicId: json['clinicId'],
    clinicName: json['clinicName'],
    clinicCode: json['clinicCode'],
  );
}
