import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // Import Syncfusion PDF package
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/home_controller.dart';
import 'package:lesson6/model/home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  late HomeController con;
  late HomeModel model;
  Uint8List? fileBytes;
  String? fileName;

  // Controllers for form fields
  final TextEditingController courseNumberController = TextEditingController();
  String? selectedDepartment;
  String? selectedCourseName;

  // Validation Error Message
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    con = HomeController(this);
    model = HomeModel(currentUser!);
  }

  // Department and course options
  final Map<String, List<String>> departmentCourses = {
    'Computer Science': [
      'Data Structures',
      'Software Engineering - 2',
      'AI and ML',
      'Mobile applications'
    ],
    'Arts': ['Art History', 'Painting', 'Sculpture', 'Photography'],
    'Music': [
      'Music Theory',
      'Composition',
      'Instrumental Performance',
      'Voice'
    ],
    'Psychology': [
      'Intro to Psychology',
      'Behavioral Science',
      'Neuroscience',
      'Cognitive Psychology'
    ]
  };

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileBytes = result.files.single.bytes;
        fileName = result.files.single.name;
        errorMessage = null; // Clear error if a file is selected
      });
    } else {
      setState(() {
        errorMessage = "Please select a PDF file.";
      });
    }
  }

  Future<void> _uploadSyllabus() async {
    if (selectedDepartment == null ||
        courseNumberController.text.isEmpty ||
        selectedCourseName == null ||
        fileBytes == null) {
      setState(() {
        errorMessage = "All fields are required, and a PDF must be selected.";
      });
      return;
    }

    // Check if a syllabus already exists in Firestore for the selected course
    final existingSyllabus = await FirebaseFirestore.instance
        .collection('syllabi')
        .where('department', isEqualTo: selectedDepartment)
        .where('courseName', isEqualTo: selectedCourseName)
        .where('courseNumber', isEqualTo: courseNumberController.text)
        .limit(1)
        .get();

    if (existingSyllabus.docs.isNotEmpty) {
      // Show confirmation dialog
      bool overwrite = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Overwrite Existing Syllabus"),
          content: const Text(
              "A syllabus already exists for this course. Do you want to overwrite it?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // Confirm overwrite
              child: const Text("Overwrite"),
            ),
          ],
        ),
      );

      if (!overwrite) {
        // User chose to cancel the upload
        return;
      }
    }

    // Define storage reference and metadata
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('syllabi/$selectedDepartment/$fileName');
    final metadata = SettableMetadata(
      contentType: 'application/pdf',
      customMetadata: {
        'department': selectedDepartment!,
        'courseNumber': courseNumberController.text,
        'courseName': selectedCourseName!,
        'uploadedBy': model.user.email!,
      },
    );

    try {
      // Upload the file to Firebase Storage with metadata
      await storageRef.putData(fileBytes!, metadata);
      String downloadURL = await storageRef.getDownloadURL();

      // Extract text from PDF using Syncfusion
      final document = PdfDocument(inputBytes: fileBytes!);
      final textExtractor = PdfTextExtractor(document);
      String parsedText = textExtractor.extractText();
      document.dispose();

      // If a document already exists, update it; otherwise, create a new document
      if (existingSyllabus.docs.isNotEmpty) {
        // Update the existing document
        await FirebaseFirestore.instance
            .collection('syllabi')
            .doc(existingSyllabus.docs.first.id)
            .update({
          'fileName': fileName,
          'fileURL': downloadURL,
          'parsedText': parsedText,
          'uploadedAt': Timestamp.now(),
          'uploadedBy': model.user.email,
        });
      } else {
        // Add a new document to Firestore
        await FirebaseFirestore.instance.collection('syllabi').add({
          'department': selectedDepartment,
          'courseNumber': courseNumberController.text,
          'courseName': selectedCourseName,
          'fileName': fileName,
          'fileURL': downloadURL,
          'parsedText': parsedText, // Store the extracted text
          'uploadedBy': model.user.email,
          'uploadedAt': Timestamp.now(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Syllabus uploaded successfully!')),
      );

      // Reset form and clear state
      setState(() {
        selectedDepartment = null;
        selectedCourseName = null;
        courseNumberController.clear();
        fileBytes = null;
        fileName = null;
        errorMessage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload syllabus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String accountName = model.user.email!.split('@')[0];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Column(
          children: [
            Text(
              "Faculty Page",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              "An LLM Integration with University Course Syllabus",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              'Welcome, $accountName!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Upload Heading
            const Text(
              "Upload the Syllabus PDF",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Department Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Department'),
              value: selectedDepartment,
              items: departmentCourses.keys.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                  selectedCourseName =
                      null; // Reset course name on department change
                });
              },
            ),
            const SizedBox(height: 10),

            // Course Name Dropdown (depends on selected department)
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: 'Select Course Name'),
              value: selectedCourseName,
              items: selectedDepartment != null
                  ? departmentCourses[selectedDepartment]!
                      .map((course) => DropdownMenuItem(
                            value: course,
                            child: Text(course),
                          ))
                      .toList()
                  : [],
              onChanged: (value) {
                setState(() {
                  selectedCourseName = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Course Number Input
            TextField(
              controller: courseNumberController,
              decoration: const InputDecoration(labelText: 'Course Number'),
            ),

            const SizedBox(height: 20),

            // PDF Upload Button
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickPdfFile,
                  child: const Text("Select PDF"),
                ),
                const SizedBox(width: 10),
                if (fileName != null) Text("Selected: $fileName"),
              ],
            ),

            // Error Message
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _uploadSyllabus,
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
      drawer: drawerView(context),
    );
  }

  Widget drawerView(BuildContext context) {
    // Extract the name part before '@' from the email
    String accountName = model.user.email!.split('@')[0];

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName), // Display the extracted name
            accountEmail: Text(model.user.email!),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person, // Profile icon
                size: 40,
                color: Colors.black54,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.black, // Background color for the drawer header
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: con.signOut,
          ),
        ],
      ),
    );
  }
}
