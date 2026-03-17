import 'package:flutter/material.dart';
import 'package:hospital_api_exam/service/prescription_service.dart';
import 'package:hospital_api_exam/service/report_service.dart';
import 'package:hospital_api_exam/model/appointment_model.dart';
import 'package:hospital_api_exam/service/appointment_service.dart';
import 'package:hospital_api_exam/service/queue_service.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback? onAppointmentUpdated;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
    this.onAppointmentUpdated,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final PrescriptionService _prescriptionService = PrescriptionService();
  final ReportService _reportService = ReportService();
  final AppointmentService _appointmentService = AppointmentService();
  final QueueService _queueService = QueueService();
  final Color _brandPrimary = const Color(0xFF2D9CDB);
  bool _isAddingPrescription = false;
  bool _isAddingReport = false;
  bool _hasPrescription = false;
  bool _hasReport = false;
  Prescription? _localPrescription;
  ReportModel? _localReport;

  final _medicinesController = TextEditingController();
  final _dosageController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  final _diagnosisController = TextEditingController();
  final _testRecommendedController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _medicinesController.dispose();
    _dosageController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _diagnosisController.dispose();
    _testRecommendedController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hasPrescription = widget.appointment.prescription != null;
    _hasReport = widget.appointment.report != null;
    _localPrescription = widget.appointment.prescription;
    _localReport = widget.appointment.report;
  }

  Future<void> _refreshAppointment() async {
    try {
      final updated = await _appointmentService
          .getAppointmentDetails((widget.appointment.id ?? 0).toInt());
      if (!mounted) return;
      setState(() {
        _hasPrescription = updated.prescription != null;
        _hasReport = updated.report != null;
        _localPrescription = updated.prescription;
        _localReport = updated.report;
      });
    } catch (_) {
    }
  }

  Future<void> _markQueueDoneIfPossible() async {
    final queueId = widget.appointment.queueEntry?.id?.toInt();
    if (queueId == null) return;
    try {
      await _queueService.updateQueueStatus(queueId: queueId, status: 'done');
    } catch (_) {
    }
  }

  Future<void> _ensureQueueInProgress() async {
    final queueId = widget.appointment.queueEntry?.id?.toInt();
    if (queueId == null) return;
    final current = widget.appointment.queueEntry?.status ?? '';
    if (current == 'in-progress' || current == 'done') return;
    try {
      await _queueService.updateQueueStatus(queueId: queueId, status: 'in-progress');
    } catch (_) {
    }
  }

  Future<void> _addPrescription() async {
    if (_medicinesController.text.isEmpty ||
        _dosageController.text.isEmpty ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields for prescription'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isAddingPrescription = true);

    try {
      await _ensureQueueInProgress();
      final success = await _prescriptionService.addPrescription(
        appointmentId: (widget.appointment.id ?? 0).toInt(),
        medicines: _medicinesController.text,
        dosage: _dosageController.text,
        duration: _durationController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (success && mounted) {
        await _refreshAppointment();
        await _markQueueDoneIfPossible();
        setState(() {
          _hasPrescription = true;
          _localPrescription = _localPrescription ??
              Prescription(
                medicines: _medicinesController.text,
                dosage: _dosageController.text,
                duration: _durationController.text,
                notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescription added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onAppointmentUpdated?.call();
        _clearPrescriptionForm();
      } else {
        if (mounted) {
          await _refreshAppointment();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add prescription. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingPrescription = false);
      }
    }
  }

  Future<void> _addReport() async {
    if (_diagnosisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in diagnosis for the report'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isAddingReport = true);

    try {
      await _ensureQueueInProgress();
      final success = await _reportService.addReport(
        appointmentId: (widget.appointment.id ?? 0).toInt(),
        diagnosis: _diagnosisController.text,
        testRecommended: _testRecommendedController.text.isNotEmpty ? _testRecommendedController.text : null,
        remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
      );

      if (success && mounted) {
        await _refreshAppointment();
        await _markQueueDoneIfPossible();
        setState(() {
          _hasReport = true;
          _localReport = _localReport ??
              ReportModel(
                diagnosis: _diagnosisController.text,
                testRecommended: _testRecommendedController.text.isNotEmpty
                    ? _testRecommendedController.text
                    : null,
                remarks: _remarksController.text.isNotEmpty ? _remarksController.text : null,
              );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onAppointmentUpdated?.call();
        _clearReportForm();
      } else {
        if (mounted) {
          await _refreshAppointment();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add report. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingReport = false);
      }
    }
  }

  void _clearPrescriptionForm() {
    _medicinesController.clear();
    _dosageController.clear();
    _durationController.clear();
    _notesController.clear();
  }

  void _clearReportForm() {
    _diagnosisController.clear();
    _testRecommendedController.clear();
    _remarksController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Appointment #${widget.appointment.id ?? 'N/A'}',
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -140,
            right: -100,
            child: _Blob(color: _brandPrimary.withOpacity(0.12), size: 280),
          ),
          Positioned(
            top: 200,
            left: -120,
            child: _Blob(color: _brandPrimary.withOpacity(0.08), size: 240),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroHeader(
                  primary: _brandPrimary,
                  token: widget.appointment.queueEntry?.tokenNumber?.toString() ?? 'N/A',
                  status: widget.appointment.status ?? 'unknown',
                  timeSlot: widget.appointment.timeSlot ?? 'N/A',
                ),

                const SizedBox(height: 16),

                const _SectionTitle(icon: Icons.info_outline, title: 'Appointment Details'),
                _SectionCard(
                  child: Column(
                    children: [
                      _buildDetailRow('Appointment ID', '${widget.appointment.id ?? 'N/A'}'),
                      _buildDetailRow('Date', _formatDate(widget.appointment.appointmentDate)),
                      _buildDetailRow('Time Slot', widget.appointment.timeSlot ?? 'N/A'),
                      _buildDetailRow('Patient ID', '${widget.appointment.patientId ?? 'N/A'}'),
                      _buildDetailRow('Clinic ID', '${widget.appointment.clinicId ?? 'N/A'}'),
                      _buildDetailRow('Created', _formatDate(widget.appointment.createdAt)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

            if (_hasPrescription && _currentPrescription != null) ...[
              const _SectionTitle(icon: Icons.medical_services_outlined, title: 'Prescription'),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Medicines', _currentPrescription!.medicines ?? 'N/A'),
                    _buildDetailRow('Dosage', _currentPrescription!.dosage ?? 'N/A'),
                    _buildDetailRow('Duration', _currentPrescription!.duration ?? 'N/A'),
                    if (_currentPrescription!.notes != null)
                      _buildDetailRow('Notes', _currentPrescription!.notes!),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (_hasReport && _currentReport != null) ...[
              const _SectionTitle(icon: Icons.insert_drive_file_outlined, title: 'Medical Report'),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Diagnosis', _currentReport!.diagnosis ?? 'N/A'),
                    if (_currentReport!.testRecommended != null)
                      _buildDetailRow('Tests Recommended', _currentReport!.testRecommended!),
                    if (_currentReport!.remarks != null)
                      _buildDetailRow('Remarks', _currentReport!.remarks!),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (!_hasPrescription) ...[
              const _SectionTitle(icon: Icons.add_circle_outline, title: 'Add Prescription'),
              _SectionCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _medicinesController,
                      decoration: const InputDecoration(
                        labelText: 'Medicines *',
                        hintText: 'Enter medicine names',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage *',
                        hintText: 'e.g., 1 tablet twice daily',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration *',
                        hintText: 'e.g., 7 days',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Additional instructions',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isAddingPrescription ? null : _addPrescription,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isAddingPrescription
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Add Prescription'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (!_hasReport) ...[
              const _SectionTitle(icon: Icons.playlist_add_check, title: 'Add Medical Report'),
              _SectionCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _diagnosisController,
                      decoration: const InputDecoration(
                        labelText: 'Diagnosis *',
                        hintText: 'Enter diagnosis',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _testRecommendedController,
                      decoration: const InputDecoration(
                        labelText: 'Tests Recommended (Optional)',
                        hintText: 'e.g., Blood Test, X-Ray',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _remarksController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks (Optional)',
                        hintText: 'Additional notes',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isAddingReport ? null : _addReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isAddingReport
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Add Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Prescription? get _currentPrescription =>
      _localPrescription ?? widget.appointment.prescription;
  ReportModel? get _currentReport =>
      _localReport ?? widget.appointment.report;
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  const _SectionCard({required this.child, this.gradient});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: gradient == null
            ? Border.all(color: const Color(0xFFE6ECF5))
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Color primary;
  final String token;
  final String status;
  final String timeSlot;
  const _HeroHeader({
    required this.primary,
    required this.token,
    required this.status,
    required this.timeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      gradient: LinearGradient(
        colors: [primary, primary.withOpacity(0.85)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white.withOpacity(0.18),
                child: Text(
                  token,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Queue Token', style: TextStyle(color: Colors.white70)),
                  Text(
                    '#$token',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const Spacer(),
              _StatusChip(
                text: status.toUpperCase(),
                color: primary,
                background: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoPill(icon: Icons.schedule, label: 'Time Slot', value: timeSlot),
              const SizedBox(width: 10),
              _infoPill(icon: Icons.verified_outlined, label: 'Status', value: status.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoPill({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                  Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;

  const _StatusChip({
    required this.text,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
