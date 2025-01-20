import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add user data
  Future<void> addUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
      print("User added successfully to Firestore: $userData");
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Get user data
  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }
}
