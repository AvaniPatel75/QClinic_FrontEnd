import 'dart:convert';


ClinicModel clinicModelFromJson(String str) => ClinicModel.fromJson(json.decode(str));
String clinicModelToJson(ClinicModel data) => json.encode(data.toJson());
class ClinicModel {
  ClinicModel({
      num? id, 
      String? name, 
      String? code, 
      String? createdAt, 
      num? userCount, 
      num? appointmentCount, 
      num? queueCount,}){
    _id = id;
    _name = name;
    _code = code;
    _createdAt = createdAt;
    _userCount = userCount;
    _appointmentCount = appointmentCount;
    _queueCount = queueCount;
}

  ClinicModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _createdAt = json['createdAt'];
    _userCount = json['userCount'];
    _appointmentCount = json['appointmentCount'];
    _queueCount = json['queueCount'];
  }
  num? _id;
  String? _name;
  String? _code;
  String? _createdAt;
  num? _userCount;
  num? _appointmentCount;
  num? _queueCount;
ClinicModel copyWith({  num? id,
  String? name,
  String? code,
  String? createdAt,
  num? userCount,
  num? appointmentCount,
  num? queueCount,
}) => ClinicModel(  id: id ?? _id,
  name: name ?? _name,
  code: code ?? _code,
  createdAt: createdAt ?? _createdAt,
  userCount: userCount ?? _userCount,
  appointmentCount: appointmentCount ?? _appointmentCount,
  queueCount: queueCount ?? _queueCount,
);
  num? get id => _id;
  String? get name => _name;
  String? get code => _code;
  String? get createdAt => _createdAt;
  num? get userCount => _userCount;
  num? get appointmentCount => _appointmentCount;
  num? get queueCount => _queueCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['createdAt'] = _createdAt;
    map['userCount'] = _userCount;
    map['appointmentCount'] = _appointmentCount;
    map['queueCount'] = _queueCount;
    return map;
  }

}