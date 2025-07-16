import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ CREATE
  Future<void> addData(String collectionPath, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).add(data);
  }

  // ✅ READ (get all documents)
  Stream<QuerySnapshot> getData(String collectionPath) {
    return _db.collection(collectionPath).snapshots();
  }

  // ✅ READ (get single document by ID)
  Future<DocumentSnapshot> getDataById(
    String collectionPath,
    String docId,
  ) async {
    return await _db.collection(collectionPath).doc(docId).get();
  }

  // ✅ UPDATE
  Future<void> updateData(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection(collectionPath).doc(docId).update(data);
  }

  // ✅ DELETE
  Future<void> deleteData(String collectionPath, String docId) async {
    await _db.collection(collectionPath).doc(docId).delete();
  }

  // Add a task for a specific user (in 'task' collection)
  Future<void> addUserTask(String userId, Map<String, dynamic> data) async {
    await _db.collection('task').add({...data, 'userId': userId});
  }

  // Update a task for a specific user (in 'task' collection)
  Future<void> updateUserTask(
    String userId,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('task').doc(docId).update({...data, 'userId': userId});
  }

  // Delete a task for a specific user (in 'task' collection)
  Future<void> deleteUserTask(String userId, String docId) async {
    await _db.collection('task').doc(docId).delete();
  }

  // Get all task for a specific user (from 'task' collection)
  Stream<QuerySnapshot> getUsertask(String userId) {
    return _db
        .collection('task')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
