import 'package:csc577_project/screens/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentInformation extends StatefulWidget {
  @override
  _StudentInformationState createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController studentPhoneController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();

  String? state;
  String? birthPlace;
  String? maritalStatus;
  String? numberOfSiblings;
  String? orderOfSiblings;
  String? disabilities;

  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
    if (currentUser != null) {
      await loadStudentInformation();
    }
  }

  Future<void> loadStudentInformation() async {
    try {
      DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(currentUser!.email)
          .get();

      if (studentSnapshot.exists) {
        Map<String, dynamic> data = studentSnapshot.data() as Map<String, dynamic>;
        fullNameController.text = data['full_name'];
        idController.text = data['id'];
        addressController.text = data['address'];
        cityController.text = data['city'];
        postcodeController.text = data['postcode'];
        state = data['state'];
        studentPhoneController.text = data['student_phone'];
        guardianPhoneController.text = data['guardian_phone'];
        birthPlace = data['birth_place'];
        maritalStatus = data['marital_status'];
        numberOfSiblings = data['number_of_siblings'];
        orderOfSiblings = data['order_of_siblings'];
        disabilities = data['disabilities'];
        setState(() {});
      }

      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(currentUser!.email)
          .collection('parents')
          .doc(currentUser!.email)
          .get();

      if (parentSnapshot.exists) {
        Map<String, dynamic> data = parentSnapshot.data() as Map<String, dynamic>;
        // Load parent information into your controllers if needed
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
        backgroundColor: Color(0xFF1C5153),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: fullNameController,
                labelText: 'Full Name *',
              ),
              CustomTextField(
                controller: idController,
                labelText: 'Identification Number *',
              ),
              CustomTextField(
                controller: addressController,
                labelText: 'Home Address *',
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: cityController,
                      labelText: 'City *',
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: postcodeController,
                      labelText: 'Postcode *',
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: DropdownField(
                      labelText: 'State *',
                      items: [
                        'Please choose',
                        'Kuala Lumpur',
                        'Selangor',
                        'Melaka',
                        'Johor',
                        'Perlis',
                        'Kedah',
                        'Kelantan',
                        'Perak',
                        'Terengganu',
                        'Pahang',
                        'Pulau Pinang',
                        'Sarawak',
                        'Sabah',
                        'Wilayah Persekutuan',
                        'Negeri Sembilan'
                      ],
                      value: state,
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              CustomTextField(
                controller: studentPhoneController,
                labelText: 'Phone Number (Student) *',
              ),
              CustomTextField(
                controller: guardianPhoneController,
                labelText: 'Phone Number (Parent/Guardian) *',
              ),
              DropdownField(
                labelText: 'Birth Place',
                items: [
                  'Please choose',
                  'Kuala Lumpur',
                  'Selangor',
                  'Melaka',
                  'Johor',
                  'Perlis',
                  'Kedah',
                  'Kelantan',
                  'Perak',
                  'Terengganu',
                  'Pahang',
                  'Pulau Pinang',
                  'Sarawak',
                  'Sabah',
                  'Wilayah Persekutuan',
                  'Negeri Sembilan'
                ],
                value: birthPlace,
                onChanged: (value) {
                  setState(() {
                    birthPlace = value;
                  });
                },
              ),
              DropdownField(
                labelText: 'Marital Status *',
                items: ['Please choose', 'Single', 'Married'],
                value: maritalStatus,
                onChanged: (value) {
                  setState(() {
                    maritalStatus = value;
                  });
                },
              ),
              DropdownField(
                labelText: 'Number of Siblings *',
                items: [
                  'Please choose',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  'others'
                ],
                value: numberOfSiblings,
                onChanged: (value) {
                  setState(() {
                    numberOfSiblings = value;
                  });
                },
              ),
              DropdownField(
                labelText: 'Order of Siblings *',
                items: [
                  'Please choose',
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  'others'
                ],
                value: orderOfSiblings,
                onChanged: (value) {
                  setState(() {
                    orderOfSiblings = value;
                  });
                },
              ),
              DropdownField(
                labelText: 'Are you a person with disabilities? *',
                items: ['Please choose', 'Yes', 'No'],
                value: disabilities,
                onChanged: (value) {
                  setState(() {
                    disabilities = value;
                  });
                },
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (fullNameController.text.isEmpty ||
                        idController.text.isEmpty ||
                        addressController.text.isEmpty ||
                        cityController.text.isEmpty ||
                        postcodeController.text.isEmpty ||
                        state == null ||
                        state == 'Please choose' ||
                        studentPhoneController.text.isEmpty ||
                        guardianPhoneController.text.isEmpty ||
                        maritalStatus == null ||
                        maritalStatus == 'Please choose' ||
                        numberOfSiblings == null ||
                        numberOfSiblings == 'Please choose' ||
                        orderOfSiblings == null ||
                        orderOfSiblings == 'Please choose' ||
                        disabilities == null ||
                        disabilities == 'Please choose') {
                      Fluttertoast.showToast(
                        msg: "Please fill in all required fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      try {
                        if (currentUser != null) {
                          await FirebaseFirestore.instance
                              .collection('students')
                              .doc(currentUser!.email)
                              .set({
                            'full_name': fullNameController.text,
                            'id': idController.text,
                            'email': currentUser!.email,
                            'address': addressController.text,
                            'city': cityController.text,
                            'postcode': postcodeController.text,
                            'state': state,
                            'student_phone': studentPhoneController.text,
                            'guardian_phone': guardianPhoneController.text,
                            'birth_place': birthPlace,
                            'marital_status': maritalStatus,
                            'number_of_siblings': numberOfSiblings,
                            'order_of_siblings': orderOfSiblings,
                            'disabilities': disabilities,
                          });

                          await saveParentInfo(currentUser!.email!);

                          Fluttertoast.showToast(
                            msg: "Data saved successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  StudentDashboard()),
                          );
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "Failed to save data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1C5153),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveParentInfo(String email) async {
    // Add your code to save parent information here
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const DropdownField({
    Key? key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isDense: true,
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
