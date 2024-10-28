import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/home_controller.dart';
import 'package:lesson6/model/home_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

  @override
  void initState() {
    super.initState();
    con = HomeController(this);
    model = HomeModel(currentUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: PopScope(
        canPop: false, // Disable back button
        child: Text(model.user.email!),
      ),
      drawer: drawerView(context),
    );
  }

/*
static const apiKey = "AIzaSyCw1kt7eNZ_3x63WL2PREbPv2FgLHy50HQ";

void main() async {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
  );

  final prompt = "Write a story about a magic backpack.";
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);

  print(response.text);
};
*/

  Widget drawerView(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('No profile'),
            accountEmail: Text(model.user.email!),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: con.signOut,
          )
        ],
      ),
    );
  }
}
