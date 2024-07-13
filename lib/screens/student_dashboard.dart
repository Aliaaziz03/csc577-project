import 'package:flutter/material.dart';

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
          Column(
            children: [
              SizedBox(height: 30), // Space for status bar
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add some padding if needed
                  child: Text(
                    'Dashboard',
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
                              backgroundColor: Color.fromARGB(255, 157, 216, 159), // Button background color
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
                              backgroundColor: Color.fromARGB(255, 157, 216, 159),  // Button background color
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
                              backgroundColor: Color.fromARGB(255, 157, 216, 159),  // Button background color
                              foregroundColor: Colors.white, // Button text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Set border radius to 30
                              ),
                            ),
                            child: Text('Parents Agreement', textAlign: TextAlign.center),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: 125,
                          margin: EdgeInsets.all(8), // Adding a gap between containers
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/teacher_dashboard');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 157, 216, 159),  // Button background color
                              foregroundColor: Colors.white, // Button text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Set border radius to 30
                              ),
                            ),
                            child: Text('List of Registered Students', textAlign: TextAlign.center),
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
            top: 150, // Adjust this value to position the image below the containers
            right: 16, // Adjust this value to position the image near the right side
            child: Image.asset(
              'star.png', 
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
          ),
          Positioned(
            bottom: 80, // Adjust this value to position the image above the containers
            left: 16, // Adjust this value to position the image near the left side
            child: Image.asset(
              'people.png', 
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
          ),
        ],
      ),
    );
  }
}
