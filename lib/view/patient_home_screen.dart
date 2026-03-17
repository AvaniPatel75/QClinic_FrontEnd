import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/appointment_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/view/patient/appointment_list_screen.dart';
import 'package:hospital_api_exam/view/patient/book_appointment_screen.dart';
import 'package:hospital_api_exam/view/patient/appointment_detail_screen.dart';
import 'package:hospital_api_exam/view/patient/prescription_list_screen.dart';
import 'package:hospital_api_exam/view/patient/report_list_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  final Color _brandPrimary = const Color(0xFF2D9CDB);

  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final appointments = await _appointmentService.getMyAppointments();
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
        title: const Text('Patient Dashboard',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAppointments)],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              brand: _brandPrimary,
              title: 'Welcome back!',
              subtitle: 'Manage your visits and records',
              icon: Icons.favorite_outline,
            ),
            const SizedBox(height: 12),
            const _SectionTitle(title: 'Quick Actions'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    color: Colors.green.shade400,
                    title: 'Book Appointment',
                    icon: Icons.calendar_today,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookAppointmentScreen()),
                      ).then((_) => _loadAppointments());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    color: Colors.orange.shade400,
                    title: 'My Visits',
                    icon: Icons.folder_shared,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppointmentListScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _SectionTitle(title: 'My Appointments'),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? _ErrorView(message: _error!, onRetry: _loadAppointments)
                      : _appointments.isEmpty
                          ? const _EmptyView(
                              icon: Icons.calendar_today,
                              title: 'No appointments found',
                              subtitle: 'Book your first appointment!',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 4),
                              itemCount: _appointments.length > 3 ? 3 : _appointments.length,
                              itemBuilder: (context, index) {
                                final a = _appointments[index];
                                return _AppointmentTile(
                                  brand: _brandPrimary,
                                  appointment: a,
                                  dateText: _formatDate(a.appointmentDate),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppointmentDetailScreen(
                                          appointmentId: (a.id ?? 0).toInt(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
            ),
            if (!_isLoading && _appointments.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _SectionTitle(title: 'Medical Records'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      color: _brandPrimary,
                      title: 'Prescriptions',
                      icon: Icons.medical_services,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrescriptionListScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      color: Colors.teal,
                      title: 'Reports',
                      icon: Icons.receipt_long,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReportListScreen()),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
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

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionCard({required this.color, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;
  final Color brand;
  final String dateText;
  const _AppointmentTile(
      {required this.appointment,
      required this.onTap,
      required this.brand,
      required this.dateText});

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
          child: const Icon(Icons.calendar_today, color: Colors.white, size: 18),
        ),
        title: Text('Appointment #${appointment.id ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Date: $dateText'),
              Text('Time: ${appointment.timeSlot ?? 'N/A'}'),
              Text('Status: ${appointment.status ?? 'Unknown'}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Color brand;
  final String title;
  final String subtitle;
  final IconData icon;
  const _HeroCard({required this.brand, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [brand, brand.withOpacity(0.85)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700));
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
  const _EmptyView({required this.icon, required this.title, required this.subtitle});

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
