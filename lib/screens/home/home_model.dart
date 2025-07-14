import 'package:flutter/material.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/home/home.dart';

class HomeModel extends FlutterFlowModel<HomeScreen> {
  final tabs = ['All', 'Complete', 'Active'];
  int selectedIndex = 0;
  String collectionpath = "task";
  final FirestoreService firestore = FirestoreService();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  void updatetask(docId, status) async =>
      await firestore.updateData(collectionpath, docId, {"status": status});
  void deleteTask(docId) async =>
      await firestore.deleteData(collectionpath, docId);
}
