import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_searching_project/JobList.dart';
import 'package:job_searching_project/applied_job_details.dart';
import 'package:job_searching_project/MyProfile.dart';
import 'package:job_searching_project/login.dart';
class MyHomePage extends StatefulWidget {
  final String username;
  final String email;
  const MyHomePage({super.key,required this.username,required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex=0;
  final List<Widget>_widgetOptions =[
    JobListScreen(),
    AppliedJobScreen(),
    UserProfileScreen()
  ];

  void onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen (replace with your login route)
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Job Searching App",style: TextStyle(color: Colors.white
            ),),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
          ),
          drawer: Drawer(child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text(widget.username),
                  accountEmail: Text(widget.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("img/princess.jpg"),
                  ),
                 decoration: BoxDecoration(
                   color: Colors.blue
                 ),
              ),
              ListTile(leading: Icon(Icons.logout),title: Text("Logout"),onTap: () => _logout(context),),

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
