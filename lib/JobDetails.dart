import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:job_searching_project/login.dart';

import 'applied_job_details.dart';
class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  JobDetailScreen({required this.job});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  Future<void> _submitApplication({
    required BuildContext context,
    required String message,
    required PlatformFile file,
    required String jobId,
  }) async {
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please sign in to apply")),
          );
        }
        return;
      }

      // Upload CV file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('job_applications/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      final uploadTask = storageRef.putData(file.bytes!);
      final taskSnapshot = await uploadTask;
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save application data to Firestore
      final applicationData = {
        'userId': user.uid,
        'userEmail': user.email,
        'jobId': jobId,
        'jobTitle': widget.job['job_title'],
        'companyName': widget.job['company_name'],
        'message': message,
        'cvUrl': downloadUrl,
        'appliedAt': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection('applications').add(applicationData);
     // Navigator.pop(context);
      if (mounted) {
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppliedJobScreen(jobApplication: applicationData),
            ),
          );
        });
      }

    } catch (e) {
      if (mounted) {
        // Builder(
        //   builder: (BuildContext context) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text("Error submitting!")),
        //     );
        //     return Container(); // Return any widget here as it's needed for context
        //   },
        // );
      }
    }
  }

  void _showApplyDialog(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    PlatformFile? selectedFile;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Apply for ${widget.job['job_title']}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write a message to the hiring team...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'docx'],
                  );

                  if (result != null) {
                    selectedFile = result.files.first;
                    // if (mounted) {
                    //   Builder(
                    //     builder: (BuildContext context) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(content: Text("Selected file: ${selectedFile!.name}")),
                    //       );
                    //       return Container(); // Return any widget here as it's needed for context
                    //     },
                    //   );
                    // }
                  }
                },
                icon: Icon(Icons.upload_file),
                label: Text("Upload CV (.pdf / .docx)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedFile == null) {
                  // if (mounted) {
                  //
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text("Please upload a CV")),
                  //   );
                  // }
                  return;
                }

                await _submitApplication(
                  context: context,
                  message: messageController.text,
                  file: selectedFile!,
                  jobId: widget.job['id'] ?? 'unknown_job_id',
                );

                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.job['job_title'] ?? 'Job Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Company: ${widget.job['company_name']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Location: ${widget.job['location']}"),
            SizedBox(height: 8),
            Text("Salary: ${widget.job['salary']} USD"),
            SizedBox(height: 8),
            Text("Skills required: "),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (widget.job['skills_required'] ?? [])
                  .map<Widget>((skill) => Text("- $skill"))
                  .toList(),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _showApplyDialog(context),
                child: Text("Apply Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
