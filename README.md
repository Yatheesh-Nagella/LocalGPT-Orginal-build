# Syllabus Chatbot using Retrieval Augmented Generation (RAG)

This project provides a web-based platform for students and professors to interact with course syllabi using natural language. By leveraging **Retrieval Augmented Generation (RAG)**, students can ask questions about course syllabi conversationally and get real-time responses. Professors can securely upload syllabi, while students can search and download them, enhancing accessibility and interactivity in learning.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
  - [Student View](#student-view)
  - [Professor View](#professor-view)
- [Firebase Configuration](#firebase-configuration)
- [License](#license)

---

## Features

1. **User-Friendly Interface**: Simple web interface for easy access by students and professors.
2. **Syllabus Upload by Professors**: Professors can upload syllabi in PDF format and add metadata such as:
   - Department
   - Course Name
   - Course Number
3. **Text Extraction and RAG Model**: Extracted syllabus content is processed for natural language interaction:
   - Text is parsed from PDF using `syncfusion_flutter_pdf` for accurate retrieval.
   - Students interact with syllabi content using a Retrieval Augmented Generation (RAG) model to get answers to specific questions.
4. **Access Control**:
   - Only professors with accounts can upload syllabi.
   - Students do not require authentication to search or download syllabi, providing open access to resources.
5. **Multiple Retrieval Options**:
   - **API-based Retrieval**: Supports Gemini or OpenAI APIs for fast, commercial access.
   - **In-house Retrieval**: Optionally, an in-house open-source model can be used for free access (though slightly slower).

## Technologies Used

- **Frontend**: Flutter & Dart (Web-based interface)
- **Firebase Services**:
  - **Firestore**: Database for storing metadata and extracted syllabus text.
  - **Storage**: Storing uploaded syllabi as PDFs.
  - **Authentication**: Secures syllabus upload access.
- **Text Extraction**: `syncfusion_flutter_pdf` package for parsing PDF text.
- **Language Model API**: Gemini/OpenAI for retrieval-augmented generation.

## Installation and Setup

### Prerequisites

1. **Flutter**: Ensure that Flutter is installed and properly configured.
2. **Firebase Account**: Set up a Firebase project for Firestore, Storage, and Authentication.

### Setup Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/syllabus-chatbot-rag.git
   cd syllabus-chatbot-rag
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Create a Firebase project and add web app configurations.
   - Enable Firestore, Storage, and Authentication in your Firebase project.
   - Replace `google-services.json` and `GoogleService-Info.plist` if targeting mobile apps.

4. **Update Firestore Rules**:
   Ensure your Firebase rules allow public read access for testing but secure write access to authenticated users (professors).

5. **Run the Application in chrome browser**:
   ```bash
   flutter run -d chrome
   ```

## Usage

### Student View

1. **Select Department**: Choose a department from a dropdown menu.
2. **Select Course**: Pick the relevant course based on department selection.
3. **Download Syllabus**: View the course syllabus metadata and download the PDF directly.
4. **Ask Questions**: Enter queries about the syllabus, and the system will respond using the extracted syllabus content with RAG-based responses.

### Professor View

1. **Login**: Authenticate using a Firebase-secured login.
2. **Upload Syllabus**: Professors can upload PDFs with metadata:
   - Select department, course name, and enter course number.
3. **Text Extraction and Metadata Storage**: Uploaded PDFs are parsed, and extracted content is stored in Firestore for search and retrieval.

## Firebase Configuration

- Ensure Firestore rules allow read access for public viewing while restricting write access to authenticated users.
- Structure your Firestore data for `syllabi` collections to include:
  - `department`, `courseName`, `courseNumber`, `fileURL`, and `parsedText` fields for easy querying.
  
Example rule (for testing):
```javascript
service cloud.firestore {
  match /databases/{database}/documents {
    match /syllabi/{document=**} {
      allow read: if true;
      allow write: if request.auth != null; // Only authenticated users can write
    }
  }
}
```

## License

This project is licensed under the MIT License.

---

## Contribution

Feel free to contribute by submitting issues or pull requests.