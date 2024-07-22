
import 'package:csc577_project/screens/studentList_staff.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csc577_project/screens/report.dart';


class StaffDashboard extends StatefulWidget {
  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}


class _StaffDashboardState extends State<StaffDashboard> {
 
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
                      'Office Staff Dashboard',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Space between title and button
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 125,
                        margin: EdgeInsets.all(8), // Adding a gap between containers
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Report(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 147, 161, 178), // Button background color
                            foregroundColor: Colors.white, // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Set border radius to 30
                            ),
                          ),
                          child: Text('Confirmed registered student', textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 125,
                        margin: EdgeInsets.all(8), // Adding a gap between containers
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentListRegistered(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 147, 161, 178), // Button background color
                            foregroundColor: Colors.white, // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Set border radius to 30
                            ),
                          ),
                          child: Text('List Student Registered', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Space at the bottom
              ],
            ),
           
          ],
        ) 
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
