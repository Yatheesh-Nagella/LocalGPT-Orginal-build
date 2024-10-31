import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesson6/view/createaccount_screen.dart';
import 'package:lesson6/view/startdispatcher.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensures that the Firebase core is initialized before the app starts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FirebaseTemplateApp());
}

class FirebaseTemplateApp extends StatelessWidget {
  const FirebaseTemplateApp({super.key});

  @override
  Widget build(Object context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        CreateAccountScreen.routeName:(context) => const CreateAccountScreen(),
      },
    );
  }
}
