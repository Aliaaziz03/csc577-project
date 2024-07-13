import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ParentInfo1 extends StatefulWidget {
  @override
  _ParentInfo1State createState() => _ParentInfo1State();
}

class _ParentInfo1State extends State<ParentInfo1> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController workPhoneController = TextEditingController();
  final TextEditingController workAddressController = TextEditingController();

  bool isSaved = false;
  String? pdfFileName;
  String? pdfFileUrl;
  final String studentEmail =
      "student@example.com"; // Replace with the actual student email

  String? selectedIncome;// = 'Below RM1,000';
  String? selectedDependents;// = '0';

  final List<String> incomeOptions = [
    'Below RM1,000',
    'RM1,000 - RM3,000',
    'RM3,000 - RM5,000',
    'RM5,000 - RM7,000',
    'Above RM7,000',
  ];

  final List<String> dependentsOptions =
      List.generate(10, (index) => index.toString()) + ['Others'];

  @override
  void initState() {
    super.initState();
    _loadParentInfo();
  }

  Future<void> _loadParentInfo() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentEmail)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['parent_name'] ?? '';
          idController.text = data['parent_id'] ?? '';
          phoneController.text = data['parent_phone'] ?? '';
          relationController.text = data['parent_relation'] ?? '';
          emailController.text = data['parent_email'] ?? '';
          occupationController.text = data['parent_occupation'] ?? '';
          selectedIncome = data['parent_income'] ?? 'Below RM1,000'; //'';
          selectedDependents = data['parent_dependents'] ?? '0';
          workPhoneController.text = data['parent_work_phone'] ?? '';
          workAddressController.text = data['parent_work_address'] ?? '';
          pdfFileName = data['parent_id_card_name'] ?? '';
          pdfFileUrl = data['parent_id_card_url'] ?? '';
        });
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

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      if (result != null) {
        PlatformFile file = result.files.first;

        // Upload file to Firebase Storage
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('parent_id_cards/${file.name}')
            .putFile(File(file.path!));

        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          pdfFileName = file.name;
          pdfFileUrl = downloadUrl;
        });

        Fluttertoast.showToast(
          msg: "File uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to upload file",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<bool> _saveParentInfo() async {
    if (nameController.text.isEmpty ||
        idController.text.isEmpty ||
        phoneController.text.isEmpty ||
        relationController.text.isEmpty ||
        emailController.text.isEmpty ||
        occupationController.text.isEmpty ||
        selectedIncome == null ||
        selectedDependents == null) {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false; // Return false if required fields are not filled
    }

    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentEmail)
          .set({
        'parent_name': nameController.text,
        'parent_id': idController.text,
        'parent_phone': phoneController.text,
        'parent_relation': relationController.text,
        'parent_email': emailController.text,
        'parent_occupation': occupationController.text,
        'parent_income': selectedIncome,
        'parent_dependents': selectedDependents,
        'parent_work_phone': workPhoneController.text,
        'parent_work_address': workAddressController.text,
        'parent_id_card_name': pdfFileName,
        'parent_id_card_url': pdfFileUrl,
      }, SetOptions(merge: true));

      Fluttertoast.showToast(
        msg: "Data saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      setState(() {
        isSaved = true;
      });
      return true; // Return true if all data is saved successfully
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false; // Return false if saving fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent/Guardian 1 Information',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF1C5153), // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Father / Guardian 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: nameController,
                labelText: 'Full Name *',
              ),
              CustomTextField(
                controller: idController,
                labelText: 'Identification Number *',
              ),
              CustomTextField(
                controller: phoneController,
                labelText: 'Phone Number *',
              ),
              CustomTextField(
                controller: relationController,
                labelText: 'Relationship to Student *',
              ),
              CustomTextField(
                controller: emailController,
                labelText: 'Email Address *',
              ),
              CustomTextField(
                controller: occupationController,
                labelText: 'Occupation *',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedIncome,
                  onChanged: (value) {
                    setState(() {
                      selectedIncome = value;
                    });
                  },
                  items: incomeOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Monthly Income *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), //
                child: DropdownButtonFormField<String>(
                  value: selectedDependents,
                  onChanged: (value) {
                    setState(() {
                      selectedDependents = value;
                    });
                  },
                  items: dependentsOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Number of Dependents *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: workPhoneController,
                labelText: 'Work Phone',
              ),
              CustomTextField(
                controller: workAddressController,
                labelText: 'Work Address',
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _saveParentInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFD3E3D1), // Custom button color
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(150, 50),
                      ),
                      child: Text('Save'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: isSaved
                          ? () {
                              Navigator.pushNamed(context, '/parent_info_2');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaved
                            ? Color(0xFF1C5153)
                            : Colors.grey, // Custom button color
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(150, 50),
                      ),
                      child: Text('Next'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _pickPDF,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFD3E3D1), // Custom button color
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(150, 50),
                      ),
                      child: Text('Upload ID Card'),
                    ),
                    if (pdfFileName != null) Text('Uploaded: $pdfFileName'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
