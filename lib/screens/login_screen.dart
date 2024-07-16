import 'package:csc577_project/screens/LoginStudent.dart';
import 'package:csc577_project/screens/LoginTeacher.dart';
import 'package:flutter/material.dart';
import 'package:csc577_project/screens/LoginStaff.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 28, 81, 83),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 28, 81, 83),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          title: Text('Login Page',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
          bottom: TabBar(
            tabs: [
              Tab(child:Text( "Student",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
              Tab(child:Text( "Teacher",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
              Tab(child:Text( "Office Staff",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child : LoginStudent()),
            Center(child: LoginTeacher()),
            Center(child: PinScreen()),
          ],
        ),
      ),
    );
  }
}

