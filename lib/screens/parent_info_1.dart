import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';


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
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController dependentsController = TextEditingController();
  final TextEditingController workPhoneController = TextEditingController();
  final TextEditingController workAddressController = TextEditingController();


  bool isEditMode = false;
  bool isSaved = false;
  String? pdfFileName;
  String? pdfFileUrl;
  final String studentEmail = "student@example.com"; // Replace with actual email


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
          incomeController.text = data['parent_income'] ?? '';
          dependentsController.text = data['parent_dependents'] ?? '';
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


        if (file.bytes != null) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref('parent_id_cards/${file.name}')
              .putData(file.bytes!);


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
        } else {
          Fluttertoast.showToast(
            msg: "Failed to read file bytes",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
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
      print(e); // Print the error message for debugging
    }
  }


  Future<void> _deletePDF() async {
    if (pdfFileUrl != null) {
      try {
        await FirebaseStorage.instance.refFromURL(pdfFileUrl!).delete();
        setState(() {
          pdfFileName = null;
          pdfFileUrl = null;
        });
        Fluttertoast.showToast(
          msg: "File deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Failed to delete file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }


  Future<void> _deleteAll() async {
    if (pdfFileUrl != null) {
      try {
        await FirebaseStorage.instance.refFromURL(pdfFileUrl!).delete();
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Failed to delete file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }


    try {
      await FirebaseFirestore.instance
         .collection('students')
         .doc(studentEmail)
         .set({}, SetOptions(merge: true));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to clear data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }


    setState(() {
      nameController.clear();
      idController.clear();
      phoneController.clear();
      relationController.clear();
      emailController.clear();
      occupationController.clear();
      incomeController.clear();
      dependentsController.clear();
      workPhoneController.clear();
      workAddressController.clear();
      pdfFileName = null;
      pdfFileUrl = null;
    });


    Fluttertoast.showToast(
      msg: "Information successfully deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  Future<bool> _saveParentInfo() async {
    if (nameController.text.isEmpty ||
        idController.text.isEmpty ||
        phoneController.text.isEmpty ||
        relationController.text.isEmpty ||
        emailController.text.isEmpty ||
        occupationController.text.isEmpty ||
        incomeController.text.isEmpty ||
        dependentsController.text.isEmpty ||
        pdfFileName == null) {
      Fluttertoast.showToast(
        msg: "Please fill in all required fields and upload the ID card",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
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
        'parent_income': incomeController.text,
        'parent_dependents': dependentsController.text,
        'parent_work_phone': workPhoneController.text,
        'parent_work_address': workAddressController.text,
        'parent_id_card_name': pdfFileName,
        'parent_id_card_url': pdfFileUrl,
      }, SetOptions(merge: true));


      Fluttertoast.showToast(
        msg: "Data saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        isSaved = true;
        isEditMode = false; // Exit edit mode after saving
      });
      return true; // Return true if all data is saved successfully
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save data: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false; // Return false if saving fails
    }
  }


  Future<void> _viewPDF() async {
    if (pdfFileUrl != null) {
      try {
        if (await canLaunch(pdfFileUrl!)) {
          await launch(pdfFileUrl!);
        } else {
          Fluttertoast.showToast(
            msg: "Could not launch PDF",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.5),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error opening PDF: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black.withOpacity(0.5),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "No PDF available",
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
        title: Text('Parent/Guardian 1 Information'),
        backgroundColor: Color(0xFF1C5153), // Custom app bar color
        foregroundColor: Colors.white, // Set the text and icon color to white
        actions: [
          if (!isEditMode)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditMode = true;
                  isSaved = false;
                });
              },
            ),
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                bool saved = await _saveParentInfo();
                if (saved) {
                  setState(() {
                    isEditMode = false;
                    isSaved = true;
                  });
                }
              },
            ),
        ],
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
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: idController,
                labelText: 'Identification Number *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: phoneController,
                labelText: 'Phone Number *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: relationController,
                labelText: 'Relationship *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: emailController,
                labelText: 'Email Address *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: occupationController,
                labelText: 'Occupation *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: incomeController,
                labelText: 'Monthly Income *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: dependentsController,
                labelText: 'Number of Dependents *',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: workPhoneController,
                labelText: 'Work Phone',
                readOnly:!isEditMode,
              ),
              CustomTextField(
                controller: workAddressController,
                labelText: 'Work Address',
                readOnly:!isEditMode,
              ),
              SizedBox(height: 16),
              FileUploadField(
                controller: TextEditingController(
                    text: pdfFileName ?? 'No file selected'),
                labelText: 'Upload ID Card *',
                fileName: pdfFileName,
                onUpload: isEditMode ? _pickPDF : null,
                onDelete: isEditMode ? _deletePDF : null,
                onView: _viewPDF,
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity, // Set button width to match parent
                  child: ElevatedButton(
                    onPressed: isEditMode
                       ? null
                        : () {
                            Navigator.pushNamed(context, '/parent_info_2');
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEditMode
                         ? Colors.grey
                          : Color(0xFF1C5153), // Custom button color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(double.infinity, 50), // Match parent width
                    ),
                    child: Text('Next'),
                  ),
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
  final bool readOnly;
  final VoidCallback? onTap;


  CustomTextField({
    required this.controller,
    required this.labelText,
    this.readOnly = false,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: readOnly
       ? GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          )
          : TextField(
            controller: controller,
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


class FileUploadField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? fileName;
  final VoidCallback? onUpload;
  final VoidCallback? onDelete;
  final VoidCallback? onView;


  FileUploadField({
    required this.controller,
    required this.labelText,
    this.fileName,
    required this.onUpload,
    required this.onDelete,
    this.onView,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onView, // Handle tap to view document
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: labelText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: onUpload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD3E3D1), // Custom button color
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text('Choose File'),
          ),
          if (fileName != null)...[
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}
