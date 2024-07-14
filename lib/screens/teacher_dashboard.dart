import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TeacherDashboard extends StatelessWidget {
  Future<List<String>> _getRegisteredStudents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('students').get();
    return snapshot.docs.map((doc) => doc['parent_name'] as String).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard',style: TextStyle(color: Colors.white),),
        backgroundColor:  Color(0xFF1C5153),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search student',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _getRegisteredStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No registered students found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




