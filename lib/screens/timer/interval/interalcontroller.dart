import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/services/auth_service.dart';

class IntervalController extends FlutterFlowModel {
  final AuthService authService = AuthService();
  final FirestoreService firestore = FirestoreService();
  int selectedIndex = 0;
  String collectionpath = "intervaltask";
  String? editingDocId;

  String name = '';
  String description = '';
  DateTime? startDate = DateTime.now();
  String repeat = 'Every Day';
  bool remind = false;
  TimeOfDay? remindTime;

  final List<String> repeatOptions = [
    'Every Day',
    'Every Week',
    'Every 30 Days',
  ];

  void setName(String value) {
    name = value;
    // notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    // notifyListeners();
  }

  void setStartDate(DateTime value) {
    startDate = value;
    // notifyListeners();
  }

  void setRepeat(String value) {
    repeat = value;
    // notifyListeners();
  }

  void setRemind(bool value) {
    remind = value;
    // notifyListeners();
  }

  void setRemindTime(TimeOfDay? value) {
    remindTime = value;
    // notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void initState(BuildContext context) {
    // TODO: implement initState
  }
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
