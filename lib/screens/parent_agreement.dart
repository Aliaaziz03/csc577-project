import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ParentAgreement extends StatefulWidget {
  final bool allInformationSaved;

  ParentAgreement({required this.allInformationSaved});

  @override
  _ParentAgreementState createState() => _ParentAgreementState();
}

class _ParentAgreementState extends State<ParentAgreement> {
  bool isCheckboxChecked = false;
  bool isSubmitting = false;

  void _submitAgreement() {
    if (!isCheckboxChecked) {
      Fluttertoast.showToast(
        msg: "Please confirm the agreement",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (!widget.allInformationSaved) {
      Fluttertoast.showToast(
        msg: "Please save all required information first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate submission process (replace with your actual submission logic)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isSubmitting = false;
      });

      Fluttertoast.showToast(
        msg: "Successfully submitted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to dashboard or student list
      Navigator.pushReplacementNamed(context, '/student_dashboard');
    }).catchError((error) {
      setState(() {
        isSubmitting = false;
      });

      Fluttertoast.showToast(
        msg: "Failed to submit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Agreement',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF1C5153), // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Information Confirmation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'I hereby declare that the information provided is true and correct. I also understand that any willful dishonesty may render for refusal of this application or immediate termination of studies.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'If this application is successful, I authorize Akademi Darul Ilmi to keep this information in my personal file.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'I authorize Akademi Darul Ilmi to disclose in a confidential manner any information supplied in this application.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'I also understand I am entitled to update and correct the above information and agree that this information could be held for 3 months from the date of application and used for future entrance by Akademi Darul Ilmi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isCheckboxChecked,
                  onChanged: (value) {
                    setState(() {
                      isCheckboxChecked = value ?? false;
                    });
                  },
                ),
                Text('I confirm'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitAgreement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitting ? Colors.grey : Color(0xFFD3E3D1), // Custom button color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(150, 50),
                ),
                child: isSubmitting
                    ? CircularProgressIndicator()
                    : Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
