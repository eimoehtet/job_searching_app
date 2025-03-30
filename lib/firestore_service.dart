import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> applyForJob({
    required String jobId,
    required String jobTitle,
    required String companyName,
    required String cvUrl,
    required String message,
  }) async {
    String userId = _auth.currentUser!.uid;
    DocumentReference applicationRef = _db
        .collection('users')
        .doc(userId)
        .collection('applications')
        .doc(jobId); // Use jobId as the document ID to prevent duplicate applications

    await applicationRef.set({
      'jobId': jobId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'cvUrl': cvUrl,
      'message': message,
      'appliedAt': FieldValue.serverTimestamp(),
    });
  }
}
