import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppliedJobScreen extends StatelessWidget {
  final Map<String, dynamic> jobApplication;

  AppliedJobScreen({required this.jobApplication});

  // Function to launch the URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applied Job"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Job Title: ${jobApplication['jobTitle']}"),
            Text("Company: ${jobApplication['companyName']}"),
            Text("Application Message: ${jobApplication['message']}"),
            SizedBox(height: 20),

            // Displaying the CV URL as a clickable text
            GestureDetector(
              onTap: () => _launchURL(jobApplication['cvUrl']),
              child: Text(
                "View CV",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
