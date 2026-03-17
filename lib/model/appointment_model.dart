import 'dart:convert';

AppointmentModel appointmentModelFromJson(String str) => AppointmentModel.fromJson(json.decode(str));
String appointmentModelToJson(AppointmentModel data) => json.encode(data.toJson());
class AppointmentModel {
  AppointmentModel({
      num? id, 
      String? appointmentDate, 
      String? timeSlot, 
      String? status, 
      num? patientId, 
      num? clinicId, 
      String? createdAt, 
      QueueEntry? queueEntry,
      Prescription? prescription,
      ReportModel? report,}){
    _id = id;
    _appointmentDate = appointmentDate;
    _timeSlot = timeSlot;
    _status = status;
    _patientId = patientId;
    _clinicId = clinicId;
    _createdAt = createdAt;
    _queueEntry = queueEntry;
    _prescription = prescription;
    _report = report;
}

  AppointmentModel.fromJson(dynamic json) {
    _id = json['id'];
    _appointmentDate = json['appointmentDate'];
    _timeSlot = json['timeSlot'];
    _status = json['status'];
    _patientId = json['patientId'];
    _clinicId = json['clinicId'];
    _createdAt = json['createdAt'];
    _queueEntry = json['queueEntry'] != null ? QueueEntry.fromJson(json['queueEntry']) : null;
    _prescription = json['prescription'] != null ? Prescription.fromJson(json['prescription']) : null;
    _report = json['report'] != null ? ReportModel.fromJson(json['report']) : null;
  }
  num? _id;
  String? _appointmentDate;
  String? _timeSlot;
  String? _status;
  num? _patientId;
  num? _clinicId;
  String? _createdAt;
  QueueEntry? _queueEntry;
  Prescription? _prescription;
  ReportModel? _report;
AppointmentModel copyWith({  num? id,
  String? appointmentDate,
  String? timeSlot,
  String? status,
  num? patientId,
  num? clinicId,
  String? createdAt,
  QueueEntry? queueEntry,
  Prescription? prescription,
  ReportModel? report,
}) => AppointmentModel(  id: id ?? _id,
  appointmentDate: appointmentDate ?? _appointmentDate,
  timeSlot: timeSlot ?? _timeSlot,
  status: status ?? _status,
  patientId: patientId ?? _patientId,
  clinicId: clinicId ?? _clinicId,
  createdAt: createdAt ?? _createdAt,
  queueEntry: queueEntry ?? _queueEntry,
  prescription: prescription ?? _prescription,
  report: report ?? _report,
);
  num? get id => _id;
  String? get appointmentDate => _appointmentDate;
  String? get timeSlot => _timeSlot;
  String? get status => _status;
  num? get patientId => _patientId;
  num? get clinicId => _clinicId;
  String? get createdAt => _createdAt;
  QueueEntry? get queueEntry => _queueEntry;
  Prescription? get prescription => _prescription;
  ReportModel? get report => _report;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['appointmentDate'] = _appointmentDate;
    map['timeSlot'] = _timeSlot;
    map['status'] = _status;
    map['patientId'] = _patientId;
    map['clinicId'] = _clinicId;
    map['createdAt'] = _createdAt;
    if (_queueEntry != null) {
      map['queueEntry'] = _queueEntry?.toJson();
    }
    if (_prescription != null) {
      map['prescription'] = _prescription?.toJson();
    }
    if (_report != null) {
      map['report'] = _report?.toJson();
    }
    return map;
  }

}

/// id : 60
/// queueDate : "2026-03-20T00:00:00.000Z"
/// tokenNumber : 1
/// status : "waiting"
/// appointmentId : 60
/// clinicId : 777
/// createdAt : "2026-03-17T03:39:15.872Z"

QueueEntry queueEntryFromJson(String str) => QueueEntry.fromJson(json.decode(str));
String queueEntryToJson(QueueEntry data) => json.encode(data.toJson());
class QueueEntry {
  QueueEntry({
      num? id, 
      String? queueDate, 
      num? tokenNumber, 
      String? status, 
      num? appointmentId, 
      num? clinicId, 
      String? createdAt,}){
    _id = id;
    _queueDate = queueDate;
    _tokenNumber = tokenNumber;
    _status = status;
    _appointmentId = appointmentId;
    _clinicId = clinicId;
    _createdAt = createdAt;
}

  QueueEntry.fromJson(dynamic json) {
    _id = json['id'];
    _queueDate = json['queueDate'];
    _tokenNumber = json['tokenNumber'];
    _status = json['status'];
    _appointmentId = json['appointmentId'];
    _clinicId = json['clinicId'];
    _createdAt = json['createdAt'];
  }
  num? _id;
  String? _queueDate;
  num? _tokenNumber;
  String? _status;
  num? _appointmentId;
  num? _clinicId;
  String? _createdAt;
QueueEntry copyWith({  num? id,
  String? queueDate,
  num? tokenNumber,
  String? status,
  num? appointmentId,
  num? clinicId,
  String? createdAt,
}) => QueueEntry(  id: id ?? _id,
  queueDate: queueDate ?? _queueDate,
  tokenNumber: tokenNumber ?? _tokenNumber,
  status: status ?? _status,
  appointmentId: appointmentId ?? _appointmentId,
  clinicId: clinicId ?? _clinicId,
  createdAt: createdAt ?? _createdAt,
);
  num? get id => _id;
  String? get queueDate => _queueDate;
  num? get tokenNumber => _tokenNumber;
  String? get status => _status;
  num? get appointmentId => _appointmentId;
  num? get clinicId => _clinicId;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['queueDate'] = _queueDate;
    map['tokenNumber'] = _tokenNumber;
    map['status'] = _status;
    map['appointmentId'] = _appointmentId;
    map['clinicId'] = _clinicId;
    map['createdAt'] = _createdAt;
    return map;
  }

}

/// id : 60
/// medicines : "Medicine list"
/// dosage : "1 tablet twice daily"
/// duration : "7 days"
/// notes : "Take with food"

Prescription prescriptionFromJson(String str) => Prescription.fromJson(json.decode(str));
String prescriptionToJson(Prescription data) => json.encode(data.toJson());
class Prescription {
  Prescription({
      num? id,
      String? medicines,
      String? dosage,
      String? duration,
      String? notes,}){
    _id = id;
    _medicines = medicines;
    _dosage = dosage;
    _duration = duration;
    _notes = notes;
}

  Prescription.fromJson(dynamic json) {
    _id = json['id'];
    final meds = json['medicines'];
    // Backend may return a list of medicine objects; flatten to readable string
    if (meds is List) {
      _medicines = meds
          .map((m) {
            if (m is Map && m.containsKey('name')) {
              final dose = m['dosage'];
              return dose != null ? '${m['name']} (${dose.toString()})' : m['name'].toString();
            }
            return m.toString();
          })
          .join(', ');
    } else {
      _medicines = meds?.toString();
    }
    _dosage = json['dosage']?.toString();
    _duration = json['duration']?.toString();
    _notes = json['notes'];
  }
  num? _id;
  String? _medicines;
  String? _dosage;
  String? _duration;
  String? _notes;
Prescription copyWith({  num? id,
  String? medicines,
  String? dosage,
  String? duration,
  String? notes,
}) => Prescription(  id: id ?? _id,
  medicines: medicines ?? _medicines,
  dosage: dosage ?? _dosage,
  duration: duration ?? _duration,
  notes: notes ?? _notes,
);
  num? get id => _id;
  String? get medicines => _medicines;
  String? get dosage => _dosage;
  String? get duration => _duration;
  String? get notes => _notes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['medicines'] = _medicines;
    map['dosage'] = _dosage;
    map['duration'] = _duration;
    map['notes'] = _notes;
    return map;
  }

}

/// id : 60
/// diagnosis : "Viral Fever"
/// testRecommended : "Blood Test"
/// remarks : "Rest for 3 days"

ReportModel reportModelFromJson(String str) => ReportModel.fromJson(json.decode(str));
String reportModelToJson(ReportModel data) => json.encode(data.toJson());
class ReportModel {
  ReportModel({
      num? id,
      String? diagnosis,
      String? testRecommended,
      String? remarks,}){
    _id = id;
    _diagnosis = diagnosis;
    _testRecommended = testRecommended;
    _remarks = remarks;
}

  ReportModel.fromJson(dynamic json) {
    _id = json['id'];
    _diagnosis = json['diagnosis'];
    _testRecommended = json['testRecommended'];
    _remarks = json['remarks'];
  }
  num? _id;
  String? _diagnosis;
  String? _testRecommended;
  String? _remarks;
ReportModel copyWith({  num? id,
  String? diagnosis,
  String? testRecommended,
  String? remarks,
}) => ReportModel(  id: id ?? _id,
  diagnosis: diagnosis ?? _diagnosis,
  testRecommended: testRecommended ?? _testRecommended,
  remarks: remarks ?? _remarks,
);
  num? get id => _id;
  String? get diagnosis => _diagnosis;
  String? get testRecommended => _testRecommended;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['diagnosis'] = _diagnosis;
    map['testRecommended'] = _testRecommended;
    map['remarks'] = _remarks;
    return map;
  }

}



