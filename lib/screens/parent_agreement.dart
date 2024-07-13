import 'package:flutter/material.dart';

class ParentAgreement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Agreement'),
        backgroundColor: Color.fromARGB(255, 28, 81, 83),
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
                  value: true,
                  onChanged: (value) {},
                ),
                Text('I confirm'),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Submit logic here
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
