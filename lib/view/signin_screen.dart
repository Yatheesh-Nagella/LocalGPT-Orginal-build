import 'package:flutter/material.dart';
import 'package:lesson6/controller/signinscreen_controller.dart';
import 'package:lesson6/model/signin_model.dart';

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
        title: const Text("sign in"),
      ),
      body: const Text('Sign In'),
    );
  }
}
