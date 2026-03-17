import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/doctor_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/view/doctor/appointment_detail_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final DoctorService _doctorService = DoctorService();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;
  String? _error;
  final Color _brandPrimary = const Color(0xFF2D9CDB);

  @override
  void initState() {
    super.initState();
    _loadAllAppointments();
  }

  Future<void> _loadAllAppointments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final appointments = await _doctorService.getAllAppointments();
      setState(() {
        _appointments = appointments;
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
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Doctor Dashboard",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllAppointments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(message: _error!, onRetry: _loadAllAppointments)
              : _appointments.isEmpty
                  ? const _EmptyView(
                      icon: Icons.medical_services,
                      title: 'No appointments for today',
                      subtitle: 'No patients scheduled for consultation',
                    )
                  : Column(
                      children: [
                        _SummaryBar(
                          brand: _brandPrimary,
                          total: _appointments.length,
                          queued: _appointments.where((a) => a.status == 'queued').length,
                          completed: _appointments.where((a) => a.status == 'completed').length,
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            itemCount: _appointments.length,
                            itemBuilder: (context, index) {
                              final a = _appointments[index];
                              return _AppointmentCard(
                                brand: _brandPrimary,
                                appointment: a,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentDetailScreen(
                                        appointment: a,
                                        onAppointmentUpdated: _loadAllAppointments,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'queued':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _SummaryBar extends StatelessWidget {
  final Color brand;
  final int total;
  final int queued;
  final int completed;
  const _SummaryBar({
    required this.brand,
    required this.total,
    required this.queued,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brand.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item('Total', total, brand),
          _item('Queued', queued, Colors.orange),
          _item('Completed', completed, Colors.green),
        ],
      ),
    );
  }

  Widget _item(String label, int count, Color color) => Column(
        children: [
          Text('$count',
              style:
                  TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      );
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  final Color brand;
  const _AppointmentCard(
      {required this.appointment, required this.onTap, required this.brand});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'queued':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(appointment.status ?? '');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: brand,
          child: Text(
            '${appointment.queueEntry?.tokenNumber ?? 'N/A'}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('Token #${appointment.queueEntry?.tokenNumber ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appointment ID: ${appointment.id ?? 'N/A'}'),
              Text('Time Slot: ${appointment.timeSlot ?? 'N/A'}'),
              Text(
                'Status: ${appointment.status ?? 'Unknown'}',
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyView(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
