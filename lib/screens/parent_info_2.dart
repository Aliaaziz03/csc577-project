import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csc577_project/screens/parent_agreement.dart';

class ParentInfo2 extends StatefulWidget {
  @override
  _ParentInfo2State createState() => _ParentInfo2State();
}

class _ParentInfo2State extends State<ParentInfo2> {
  final TextEditingController nameController2 = TextEditingController();
  final TextEditingController idController2 = TextEditingController();
  final TextEditingController phoneController2 = TextEditingController();
  final TextEditingController relationController2 = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController occupationController2 = TextEditingController();
  final TextEditingController workPhoneController2 = TextEditingController();
  final TextEditingController workAddressController2 = TextEditingController();

  bool _isSubmitting = false;
  String? selectedIncome2;
  String? selectedDependents2;

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
    getEmail().then((email) {
      if (email != null) {
        emailController2.text = email;
        fetchParentInfo2(); // Fetch data immediately when email is retrieved
      } else {
        print("No email found in SharedPreferences");
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController2.dispose();
    idController2.dispose();
    phoneController2.dispose();
    relationController2.dispose();
    emailController2.dispose();
    occupationController2.dispose();
    workPhoneController2.dispose();
    workAddressController2.dispose();
    super.dispose();
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<void> fetchParentInfo2() async {
    if (emailController2.text.isEmpty) return;

    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('parents')
          .doc(emailController2.text)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        setState(() {
          nameController2.text = data['parent_name2'] ?? '';
          idController2.text = data['parent_id2'] ?? '';
          phoneController2.text = data['parent_phone2'] ?? '';
          relationController2.text = data['parent_relation2'] ?? '';
          occupationController2.text = data['parent_occupation2'] ?? '';
          selectedIncome2 = data['parent_income2'] ?? '';
          selectedDependents2 = data['parent_dependents2'] ?? '';
          workPhoneController2.text = data['parent_work_phone2'] ?? '';
          workAddressController2.text = data['parent_work_address2'] ?? '';
        });
        print("Data fetched successfully: $data");
      } else {
        print("No data found for email: ${emailController2.text}");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load data: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Error fetching data: $e");
    }
  }

  Future<bool> _saveParentInfo2(BuildContext context) async {
    if (nameController2.text.isEmpty ||
        idController2.text.isEmpty ||
        phoneController2.text.isEmpty ||
        relationController2.text.isEmpty ||
        emailController2.text.isEmpty ||
        occupationController2.text.isEmpty ||
        selectedIncome2 == null ||
        selectedDependents2 == null) {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    final parentInfo2 = {
      'parent_name2': nameController2.text,
      'parent_id2': idController2.text,
      'parent_phone2': phoneController2.text,
      'parent_relation2': relationController2.text,
      'parent_email2': emailController2.text,
      'parent_occupation2': occupationController2.text,
      'parent_income2': selectedIncome2,
      'parent_dependents2': selectedDependents2,
      'parent_work_phone2': workPhoneController2.text,
      'parent_work_address2': workAddressController2.text,
    };

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(emailController2.text)
          .set(parentInfo2, SetOptions(merge: true));

      Fluttertoast.showToast(
        msg: "Parent information saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      print("Data saved successfully: $parentInfo2");

      return true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save parent information: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Error saving data: $e");
      return false;
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mother/Guardian 2 Information',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1C5153), // Custom app bar color
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
            child: Text(
              'Parent / Guardian 2',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          CustomTextField(
            controller: nameController2,
            labelText: 'Full Name *',
          ),
          CustomTextField(
            controller: idController2,
            labelText: 'Identification Number *',
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            controller: phoneController2,
            labelText: 'Phone Number *',
            keyboardType: TextInputType.phone,
          ),
          CustomTextField(
            controller: relationController2,
            labelText: 'Relationship to Student *',
          ),
          CustomTextField(
            controller: emailController2,
            labelText: 'Email Address *',
          ),
          CustomTextField(
            controller: occupationController2,
            labelText: 'Occupation *',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: selectedIncome2,
              onChanged: (value) {
                setState(() {
                  selectedIncome2 = value;
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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: selectedDependents2,
              onChanged: (value) {
                setState(() {
                  selectedDependents2 = value;
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
            controller: workPhoneController2,
            labelText: 'Work Phone',
          ),
          CustomTextField(
            controller: workAddressController2,
            labelText: 'Work Address',
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                bool saved = await _saveParentInfo2(context);
                if (saved) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParentAgreement(
                        allInformationSaved: true,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD3E3D1), // Custom button color
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(150, 50),
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator()
                  : Text('Save'),
            ),
          ),
        ],
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



