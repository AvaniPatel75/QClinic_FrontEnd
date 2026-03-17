import 'package:flutter/material.dart';
import 'package:hospital_api_exam/model/AuthResponse.dart';
import 'package:hospital_api_exam/service/auth_service.dart';
import 'package:hospital_api_exam/view/admin_home_screen.dart';
import 'package:hospital_api_exam/view/doctor_home_screen.dart';
import 'package:hospital_api_exam/view/patient_home_screen.dart';
import 'package:hospital_api_exam/view/receptionist_home_screen.dart';

class SignInScreen extends StatelessWidget {
  static const String route = '/signin';

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameCtrl=new TextEditingController();
  final TextEditingController _passwordCtrl=new TextEditingController();

  final AuthService _auth=AuthService();

  void _submit()async{
    if(_formKey.currentState!.validate()) {
      try {
        AuthResponse res=await _auth.login(email: _userNameCtrl.text, password: _passwordCtrl.text);
        ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome ${res.user?.name ?? ''}')),
        );

        // Navigate based on user role
        Widget nextScreen;
        switch (res.user?.role) {
          case 'admin':
            nextScreen = AdminHomeScreen();
            break;
          case 'doctor':
            nextScreen = DoctorHomeScreen();
            break;
          case 'receptionist':
            nextScreen = ReceptionistHomeScreen();
            break;
          case 'patient':
            nextScreen = PatientHomeScreen();
            break;
          default:
            nextScreen = DoctorHomeScreen(); // fallback
        }

        Navigator.pushReplacement(_formKey.currentContext!, MaterialPageRoute(builder: (context) => nextScreen));
      } catch (e) {
        // Show error to user
        ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSn7RcaDkqzG1ilmRUs1Oo0Z93fSkjJovaFw&s",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Color(0xFFEEEEEE),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          controller: _userNameCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (email) {
                            // Save it
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Color(0xFFEEEEEE),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            controller: _passwordCtrl,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (password) {
                              // Save it
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign in"),
                        ),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
