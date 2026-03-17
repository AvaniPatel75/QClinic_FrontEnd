import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_api_exam/config/api_config.dart';
import 'package:hospital_api_exam/model/clinic_model.dart';
import 'package:hospital_api_exam/service/clinic_service.dart';

class ClinicListScreen extends StatefulWidget {
  ClinicListScreen({super.key});

  static const String route = '/clinic-list';

  @override
  State<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends State<ClinicListScreen> {
  List<ClinicModel> clinics=[];

  ClinicService _clinicService=ClinicService();
  @override
  void initState() {
    getAllCinics();
  }

  getAllCinics(){
    _clinicService.fetchClinics().then((value) => setState(() => clinics=value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinics'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: clinics.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(clinics[index].name!),
                subtitle: Text(clinics[index].code!),
            )
            );
          },
        ),
      )
    );
  }
}
