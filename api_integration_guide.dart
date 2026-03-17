// CMS API INTEGRATION GUIDE
// ========================
// Updated for Clinic Queue Management System (CMS) API
// Base URL: https://cmsback.sampaarsh.cloud

/*
API ENDPOINTS AVAILABLE:
========================
1. healthEndpoint = 'health' (GET)
2. authEndpoint = 'auth/login' (POST)
3. appointmentsEndpoint = 'appointments' (POST for booking)
4. appointmentsMyEndpoint = 'appointments/my' (GET for patient)
5. queueEndpoint = 'queue' (GET/POST/PATCH for receptionist)
6. doctorQueueEndpoint = 'doctor/queue' (GET for doctor)
7. prescriptionsMyEndpoint = 'prescriptions/my' (GET for patient)
8. prescriptionsEndpoint = 'prescriptions' (POST for doctor)
9. reportsEndpoint = 'reports' (POST for doctor)
10. adminClinicEndpoint = 'admin/clinic' (GET for admin)
11. adminUsersEndpoint = 'admin/users' (GET/POST for admin)
*/

/*
MODELS UPDATED:
===============

1. AuthResponse (lib/model/AuthResponse.dart)
   - Fields: token, user (id, name, email, role, clinicId, clinicName, clinicCode)
   - Used for: Login responses

2. AppointmentModel (lib/model/appointment_model.dart)
   - Fields: id, appointmentDate, timeSlot, status, patientId, clinicId, createdAt, queueEntry, prescription, report
   - Sub-models: QueueEntry, Prescription, ReportModel

3. ClinicModel (lib/model/clinic_model.dart)
   - Fields: id, name, code, createdAt, userCount, appointmentCount, queueCount

4. DoctorModel (lib/model/doctor_model.dart)
   - Fields: id, name, email, role, phone, specialization, experience, createdAt

5. Prescription (lib/model/appointment_model.dart)
   - Fields: id, medicines, dosage, duration, notes

6. ReportModel (lib/model/report_model.dart)
   - Fields: id, diagnosis, testRecommended, remarks

7. User (lib/model/AuthResponse.dart)
   - Fields: id, name, email, role, clinicId, clinicName, clinicCode
*/

/*
SERVICES UPDATED:
=================

1. AuthService (lib/service/auth_service.dart)
   - login(email, password) -> AuthResponse

2. AppointmentService (lib/service/appointment_service.dart)
   - bookAppointment(appointmentDate, timeSlot) -> bool (Patient)
   - getMyAppointments() -> List<AppointmentModel> (Patient)
   - getAppointmentDetails(id) -> AppointmentModel (Patient)

3. QueueService (lib/service/queue_service.dart)
   - getDailyQueue(date) -> List<QueueEntry> (Receptionist)
   - updateQueueStatus(queueId, status) -> bool (Receptionist)

4. DoctorService (lib/service/doctor_service.dart)
   - getTodaysQueue() -> List<AppointmentModel> (Doctor)
   - Plus all CRUD operations for doctor management

5. PrescriptionService (lib/service/prescription_service.dart)
   - getMyPrescriptions() -> List<Prescription> (Patient)
   - addPrescription(appointmentId, medicines, dosage, duration, notes?) -> bool (Doctor)

6. ReportService (lib/service/report_service.dart)
   - getMyReports() -> List<ReportModel> (Patient)
   - addReport(appointmentId, diagnosis, testRecommended, remarks) -> bool (Doctor)

7. UserService (lib/service/user_service.dart)
   - getClinicInfo() -> ClinicModel (Admin)
   - getUsers() -> List<User> (Admin)
   - createUser(name, email, password, role) -> bool (Admin)

8. HealthService (lib/service/health_service.dart)
   - checkHealth() -> bool
   - getHealthStatus() -> Map<String, dynamic>?

9. JwtTokenService (lib/service/jwt_token_service.dart)
   - getTokenData() -> Map<String, dynamic>?
   - role() -> String?
   - isDoctor() -> bool?
   - isPatient() -> bool?
   - isReceptionist() -> bool?
   - isAdmin() -> bool?
*/

/*
ROLE-BASED WORKFLOWS:
=====================

ADMIN WORKFLOW:
1. Login with admin credentials
2. Get clinic info: UserService().getClinicInfo()
3. List all users: UserService().getUsers()
4. Create new users: UserService().createUser(name, email, password, role)

PATIENT WORKFLOW:
1. Login with patient credentials
2. Book appointment: AppointmentService().bookAppointment(date, timeSlot)
3. View my appointments: AppointmentService().getMyAppointments()
4. Get appointment details with prescription/report: AppointmentService().getAppointmentDetails(id)
5. View my prescriptions: PrescriptionService().getMyPrescriptions()
6. View my reports: ReportService().getMyReports()

RECEPTIONIST WORKFLOW:
1. Login with receptionist credentials
2. Get daily queue: QueueService().getDailyQueue('YYYY-MM-DD')
3. Update queue status: QueueService().updateQueueStatus(queueId, 'in_progress'/'done'/'skipped')

DOCTOR WORKFLOW:
1. Login with doctor credentials
2. Get today's queue: DoctorService().getTodaysQueue()
3. Add prescription: PrescriptionService().addPrescription(appointmentId, medicines, dosage, duration, notes)
4. Add report: ReportService().addReport(appointmentId, diagnosis, testRecommended, remarks)
*/

/*
USAGE EXAMPLES:
===============

// 1. Login
final authService = AuthService();
final authResponse = await authService.login(
  email: 'enrollment@darshan.ac.in',
  password: 'password123'
);
final token = authResponse.token;
final user = authResponse.user;

// 2. Patient: Book Appointment
final appointmentService = AppointmentService();
final success = await appointmentService.bookAppointment(
  appointmentDate: '2026-03-20T00:00:00.000Z',
  timeSlot: '10:00-10:15',
);

// 3. Patient: Get My Appointments
final appointments = await appointmentService.getMyAppointments();

// 4. Receptionist: Get Daily Queue
final queueService = QueueService();
final queue = await queueService.getDailyQueue('2026-03-17');

// 5. Receptionist: Update Queue Status
final updated = await queueService.updateQueueStatus(
  queueId: 60,
  status: 'in_progress',
);

// 6. Doctor: Get Today's Queue
final doctorService = DoctorService();
final todaysQueue = await doctorService.getTodaysQueue();

// 7. Doctor: Add Prescription
final prescriptionService = PrescriptionService();
final prescriptionAdded = await prescriptionService.addPrescription(
  appointmentId: 60,
  medicines: 'Paracetamol 500mg',
  dosage: '1 tablet twice daily',
  duration: '7 days',
  notes: 'Take with food',
);

// 8. Doctor: Add Report
final reportService = ReportService();
final reportAdded = await reportService.addReport(
  appointmentId: 60,
  diagnosis: 'Viral Fever',
  testRecommended: 'Blood Test',
  remarks: 'Rest for 3 days',
);

// 9. Admin: Get Clinic Info
final userService = UserService();
final clinic = await userService.getClinicInfo();

// 10. Admin: Create User
final userCreated = await userService.createUser(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'secure123',
  role: 'doctor',
);
*/

/*
ERROR HANDLING:
===============

All services throw exceptions on API errors. Use try-catch:

try {
  final appointments = await AppointmentService().getMyAppointments();
} catch (e) {
  print('Error: $e');
  // Show error to user
}

Queue status values: 'waiting', 'in_progress', 'done', 'skipped'
Appointment status: 'queued', 'confirmed', 'completed', 'cancelled'
User roles: 'admin', 'doctor', 'receptionist', 'patient'
*/
