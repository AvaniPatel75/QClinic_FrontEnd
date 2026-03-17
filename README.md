# QClinic FrontEnd 🏥
### **Enterprise Clinic Queue Management System (CMS)**

QClinic is a sophisticated, multi-role Flutter application designed to digitize healthcare workflows. It transforms traditional clinic operations into a streamlined digital experience, handling everything from patient registration and real-time queueing to electronic medical records (EMR).

---

## 🏛 Architecture & Technical Overview

The project follows a **Service-Oriented Architecture (SOA)**, separating concerns between UI components, data models, and business logic. This ensures scalability and maintainability for complex healthcare environments.

- **Frontend:** Flutter (Dart)
- **Backend Integration:** RESTful API with JSON data exchange.
- **Security:** JWT (JSON Web Token) for stateless authentication and Role-Based Access Control (RBAC).
- **Base URL:** `https://cmsback.sampaarsh.cloud`

---

## 👥 Multi-Role Ecosystem & Workflows

The application adapts its interface and capabilities based on the authenticated user's role:

### **1. Administrator (System Oversight)**
*   **Clinic Governance:** Fetches high-level metadata via `UserService().getClinicInfo()`.
*   **User Lifecycle:** Controls the creation and auditing of staff accounts (Doctors/Receptionists).
*   **Data Oversight:** Monitors total appointment and user counts.

### **2. Doctor (Clinical Excellence)**
*   **Real-time Consultation Queue:** Accesses synchronized patient lists via `DoctorService().getTodaysQueue()`.
*   **EMR Integration:** Digitally signs and issues:
    *   **Prescriptions:** `PrescriptionService().addPrescription()` including dosage and duration.
    *   **Clinical Reports:** `ReportService().addReport()` for diagnosis and test recommendations.

### **3. Receptionist (Operational Flow)**
*   **Dynamic Queue Management:** Manages the physical flow of patients using `QueueService()`.
*   **State Transitions:** Updates patient status through a lifecycle: 
    `Waiting` ➡️ `In-Progress` ➡️ `Done` or `Skipped`.

### **4. Patient (Personal Health Portal)**
*   **Self-Service Booking:** Schedules visits via `AppointmentService().bookAppointment()`.
*   **Historical Archive:** Instant access to a digital vault of personal prescriptions and diagnostic reports.

---

## 📦 Data Modeling & Services

The application utilizes a rigorous modeling system to ensure type-safety across the platform:


| Data Model | Description | Primary Fields |
| :--- | :--- | :--- |
| **AuthResponse** | Session Security | `token`, `role`, `clinicId` |
| **AppointmentModel** | Core Logic Unit | `timeSlot`, `status`, `prescription`, `report` |
| **QueueEntry** | Flow Logic | `queueId`, `status` |
| **ReportModel** | Diagnostic Data | `diagnosis`, `testRecommended`, `remarks` |

### **Service Layer Logic**
- **`JwtTokenService`**: A utility layer that decodes the bearer token to determine UI permissions (e.g., `isAdmin()`, `isDoctor()`).
- **`HealthService`**: A heartbeat mechanism (`/health`) to monitor backend availability.

---

## 🔌 API Implementation Reference

### **Sample: Patient Appointment Lifecycle**
1.  **Auth:** `authService.login(email, pass)` -> Stores JWT.
2.  **Booking:** `appointmentService.bookAppointment(date, slot)`.
3.  **Completion:** Once the Doctor adds a report, the `AppointmentModel` updates to include the `ReportModel` object automatically.

---

## 🚀 Deployment & Installation

### **Prerequisites**
- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- Git

### **Setup Instructions**
1. **Clone the repository:**
   ```bash
   git clone https://github.com
