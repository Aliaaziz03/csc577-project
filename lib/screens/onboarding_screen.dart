import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '،السلام عليكم',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                Text(
                  'أهلا وسهلا',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
                SizedBox(height: 20),

                ClipOval(
                  child: Image.asset('assets/logo.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                      foregroundColor: Color.fromARGB(255, 28, 81, 83), // Text color
                    ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                      foregroundColor: Color.fromARGB(255, 28, 81, 83), // Text color
                    ),
                  child: Text(
                    'Register',
                     style: TextStyle(fontWeight: FontWeight.bold),
                     ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
