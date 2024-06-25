import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/student_info');
              },
              child: Text('Student Information'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/parent_info_1');
              },
              child: Text('Parents Information'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/parent_agreement');
              },
              child: Text('Parents Agreement'),
            ),
          ],
        ),
      ),
    );
  }
}
