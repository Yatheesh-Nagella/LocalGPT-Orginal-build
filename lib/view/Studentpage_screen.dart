import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';
//import 'package:google_generative_ai/google_generative_ai.dart'; // Assuming Google Generative AI API is used
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For HTTP requests

class StudentpageScreen extends StatefulWidget {
  const StudentpageScreen({super.key});

  @override
  _StudentpageScreenState createState() => _StudentpageScreenState();
}

class _StudentpageScreenState extends State<StudentpageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedDepartment;
  String? selectedCourseName;
  String? courseNumber;
  String? pdfUrl; // To store the URL of the PDF file
  String? syllabusContent; // To store syllabus text for chat context

  final List<String> departments = ['Computer Science', 'Arts', 'Music', 'Psychology'];
  List<String> courseNames = [];
  final List<String> conversationHistory = []; // Stores conversation history for display

  void _loadCourses() async {
    if (selectedDepartment == null) return;

    final coursesSnapshot = await FirebaseFirestore.instance
        .collection('syllabi')
        .where('department', isEqualTo: selectedDepartment)
        .get();

    setState(() {
      courseNames = coursesSnapshot.docs
          .map((doc) => doc['courseName'] as String)
          .toSet()
          .toList();
      selectedCourseName = null;
      courseNumber = null;
    });
  }

  void _loadCourseNumberAndContent() async {
    if (selectedDepartment == null || selectedCourseName == null) return;

    final courseSnapshot = await FirebaseFirestore.instance
        .collection('syllabi')
        .where('department', isEqualTo: selectedDepartment)
        .where('courseName', isEqualTo: selectedCourseName)
        .limit(1)
        .get();

    if (courseSnapshot.docs.isNotEmpty) {
      setState(() {
        courseNumber = courseSnapshot.docs.first['courseNumber'];
        pdfUrl = courseSnapshot.docs.first['fileURL'];
        syllabusContent = courseSnapshot.docs.first['parsedText']; // Load syllabus content
      });
    }
  }

  void _downloadPdf() {
    if (pdfUrl != null) {
      launchUrlString(pdfUrl!, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file available to download.")),
      );
    }
  }

  // Function to ask a question and get a response
  Future<void> _askQuestion() async {
  final question = _searchController.text;
  if (question.isEmpty || syllabusContent == null) return;

  // Construct the prompt with the syllabus content and question
  final prompt = '''
    Syllabus content:
    $syllabusContent
    
    Student question:
    $question
  ''';

  // Define the payload for the custom API
  final payload = {
    "prompt": prompt,
    "max_tokens": 512 // Adjust token limit based on your API requirements
  };

  try {
    // Send a POST request to the custom API
    final response = await http.post(
      Uri.parse("http://csai01:8000/generate/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      // Check for the response content in the API response
      if (responseJson.containsKey('response') &&
          responseJson['response'].containsKey('content')) {
        setState(() {
          conversationHistory.insert(
              0,
              "You: $question\nAI: ${responseJson['response']['content']}");
          if (conversationHistory.length > 10) conversationHistory.removeLast(); // Limit history
          _searchController.clear();
        });
      } else {
        // Handle unexpected response format
        setState(() {
          conversationHistory.insert(
              0, "You: $question\nAI: Unexpected response format.");
        });
      }
    } else {
      // Handle API error
      setState(() {
        conversationHistory.insert(
            0, "You: $question\nAI: Request failed with status code ${response.statusCode}.");
      });
    }
  } catch (e) {
    // Handle connection or other errors
    setState(() {
      conversationHistory.insert(
          0, "You: $question\nAI: Failed to connect to the server. Error: $e");
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Department Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Department'),
              value: selectedDepartment,
              items: departments.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Text(dept),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                  courseNames = [];
                  selectedCourseName = null;
                  courseNumber = null;
                  pdfUrl = null;
                  syllabusContent = null;
                });
                _loadCourses();
              },
            ),
            const SizedBox(height: 10),

            // Course Name Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Course Name'),
              value: selectedCourseName,
              items: courseNames.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourseName = value;
                  courseNumber = null;
                  pdfUrl = null;
                  syllabusContent = null;
                });
                _loadCourseNumberAndContent();
              },
            ),
            const SizedBox(height: 10),

            // Course Number Display
            if (courseNumber != null)
              Text(
                'Course Number: $courseNumber',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),

            // Button to Download PDF
            if (pdfUrl != null)
              ElevatedButton(
                onPressed: _downloadPdf,
                child: const Text("Download PDF"),
              ),

            const SizedBox(height: 20),

            // Chat Section
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Ask a question about this course',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _askQuestion(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _askQuestion,
              child: const Text("Ask"),
            ),

            const SizedBox(height: 20),

            // Display conversation history
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView.builder(
                  itemCount: conversationHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        conversationHistory[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
