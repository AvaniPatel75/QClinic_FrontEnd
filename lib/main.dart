import 'package:flutter/material.dart';
import 'package:hospital_api_exam/view/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: SignInScreen.route,
    routes: {
    SignInScreen.route : (context)=>SignInScreen(),
    },
    );
  }
}
//doctor side erorr in adding prescriton and repors
//receptionist side error in updating status of appointment
