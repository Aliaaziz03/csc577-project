import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/student_dashboard.dart';
import 'screens/teacher_dashboard.dart';
import 'screens/student_information.dart';
import 'screens/parent_info_1.dart';
import 'screens/parent_info_2.dart';
import 'screens/parent_agreement.dart';
import 'screens/forgot_password_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDsDX3kZUUbaJo4lO8hMaXs78HEIMHXQVU",
      appId: "com.example.csc577_project",
      messagingSenderId: "556613213756", 
      projectId: "akademi-c1fdf",
      storageBucket: "akademi-c1fdf.appspot.com" )
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: ThemeData(
        primarySwatch: Colors.green,
         primaryColor: Color(0xFF1C5153), // Use your primaryColor
        primaryColorDark: Color(0xFF303F9F), // Use your primaryDarkColor
        hintColor: Color(0xFFFF4081), // Use your accentColor
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
        '/parent_agreement': (context) => ParentAgreement(allInformationSaved: true),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}
