import 'dart:convert';

QueueModel queueModelFromJson(String str) => QueueModel.fromJson(json.decode(str));
String queueModelToJson(QueueModel data) => json.encode(data.toJson());
class QueueModel {
  QueueModel({
      num? id, 
      String? queueDate, 
      num? tokenNumber, 
      String? status, 
      num? appointmentId, 
      num? clinicId, 
      String? createdAt, 
      Appointment? appointment,}){
    _id = id;
    _queueDate = queueDate;
    _tokenNumber = tokenNumber;
    _status = status;
    _appointmentId = appointmentId;
    _clinicId = clinicId;
    _createdAt = createdAt;
    _appointment = appointment;
}

  QueueModel.fromJson(dynamic json) {
    _id = json['id'];
    _queueDate = json['queueDate'];
    _tokenNumber = json['tokenNumber'];
    _status = json['status'];
    _appointmentId = json['appointmentId'];
    _clinicId = json['clinicId'];
    _createdAt = json['createdAt'];
    _appointment = json['appointment'] != null ? Appointment.fromJson(json['appointment']) : null;
  }
  num? _id;
  String? _queueDate;
  num? _tokenNumber;
  String? _status;
  num? _appointmentId;
  num? _clinicId;
  String? _createdAt;
  Appointment? _appointment;
QueueModel copyWith({  num? id,
  String? queueDate,
  num? tokenNumber,
  String? status,
  num? appointmentId,
  num? clinicId,
  String? createdAt,
  Appointment? appointment,
}) => QueueModel(  id: id ?? _id,
  queueDate: queueDate ?? _queueDate,
  tokenNumber: tokenNumber ?? _tokenNumber,
  status: status ?? _status,
  appointmentId: appointmentId ?? _appointmentId,
  clinicId: clinicId ?? _clinicId,
  createdAt: createdAt ?? _createdAt,
  appointment: appointment ?? _appointment,
);
  num? get id => _id;
  String? get queueDate => _queueDate;
  num? get tokenNumber => _tokenNumber;
  String? get status => _status;
  num? get appointmentId => _appointmentId;
  num? get clinicId => _clinicId;
  String? get createdAt => _createdAt;
  Appointment? get appointment => _appointment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['queueDate'] = _queueDate;
    map['tokenNumber'] = _tokenNumber;
    map['status'] = _status;
    map['appointmentId'] = _appointmentId;
    map['clinicId'] = _clinicId;
    map['createdAt'] = _createdAt;
    if (_appointment != null) {
      map['appointment'] = _appointment?.toJson();
    }
    return map;
  }

}

/// id : 60
/// appointmentDate : "2026-03-20T00:00:00.000Z"
/// timeSlot : "10:00-10:15"
/// status : "queued"
/// patientId : 769
/// clinicId : 777
/// createdAt : "2026-03-17T03:39:15.868Z"
/// patient : {"name":"hiral","phone":"7859478745"}

Appointment appointmentFromJson(String str) => Appointment.fromJson(json.decode(str));
String appointmentToJson(Appointment data) => json.encode(data.toJson());
class Appointment {
  Appointment({
      num? id, 
      String? appointmentDate, 
      String? timeSlot, 
      String? status, 
      num? patientId, 
      num? clinicId, 
      String? createdAt, 
      Patient? patient,}){
    _id = id;
    _appointmentDate = appointmentDate;
    _timeSlot = timeSlot;
    _status = status;
    _patientId = patientId;
    _clinicId = clinicId;
    _createdAt = createdAt;
    _patient = patient;
}

  Appointment.fromJson(dynamic json) {
    _id = json['id'];
    _appointmentDate = json['appointmentDate'];
    _timeSlot = json['timeSlot'];
    _status = json['status'];
    _patientId = json['patientId'];
    _clinicId = json['clinicId'];
    _createdAt = json['createdAt'];
    _patient = json['patient'] != null ? Patient.fromJson(json['patient']) : null;
  }
  num? _id;
  String? _appointmentDate;
  String? _timeSlot;
  String? _status;
  num? _patientId;
  num? _clinicId;
  String? _createdAt;
  Patient? _patient;
Appointment copyWith({  num? id,
  String? appointmentDate,
  String? timeSlot,
  String? status,
  num? patientId,
  num? clinicId,
  String? createdAt,
  Patient? patient,
}) => Appointment(  id: id ?? _id,
  appointmentDate: appointmentDate ?? _appointmentDate,
  timeSlot: timeSlot ?? _timeSlot,
  status: status ?? _status,
  patientId: patientId ?? _patientId,
  clinicId: clinicId ?? _clinicId,
  createdAt: createdAt ?? _createdAt,
  patient: patient ?? _patient,
);
  num? get id => _id;
  String? get appointmentDate => _appointmentDate;
  String? get timeSlot => _timeSlot;
  String? get status => _status;
  num? get patientId => _patientId;
  num? get clinicId => _clinicId;
  String? get createdAt => _createdAt;
  Patient? get patient => _patient;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['appointmentDate'] = _appointmentDate;
    map['timeSlot'] = _timeSlot;
    map['status'] = _status;
    map['patientId'] = _patientId;
    map['clinicId'] = _clinicId;
    map['createdAt'] = _createdAt;
    if (_patient != null) {
      map['patient'] = _patient?.toJson();
    }
    return map;
  }

}

/// name : "hiral"
/// phone : "7859478745"

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));
String patientToJson(Patient data) => json.encode(data.toJson());
class Patient {
  Patient({
      String? name, 
      String? phone,}){
    _name = name;
    _phone = phone;
}

  Patient.fromJson(dynamic json) {
    _name = json['name'];
    _phone = json['phone'];
  }
  String? _name;
  String? _phone;
Patient copyWith({  String? name,
  String? phone,
}) => Patient(  name: name ?? _name,
  phone: phone ?? _phone,
);
  String? get name => _name;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['phone'] = _phone;
    return map;
  }

}