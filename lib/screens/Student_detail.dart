import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentInformationScreen extends StatelessWidget {
  final DocumentSnapshot student;


  const StudentInformationScreen({required this.student});


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = student.data() as Map<String, dynamic>;


    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InformationRow(label: 'Full Name', value: data['full_name']),
              InformationRow(label: 'Identification Number', value: data['id']),
              InformationRow(label: 'Home Address', value: data['address']),
              InformationRow(label: 'City', value: data['city']),
              InformationRow(label: 'Postcode', value: data['postcode']),
              InformationRow(label: 'State', value: data['state']),
              InformationRow(label: 'Phone Number (Student)', value: data['student_phone']),
              InformationRow(label: 'Phone Number (Parent/Guardian)', value: data['guardian_phone']),
              InformationRow(label: 'Birth Place', value: data['birth_place']),
              InformationRow(label: 'Marital Status', value: data['marital_status']),
              InformationRow(label: 'Number of Siblings', value: data['number_of_siblings']),
              InformationRow(label: 'Order of Siblings', value: data['order_of_siblings']),
              InformationRow(label: 'Disabilities', value: data['disabilities']),
            ],
          ),
        ),
      ),
    );
  }
}


class InformationRow extends StatelessWidget {
  final String label;
  final dynamic value;


  const InformationRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value != null ? value.toString() : '',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
