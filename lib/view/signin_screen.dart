import 'package:flutter/material.dart';
import 'package:lesson6/controller/signinscreen_controller.dart';
import 'package:lesson6/model/signin_model.dart';
import 'package:lesson6/view/Studentpage_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignInScreen> {
  late SigninModel model;
  late SignInScreenController con;
  final formKey = GlobalKey<FormState>();

  bool isHoveringSignIn = false; // Hover for Sign In button
  bool isHoveringSignUp = false; // Hover for Sign Up button
  bool isHoveringStudentPage = false; // Hover for Go to Student Page button

  @override
  void initState() {
    super.initState();
    model = SigninModel();
    con = SignInScreenController(this);
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text("LocalGPT"),
            SizedBox(height: 8),
            Text(
              "An LLM Integration with University Course Syllabus",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: model.inProgress
            ? const Center(child: CircularProgressIndicator())
            : signInForm(),
      ),
    );
  }

  Widget signInForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Dialog
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "Welcome to LocalGPT!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    "An AI-powered interface for students and professors to interact with course syllabi seamlessly.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Email Input Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: "Enter your email",
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: model.validateEmail,
                  onSaved: model.saveEmail,
                ),
                const SizedBox(height: 15.0),

                // Password Input Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  autocorrect: false,
                  validator: model.validatePassword,
                  onSaved: model.savePassword,
                ),
                const SizedBox(height: 25.0),

                // Sign In Button with Hover Effect
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveringSignIn = true),
                  onExit: (_) => setState(() => isHoveringSignIn = false),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: con.signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isHoveringSignIn ? Colors.green : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      child: const Text("Sign In"),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Sign Up Option with Hover Effect
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveringSignUp = true),
                  onExit: (_) => setState(() => isHoveringSignUp = false),
                  child: TextButton(
                    onPressed: con.gotoCreateAccount,
                    style: TextButton.styleFrom(
                      foregroundColor:
                          isHoveringSignUp ? Colors.green : Colors.black,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Go to Student Page Button with Hover Effect and Dialog
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveringStudentPage = true),
                  onExit: (_) => setState(() => isHoveringStudentPage = false),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: isHoveringStudentPage
                            ? [Colors.green.shade400, Colors.green.shade700]
                            : [Colors.black, Colors.black87],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Student Page"),
                              content: const Text(
                                  "Navigate to the Student Page to explore your syllabus and interact with LocalGPT."),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text("Proceed"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const StudentpageScreen()),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      child: const Text("Go to Student Page"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
