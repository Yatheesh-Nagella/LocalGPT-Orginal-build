import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:file_picker/file_picker.dart';

class StudentpageScreen extends StatefulWidget {
  const StudentpageScreen({super.key});

  @override
  _StudentpageScreenState createState() => _StudentpageScreenState();
}

class _StudentpageScreenState extends State<StudentpageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _conversationHistory = []; // Stores the last 10 responses

  static const apiKey = "AIzaSyCw1kt7eNZ_3x63WL2PREbPv2FgLHy50HQ";

  void _searchPrompt() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = _searchController.text;
    if (prompt.isNotEmpty) {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _conversationHistory.insert(
            0, "User: $prompt\nAI: ${response.text ?? 'No response received.'}");

        // Keep only the last 10 entries
        if (_conversationHistory.length > 10) {
          _conversationHistory.removeLast();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a prompt to search.")),
      );
    }
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected file: ${result.files.single.name}")),
      );
      // Add any functionality here to process or upload the PDF file.
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No file selected.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studentpage'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Enter prompt here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickPdfFile,
                  child: const Text("Upload PDF"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchPrompt,
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            // Show conversation history if there are any entries
            if (_conversationHistory.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: _conversationHistory.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          _conversationHistory[index],
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
