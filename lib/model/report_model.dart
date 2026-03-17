import 'dart:convert';


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