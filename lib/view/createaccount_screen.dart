import 'package:flutter/material.dart';
import 'package:lesson6/controller/createaccount_controller.dart';
import 'package:lesson6/model/createaccount_model.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/createAccountScreen';

  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
  }
} 

class CreateAccountState extends State<CreateAccountScreen> {

  late CreateAccountModel model;
  late CreateAccountController con;

  @override
  void initState() {
    super.initState();
    model = CreateAccountModel();
    con = CreateAccountController(this);
  }

  void callSetState(fn) => setState(fn);

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