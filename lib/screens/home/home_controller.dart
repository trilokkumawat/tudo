import 'package:flutter/material.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/services/auth_service.dart';

class HomeModel extends FlutterFlowModel<HomeScreen> {
  final tabs = ['All', 'Complete', 'Active'];
  int selectedIndex = 0;
  String collectionpath = "task";
  final FirestoreService firestore = FirestoreService();
  final AuthService authService = AuthService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  void updatetask(docId, status) async =>
      await firestore.updateData(collectionpath, docId, {"status": status});
  void deleteTask(docId) async =>
      await firestore.deleteData(collectionpath, docId);

  // Add a getter for the current user's tasks stream
  Stream<QuerySnapshot> currentUserTasksStream() {
    final userId = authService.userId;
    if (userId == null) {
      // Return an empty stream if not logged in
      return const Stream.empty();
    }
    return firestore.getUsertask(userId, collectionpath);
  }
}
