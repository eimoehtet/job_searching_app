import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_searching_project/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDFrT8c3wAinD7BTgERvQpwyQyBbB3rvjg",
        authDomain: "job-searching-project.firebaseapp.com",
        projectId: "job-searching-project",
        storageBucket: "job-searching-project.firebasestorage.app",
        messagingSenderId: "142891883729",
        appId: "1:142891883729:web:7531029a0481604115b9f0"
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}






