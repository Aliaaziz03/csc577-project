import 'package:csc577_project/screens/Student_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




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
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('students').get();
    setState(() {
      students = querySnapshot.docs;
      filteredStudents = students;
    });
  }


  void filterSearchResults(String query) {
    List<DocumentSnapshot> searchList = [];
    searchList.addAll(students);
    if (query.isNotEmpty) {
      List<DocumentSnapshot> searchResults = [];
      searchList.forEach((item) {
        if (item['full_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          searchResults.add(item);
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
    Navigator.pushReplacementNamed(context, '/student_dashboard');
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Teacher Dashboard',
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
                                  filteredStudents[index]['full_name'],
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
      ),
    );
  }
}



