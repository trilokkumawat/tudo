import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<DocumentSnapshot> getDataById(String collectionPath, String docId) async {
    return await _db.collection(collectionPath).doc(docId).get();
  }

  // ✅ UPDATE
  Future<void> updateData(String collectionPath, String docId, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).doc(docId).update(data);
  }

  // ✅ DELETE
  Future<void> deleteData(String collectionPath, String docId) async {
    await _db.collection(collectionPath).doc(docId).delete();
  }
}
