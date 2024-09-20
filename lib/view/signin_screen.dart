import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget{
  const SignInScreen({super.key});
  @override
  State<StatefulWidget> createState(){
    return SignInState();
  }
}


class SignInState extends State<SignInScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("sign in"),
      ),
      body: const Text('Sign In'),
    );
  }
}