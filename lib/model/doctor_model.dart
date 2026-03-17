import 'dart:convert';


DoctorModel doctorModelFromJson(String str) =>
    DoctorModel.fromJson(json.decode(str));
String doctorModelToJson(DoctorModel data) => json.encode(data.toJson());

class DoctorModel {
  DoctorModel({
    num? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? specialization,
    num? experience,
    String? createdAt,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _role = role;
    _phone = phone;
    _specialization = specialization;
    _experience = experience;
    _createdAt = createdAt;
  }

  DoctorModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _role = json['role'];
    _phone = json['phone'];
    _specialization = json['specialization'];
    _experience = json['experience'];
    _createdAt = json['createdAt'];
  }

  num? _id;
  String? _name;
  String? _email;
  String? _role;
  String? _phone;
  String? _specialization;
  num? _experience;
  String? _createdAt;

  DoctorModel copyWith({
    num? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? specialization,
    num? experience,
    String? createdAt,
  }) =>
      DoctorModel(
        id: id ?? _id,
        name: name ?? _name,
        email: email ?? _email,
        role: role ?? _role,
        phone: phone ?? _phone,
        specialization: specialization ?? _specialization,
        experience: experience ?? _experience,
        createdAt: createdAt ?? _createdAt,
      );

  num? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get role => _role;
  String? get phone => _phone;
  String? get specialization => _specialization;
  num? get experience => _experience;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['role'] = _role;
    map['phone'] = _phone;
    map['specialization'] = _specialization;
    map['experience'] = _experience;
    map['createdAt'] = _createdAt;
    return map;
  }
}

