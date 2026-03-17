import 'package:flutter/material.dart';
import 'package:hospital_api_exam/view/receptionist/queue_list_screen.dart';

class ReceptionistHomeScreen extends StatefulWidget {
  const ReceptionistHomeScreen({super.key});

  @override
  State<ReceptionistHomeScreen> createState() => _ReceptionistHomeScreenState();
}

class _ReceptionistHomeScreenState extends State<ReceptionistHomeScreen> {
  final Color _brandPrimary = const Color(0xFF2D9CDB);

  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QueueListScreen(date: picked)),
      );
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
        title: const Text('Receptionist Dashboard',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              brand: _brandPrimary,
              title: "Manage today's flow",
              subtitle: 'Check patients, update statuses',
              icon: Icons.queue_play_next,
            ),
            const SizedBox(height: 14),
            const Text('Queue Tools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _ActionCard(
              color: _brandPrimary,
              title: "Today's Queue",
              subtitle: 'Live list for today',
              icon: Icons.today,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QueueListScreen(date: DateTime.now())),
              ),
            ),
            const SizedBox(height: 10),
            _ActionCard(
              color: Colors.orange,
              title: 'Pick a Date',
              subtitle: 'View queue for a specific date',
              icon: Icons.calendar_month,
              onTap: _pickDate,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.color,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
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
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
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
