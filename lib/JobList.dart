import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_searching_project/JobDetails.dart';

class JobListScreen extends StatelessWidget {
  final CollectionReference jobs =
  FirebaseFirestore.instance.collection('jobs');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: jobs.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error fetching jobs"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No job listings available"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var job = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  tileColor: Colors.blue[50],
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder( // Rounded edges
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(job['job_title'] ?? 'No Title'),
                  subtitle: Text("Company Name : ${job['company_name']} \nSalary : ${job['salary']}\nLocation : ${job['location']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailScreen(job: job),
                      ),
                    );
                  },
                ),
              );
            }).toList(),

          );
        },
      ),

    );
  }
}

