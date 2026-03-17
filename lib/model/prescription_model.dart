import 'dart:convert';

PrescriptionModel medicineModelFromJson(String str) => PrescriptionModel.fromJson(json.decode(str));
String medicineModelToJson(PrescriptionModel data) => json.encode(data.toJson());
class PrescriptionModel {
  PrescriptionModel({
      List<Medicines>? medicines, 
      String? notes,}){
    _medicines = medicines;
    _notes = notes;
}

  PrescriptionModel.fromJson(dynamic json) {
    if (json['medicines'] != null) {
      _medicines = [];
      json['medicines'].forEach((v) {
        _medicines?.add(Medicines.fromJson(v));
      });
    }
    _notes = json['notes'];
  }
  List<Medicines>? _medicines;
  String? _notes;
  PrescriptionModel copyWith({  List<Medicines>? medicines,
  String? notes,
}) => PrescriptionModel(  medicines: medicines ?? _medicines,
  notes: notes ?? _notes,
);
  List<Medicines>? get medicines => _medicines;
  String? get notes => _notes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_medicines != null) {
      map['medicines'] = _medicines?.map((v) => v.toJson()).toList();
    }
    map['notes'] = _notes;
    return map;
  }

}

/// name : "Paracetamol"
/// dosage : "500mg"
/// duration : "5 days"

Medicines medicinesFromJson(String str) => Medicines.fromJson(json.decode(str));
String medicinesToJson(Medicines data) => json.encode(data.toJson());
class Medicines {
  Medicines({
      String? name, 
      String? dosage, 
      String? duration,}){
    _name = name;
    _dosage = dosage;
    _duration = duration;
}

  Medicines.fromJson(dynamic json) {
    _name = json['name'];
    _dosage = json['dosage'];
    _duration = json['duration'];
  }
  String? _name;
  String? _dosage;
  String? _duration;
Medicines copyWith({  String? name,
  String? dosage,
  String? duration,
}) => Medicines(  name: name ?? _name,
  dosage: dosage ?? _dosage,
  duration: duration ?? _duration,
);
  String? get name => _name;
  String? get dosage => _dosage;
  String? get duration => _duration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['dosage'] = _dosage;
    map['duration'] = _duration;
    return map;
  }

}