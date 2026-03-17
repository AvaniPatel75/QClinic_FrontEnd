import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/prescription_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/service/preference_service.dart';

class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  final PrescriptionService _prescriptionService = PrescriptionService();
  List<Prescription> _prescriptions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoad();
  }

  Future<void> _checkLoginAndLoad() async {
    final prefs = PreferenceService();
    final token = await prefs.getToken();
    if (token.isEmpty) {
      setState(() {
        _error = 'Please login to view your prescriptions';
        _isLoading = false;
      });
      return;
    }
    _loadMyPrescriptions();
  }

  Future<void> _loadMyPrescriptions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prescriptions = await _prescriptionService.getMyPrescriptions();
      setState(() {
        _prescriptions = prescriptions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMyPrescriptions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: $_error', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMyPrescriptions,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _prescriptions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.medical_services, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No prescriptions found', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Text("You don't have any prescriptions yet", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = _prescriptions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.receipt, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Prescription #${prescription.id ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildDetailRow('Medicines', prescription.medicines ?? 'N/A'),
                                _buildDetailRow('Dosage', prescription.dosage ?? 'N/A'),
                                _buildDetailRow('Duration', prescription.duration ?? 'N/A'),
                                if (prescription.notes != null && prescription.notes!.isNotEmpty)
                                  _buildDetailRow('Notes', prescription.notes!),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
