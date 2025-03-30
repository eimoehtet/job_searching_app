import 'package:cloud_firestore/cloud_firestore.dart';
class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchJobs() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('jobs').get();
      List<Map<String, dynamic>> jobs = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      print("Fetched Jobs: $jobs"); // Debugging line

      return jobs;
    } catch (e) {
      print("Error fetching jobs: $e"); // Print any errors
      return [];
    }
  }

}