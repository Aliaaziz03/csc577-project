import 'package:csc577_project/screens/RegisterStudent.dart';
import 'package:csc577_project/screens/RegisterTeacher.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
          title: Text('Register Page',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
          bottom: TabBar(
            tabs: [
              Tab(child:Text( "Student",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
              Tab(child:Text( "Teacher",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
             
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child : RegisterStudent()),
            Center(child: RegisterTeacher()),
            
          ],
        ),
      ),
    );
  }
}
