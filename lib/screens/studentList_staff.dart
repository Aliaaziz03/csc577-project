import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_detail.dart';

class StudentListRegistered extends StatefulWidget {
  @override
  _StudentListRegisteredState createState() => _StudentListRegisteredState();
}

class _StudentListRegisteredState extends State<StudentListRegistered> {
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

  void deleteStudent(DocumentSnapshot student) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(student.id)
          .delete();
      setState(() {
        students.remove(student);
        filteredStudents.remove(student);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student: $e')),
      );
    }
  }

  void showDeleteConfirmationDialog(DocumentSnapshot student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this student from the registration list?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteStudent(student);
            },
            child: Text("YES"),
          ),
        ],
      ),
    );
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
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDeleteConfirmationDialog(filteredStudents[index]);
                                },
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


