import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
      
      return Scaffold(
        
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/bg.jpg', // Update the path to your image
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 5,
               child :
               IconButton(
                   icon: Icon(Icons.logout,color: Colors.white,),
                   onPressed: () => _logout(context),
          ),
            ),
            Column(
              children: [
                SizedBox(height: 30), // Space for status bar
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add some padding if needed
                    child: Text(
                      'Student Dashboard',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Corrected error: replaced semicolon with comma
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 125,
                            height: 125,
                            margin: EdgeInsets.all(8), // Adding a gap between containers
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/student_info');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 147, 161, 178), // Button background color
                                foregroundColor: Colors.white, // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // Set border radius to 30
                                ),
                              ),
                              child: Text('Student Information', textAlign: TextAlign.center),
                            ),
                          ),
                          Container(
                            width: 125,
                            height: 125,
                            margin: EdgeInsets.all(8), // Adding a gap between containers
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/parent_info_1');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 147, 161, 178), // Button background color
                                foregroundColor: Colors.white, // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // Set border radius to 30
                                ),
                              ),
                              child: Text('Parents Information', textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 125,
                            height: 125,
                            margin: EdgeInsets.all(8), // Adding a gap between containers
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/parent_agreement');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 147, 161, 178), // Button background color
                                foregroundColor: Colors.white, // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30), // Set border radius to 30
                                ),
                              ),
                              child: Text('Parents Agreement', textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Space at the bottom
              ],
            ),
            Positioned(
              top: 60, // Adjust this value to position the image below the containers
              right: 16, // Adjust this value to position the image near the right side
              child: Image.asset(
                'assets/star.png',
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
            ),
            Positioned(
              bottom: 16, // Adjust this value to position the image above the containers
              left: 16, // Adjust this value to position the image near the left side
              child: Image.asset(
                'assets/people.png',
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
              ),
            ),
          ],
        ),
      );
    
  }
}

 Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Display error message if sign out fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }


