import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginTeacher extends StatefulWidget {
  @override
  _LoginTeacherState createState() => _LoginTeacherState();
}

class _LoginTeacherState extends State<LoginTeacher> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadID();
  }

  Future<void> loadID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedID = prefs.getString('savedID');
    if (savedID != null) {
      setState(() {
        idController.text = savedID;
      });
    }
  }

  Future<void> saveID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedID', id);
  }

  Future<void> _login(BuildContext context) async {
    try {
      // Get the teacher ID and password from the text controllers
      String teacherID = idController.text.trim();
      String enteredPassword = passwordController.text;

      // Check if the document with the given teacher ID exists in Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherID)
          .get();

      if (!snapshot.exists) {
        // Show error message if the teacher ID is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found for that Teacher ID.')),
        );
        return;
      }

      // Fetch the stored password from the Firestore document
      String storedPassword = snapshot['password'];

      // Check if the entered password matches the stored password
      if (enteredPassword != storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wrong password provided.')),
        );
        return;
      }

      // Save the Teacher ID
      await saveID(teacherID);

      // Display success message and navigate to the dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("! أهلاً وسهلاً")),
      );
      Navigator.pushNamed(context, '/teacher_dashboard');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 81, 83),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(
                  'Login Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Teacher',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 550,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Teacher ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: 'Teacher ID',
                          prefixIcon: Icon(Icons.account_circle),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

