import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      String? token, 
      User? user,}){
    _token = token;
    _user = user;
}

  UserModel.fromJson(dynamic json) {
    _token = json['token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _token;
  User? _user;
UserModel copyWith({  String? token,
  User? user,
}) => UserModel(  token: token ?? _token,
  user: user ?? _user,
);
  String? get token => _token;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

/// id : 0
/// name : "string"
/// email : "string"
/// role : "patient"
/// phone : "string"
/// createdAt : "2026-03-17T03:34:55.199Z"

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? id, 
      String? name, 
      String? email, 
      String? role, 
      String? phone,
      String? createdAt,}){
    _id = id;
    _name = name;
    _email = email;
    _role = role;
    _phone = phone;
    _createdAt = createdAt;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _role = json['role'];
    _phone = json['phone'];
    _createdAt = json['createdAt'];
  }
  num? _id;
  String? _name;
  String? _email;
  String? _role;
  String? _phone;
  String? _createdAt;

User copyWith({  num? id,
  String? name,
  String? email,
  String? role,
  String? phone,
  String? createdAt,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  role: role ?? _role,
  phone: phone ?? _phone,
  createdAt: createdAt ?? _createdAt,
);
  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get role => _role;
  String? get phone => _phone;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['role'] = _role;
    map['phone'] = _phone;
    map['createdAt'] = _createdAt;
    return map;
  }

}