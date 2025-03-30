import 'package:flutter/material.dart';
import 'package:job_searching_project/JobList.dart';
import 'package:job_searching_project/login.dart';
class MyHomePage extends StatefulWidget {
  final String username;
  final String password;
  const MyHomePage({super.key,required this.username,required this.password});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex=0;
  final List<Widget>_widgetOptions =[
    JobListScreen(),
    LoginPage(),
    Text("Applied Jobs")
  ];

  void onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Job Searching App",style: TextStyle(color: Colors.white
            ),),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: Drawer(child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Username : ${widget.username}'),
                accountEmail: Text("Email : ${widget.password}"),
              ),
              ListTile(leading: Icon(Icons.logout),title: Text("Logout"),),
              ListTile(leading: Icon(Icons.home),title: Text("Home"),)

            ],
          ),),
          body: Center(
              child:_widgetOptions.elementAt(_selectedIndex),
          ),
         bottomNavigationBar:  BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.green,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "jobs"),
                BottomNavigationBarItem (icon: Icon(Icons.person),label: "profile")
              ],
             currentIndex: _selectedIndex,
             onTap: onItemTapped,
          )
      ),
    );
  }
}
