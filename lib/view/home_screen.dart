import 'package:flutter/material.dart';
import 'package:lesson6/controller/home_controller.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState(){
    return HomeState();
  }
}

class HomeState extends State<HomeScreen>{

  late HomeController con;

  @override
  void initState(){
    super.initState();
    con = HomeController(this);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Text('Home'),
      drawer: drawerView(context),
    );
  }

  Widget drawerView(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('No profile'),
            accountEmail: const Text('email'),
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