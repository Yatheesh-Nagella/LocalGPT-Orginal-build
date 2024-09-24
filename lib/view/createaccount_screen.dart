import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/createAccountScreen';

  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
  }
} 

class CreateAccountState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: const Center(
        child: Text("Create Account"),
      ),
    );
  }
}