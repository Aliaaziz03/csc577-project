
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}


class _TeacherDashboardState extends State<TeacherDashboard> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> students = [];
  List<DocumentSnapshot> filteredStudents = [];


  @override
  void initState() {
    super.initState();
    fetchStudents();
  }


  void fetchStudents() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('students').get();
      setState(() {
        students = querySnapshot.docs;
        filteredStudents = students;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }


  void filterSearchResults(String query) {
    List<DocumentSnapshot> searchList = [];
    searchList.addAll(students);
    if (query.isNotEmpty) {
      List<DocumentSnapshot> searchResults = [];
      searchList.forEach((item) {
        try {
          if (item.get('full_name').toString().toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(item);
          }
        } catch (e) {
          print('Error filtering search results: $e');
        }
      });
      setState(() {
        filteredStudents = searchResults;
      });
      return;
    } else {
      setState(() {
        filteredStudents = students;
      });
    }
  }


  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, '/login');
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                      'Teacher Dashboard',
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
                                builder: (context) => RegisteredStudentsScreen(),
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
                          child: Text('View Registered Students', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30), // Space at the bottom
              ],
            ),
          
          ],
        ),
      ),
    );
  }
}


class RegisteredStudentsScreen extends StatefulWidget {
  @override
  _RegisteredStudentsScreenState createState() => _RegisteredStudentsScreenState();
}


class _RegisteredStudentsScreenState extends State<RegisteredStudentsScreen> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> students = [];
  List<DocumentSnapshot> filteredStudents = [];


  @override
  void initState() {
    super.initState();
    fetchStudents();
  }


  void fetchStudents() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('students').get();
      setState(() {
        students = querySnapshot.docs;
        filteredStudents = students;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }


  void filterSearchResults(String query) {
    List<DocumentSnapshot> searchList = [];
    searchList.addAll(students);
    if (query.isNotEmpty) {
      List<DocumentSnapshot> searchResults = [];
      searchList.forEach((item) {
        try {
          if (item.get('full_name').toString().toLowerCase().contains(query.toLowerCase())) {
            searchResults.add(item);
          }
        } catch (e) {
          print('Error filtering search results: $e');
        }
      });
      setState(() {
        filteredStudents = searchResults;
      });
      return;
    } else {
      setState(() {
        filteredStudents = students;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registered Students',
          style: TextStyle(color: Colors.white), // Set AppBar text color to white
        ),
        backgroundColor: const Color.fromARGB(255, 16, 42, 43),
        iconTheme: IconThemeData(
          color: Colors.white, // Set back button color to white
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Update the path to your image
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'List of Registered Students',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search student',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                filteredStudents[index].data().toString().contains('full_name')
                                    ? filteredStudents[index]['full_name']
                                    : 'Name not available',
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentInformationScreen(
                                      student: filteredStudents[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Divider(color: Colors.grey),
                          ],
                        );
                      },
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







