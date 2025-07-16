import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/timer/interval/interval.dart';
import 'package:todo/screens/timer/interval/interval_latest.dart';
import 'package:todo/services/auth_service.dart';

class TimerController extends FlutterFlowModel<IntervalScreenLatest> {
  int selectedIndex = 0;
  String collectionpath = "task";
  final FirestoreService firestore = FirestoreService();
  final AuthService _authService = AuthService();

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
  Stream<QuerySnapshot> currentUserTasksStream() {
    final userId = _authService.userId;
    if (userId == null) {
      // Return an empty stream if not logged in
      return const Stream.empty();
    }
    return firestore.getUsertask(userId, "task");
  }
}
