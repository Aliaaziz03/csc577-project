import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/student_information.dart';
import 'screens/parent_info_1.dart';
import 'screens/parent_info_2.dart';
import 'screens/parent_agreement.dart';

void main() {
  runApp(SchoolApp());
}

class SchoolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/student_dashboard': (context) => StudentDashboard(),
        '/teacher_dashboard': (context) => TeacherDashboard(),
        '/student_info': (context) => StudentInformation(),
        '/parent_info_1': (context) => ParentInfo1(),
        '/parent_info_2': (context) => ParentInfo2(),
        '/parent_agreement': (context) => ParentAgreement(),
      },
    );
  }
}
