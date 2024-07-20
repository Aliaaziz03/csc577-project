import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;


class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);


  @override
  _ReportState createState() => _ReportState();
}


class _ReportState extends State<Report> {
  final int _perPage = 10; // Number of items to fetch per page
  DocumentSnapshot? _lastDocument;
  List<DocumentSnapshot> _documents = [];


  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  Future<void> _fetchData() async {
    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .orderBy('full_name')
          .limit(_perPage)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .orderBy('full_name')
          .startAfterDocument(_lastDocument!)
          .limit(_perPage)
          .get();
    }


    setState(() {
      _documents.addAll(querySnapshot.docs);
      _lastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : _lastDocument;
    });
  }


  Future<void> _exportToCsv() async {
    List<List<dynamic>> rows = [];
    rows.add([
      'No.',
      'Full Name',
      'ID',
      'Address',
      'City',
      'State',
      'Student Phone',
      'Guardian Phone',
    ]);


    for (int i = 0; i < _documents.length; i++) {
      var document = _documents[i];
      var data = document.data() as Map<String, dynamic>;


      // Handling nullable fields
      String fullName = data['full_name'] ?? 'N/A';
      String id = data['id'] ?? 'N/A';
      String address = data['address'] ?? 'N/A';
      String city = data['city'] ?? 'N/A';
      String state = data['state'] ?? 'N/A';
      String studentPhone = data['student_phone'] ?? 'N/A';
      String guardianPhone = data['guardian_phone'] ?? 'N/A';


      rows.add([
        (i + 1).toString(),
        fullName,
        id,
        address,
        city,
        state,
        studentPhone,
        guardianPhone,
      ]);
    }


    String csv = const ListToCsvConverter().convert(rows);
    Uint8List csvBytes = utf8.encode(csv) as Uint8List;


    // Request permissions for writing to device storage
    bool permissionGranted = await _requestStoragePermission();
    if (permissionGranted) {
      // Save CSV file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/confirmed_registration_report.csv';
      await File(path).writeAsBytes(csvBytes);


      // Show success message
      Fluttertoast.showToast(
        msg: 'CSV file exported to $path',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black.withOpacity(0.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  Future<bool> _requestStoragePermission() async {
    try {
      if (!(await Permission.storage.isGranted)) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }


  Future<void> _printReport() async {
    final pdf = pw.Document();


    List<List<dynamic>> rows = [];
    rows.add([
      'No.',
      'Full Name',
      'ID',
      'Address',
      'City',
      'State',
      'Student Phone',
      'Guardian Phone',
    ]);


    for (int i = 0; i < _documents.length; i++) {
      var document = _documents[i];
      var data = document.data() as Map<String, dynamic>;


      // Handling nullable fields
      String fullName = data['full_name'] ?? 'N/A';
      String id = data['id'] ?? 'N/A';
      String address = data['address'] ?? 'N/A';
      String city = data['city'] ?? 'N/A';
      String state = data['state'] ?? 'N/A';
      String studentPhone = data['student_phone'] ?? 'N/A';
      String guardianPhone = data['guardian_phone'] ?? 'N/A';


      rows.add([
        (i + 1).toString(),
        fullName,
        id,
        address,
        city,
        state,
        studentPhone,
        guardianPhone,
      ]);
    }


    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);


    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Confirmed Registration Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Date: $formattedDate'),
              pw.Text('Time: $formattedTime'),
              pw.SizedBox(height: 20),
            ],
          ),
          pw.Table.fromTextArray(
            context: context,
            data: rows,
            cellStyle: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );


    Uint8List pdfBytes = await pdf.save();


    // Create a blob and use html package to download the PDF
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'confirmed_registration_report.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);


    Fluttertoast.showToast(
      msg: 'PDF generated and download link provided',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  void _navigateToDetailsScreen(DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsScreen(student: document),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmed Registration Report', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1C5153),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _printReport,
            icon: Icon(Icons.print, color: Colors.white),
          ),
          IconButton(
            onPressed: _exportToCsv,
            icon: Icon(Icons.file_download, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _fetchData();
              },
              child: Text('Load More'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Color(0xFFD3E3D1),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('City')),
                      DataColumn(label: Text('State')),
                      DataColumn(label: Text('Student Phone')),
                      DataColumn(label: Text('Guardian Phone')),
                    ],
                    rows: List<DataRow>.generate(
                      _documents.length,
                      (index) {
                        var data = _documents[index].data() as Map<String, dynamic>;


                        String fullName = data['full_name'] ?? 'N/A';
                        String id = data['id'] ?? 'N/A';
                        String address = data['address'] ?? 'N/A';
                        String city = data['city'] ?? 'N/A';
                        String state = data['state'] ?? 'N/A';
                        String studentPhone = data['student_phone'] ?? 'N/A';
                        String guardianPhone = data['guardian_phone'] ?? 'N/A';


                        return DataRow(
                          cells: [
                            DataCell(Text((index + 1).toString())),
                            DataCell(
                              GestureDetector(
                                onTap: () {
                                  _navigateToDetailsScreen(_documents[index]);
                                },
                                child: Text(fullName),
                              ),
                            ),
                            DataCell(Text(id)),
                            DataCell(Text(address)),
                            DataCell(Text(city)),
                            DataCell(Text(state)),
                            DataCell(Text(studentPhone)),
                            DataCell(Text(guardianPhone)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class StudentDetailsScreen extends StatelessWidget {
  final DocumentSnapshot student;


  const StudentDetailsScreen({Key? key, required this.student}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var data = student.data() as Map<String, dynamic>;


    String fullName = data['full_name'] ?? 'N/A';
    String id = data['id'] ?? 'N/A';
    String address = data['address'] ?? 'N/A';
    String city = data['city'] ?? 'N/A';
    String state = data['state'] ?? 'N/A';
    String studentPhone = data['student_phone'] ?? 'N/A';
    String guardianPhone = data['guardian_phone'] ?? 'N/A';


    return Scaffold(
     appBar: AppBar(
        title: Text('Student Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1C5153),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
     ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: $fullName'),
            Text('ID: $id'),
            Text('Address: $address'),
            Text('City: $city'),
            Text('State: $state'),
            Text('Student Phone: $studentPhone'),
            Text('Guardian Phone: $guardianPhone'),
          ],
        ),
      ),
    );
  }
}
