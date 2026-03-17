import 'dart:convert';
import 'package:hospital_api_exam/config/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../model/clinic_model.dart';

class ClinicService {
  final ApiConfig _api = ApiConfig();

  Future<List<ClinicModel>> fetchClinics() async {
    final http.Response res = await _api.get(adminClinicEndpoint);
    if (res.statusCode == 200) {
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        
        if (json['data'] != null) {
          final List<dynamic> data = json['data'] as List<dynamic>;
          return data
              .map((clinic) =>
                  ClinicModel.fromJson(clinic as Map<String, dynamic>))
              .toList();
        }
        
        if (json['clinics'] != null) {
          final List<dynamic> clinics = json['clinics'] as List<dynamic>;
          return clinics
              .map((clinic) =>
                  ClinicModel.fromJson(clinic as Map<String, dynamic>))
              .toList();
        }
        
        return [];
      } catch (e) {
        throw Exception('Failed to parse clinics: ${e.toString()}');
      }
    }
    throw Exception('Unable to load clinics. Status: ${res.statusCode}');
  }

  Future<ClinicModel> fetchClinicById(int id) async {
    final http.Response res = await _api.get('$adminClinicEndpoint/$id');
    if (res.statusCode == 200) {
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        return ClinicModel.fromJson(json);
      } catch (e) {
        throw Exception('Failed to parse clinic: ${e.toString()}');
      }
    }
    throw Exception('Unable to load clinic. Status: ${res.statusCode}');
  }

  Future<bool> createClinic({
    required String name,
    required String code,
  }) async {
    final http.Response res = await _api.post(adminClinicEndpoint, {
      'name': name,
      'code': code,
    });
    return _isSuccess(res);
  }

  Future<bool> updateClinic({
    required int clinicId,
    required String name,
    required String code,
  }) async {
    final http.Response res = await _api.patch('$adminClinicEndpoint/$clinicId', {
      'name': name,
      'code': code,
    });
    return _isSuccess(res);
  }

  Future<bool> deleteClinic(int id) async {
    final http.Response res = await _api.delete('$adminClinicEndpoint/$id');
    return _isSuccess(res);
  }

  bool _isSuccess(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      try {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        return json['error'] == false;
      } catch (_) {
        return true;
      }
    }
    return false;
  }
}

