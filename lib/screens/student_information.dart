import 'package:flutter/material.dart';

class StudentInformation extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController studentPhoneController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'Identification Number'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Home Address'),
              ),
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextField(
                controller: postcodeController,
                decoration: InputDecoration(labelText: 'Postcode'),
              ),
              TextField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextField(
                controller: studentPhoneController,
                decoration: InputDecoration(labelText: 'Phone Number (Student)'),
              ),
              TextField(
                controller: guardianPhoneController,
                decoration: InputDecoration(labelText: 'Phone Number (Parent/Guardian)'),
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
