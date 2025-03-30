import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_searching_project/JobList.dart';

class JobFormPage extends StatefulWidget {
  final String? jobId; // If null, we are creating a new job

  JobFormPage({this.jobId});

  @override
  _JobFormPageState createState() => _JobFormPageState();
}

class _JobFormPageState extends State<JobFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillsController = TextEditingController();
  List<String> requirements = [];
  final CollectionReference jobsCollection = FirebaseFirestore.instance.collection('jobs');

  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) {
      _loadJobData();
    }
  }

  void _loadJobData() async {
    var job = await jobsCollection.doc(widget.jobId).get();
    var data = job.data() as Map<String, dynamic>;
    setState(() {
      _titleController.text = data['job_title'];
      _companyController.text = data['company_name'];
      _salaryController.text = data['salary'];
      _locationController.text = data['location'];
      requirements = List<String>.from(data['skills_required'] ?? []);
    });
  }

  void _saveJob() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> jobData = {
        'job_title': _titleController.text,
        'company_name': _companyController.text,
        'salary': int.tryParse(_salaryController.text) ?? 0,
        'location': _locationController.text,
        'skills_required': requirements.map((s) => s.trim()).toList(),
      };

      if (widget.jobId == null) {
        await jobsCollection.add(jobData); // Add new job
      } else {
        await jobsCollection.doc(widget.jobId).update(jobData); // Update existing job
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  JobListScreen()),
      );
    }
  }
  void _addRequirement() {
    if (_skillsController.text.isNotEmpty) {
      setState(() {
        requirements.add(_skillsController.text);
        _skillsController.clear();
      });
    }
  }

  void _removeRequirement(int index) {
    setState(() {
      requirements.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.jobId == null ? "Add Job" : "Edit Job")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Job Title"),
                validator: (value) => value!.isEmpty ? "Enter job title" : null,
              ),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: "Company"),
                validator: (value) => value!.isEmpty ? "Enter company name" : null,
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: "Salary"),
                validator: (value) => value!.isEmpty ? "Enter job salary" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) => value!.isEmpty ? "Enter job location" : null,
              ),
              Text("Job Requirements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillsController,
                      decoration: InputDecoration(hintText: "Enter requirement"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.blue),
                    onPressed: _addRequirement,
                  ),
                ],
              ),

              /// List of Requirements
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: requirements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(requirements[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeRequirement(index),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveJob,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
