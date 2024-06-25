import 'package:flutter/material.dart';

class ParentInfo2 extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController dependentsController = TextEditingController();
  final TextEditingController workPhoneController = TextEditingController();
  final TextEditingController workAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent/Guardian 2 Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'Identification Number'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: relationController,
                decoration: InputDecoration(labelText: 'Relationship to Student'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              TextField(
                controller: occupationController,
                decoration: InputDecoration(labelText: 'Occupation'),
              ),
              TextField(
                controller: incomeController,
                decoration: InputDecoration(labelText: 'Monthly Income'),
              ),
              TextField(
                controller: dependentsController,
                decoration: InputDecoration(labelText: 'Number of Dependents'),
              ),
              TextField(
                controller: workPhoneController,
                decoration: InputDecoration(labelText: 'Work Phone'),
              ),
              TextField(
                controller: workAddressController,
                decoration: InputDecoration(labelText: 'Work Address'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save logic here
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
