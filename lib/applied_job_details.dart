import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppliedJobScreen extends StatefulWidget {
  const AppliedJobScreen({Key? key}) : super(key: key);

  @override
  _AppliedJobScreenState createState() => _AppliedJobScreenState();
}

class _AppliedJobScreenState extends State<AppliedJobScreen> {
  late Future<List<Map<String, dynamic>>> _appliedJobsFuture;

  @override
  void initState() {
    super.initState();
    _appliedJobsFuture = _fetchAppliedJobs();
  }

  Future<List<Map<String, dynamic>>> _fetchAppliedJobs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user signed in.");
      return [];
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user.uid)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching applied jobs: $e");
      return [];
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("Could not launch URL: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Applied Jobs")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _appliedJobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Failed to load jobs."));
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return Center(child: Text("You haven't applied to any jobs yet."));
          }

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              final jobTitle = job['jobTitle'] ?? 'No Title';
              final companyName = job['companyName'] ?? 'Unknown Company';
              final message = job['message'] ?? '';
              final cvUrl = job['cvUrl'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(jobTitle),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Company: $companyName"),
                        SizedBox(height: 4),
                        Text("Message: $message"),
                        if (cvUrl != null && cvUrl is String && cvUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: GestureDetector(
                              onTap: () => _launchURL(cvUrl),
                              child: Text(
                                "View CV",
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
