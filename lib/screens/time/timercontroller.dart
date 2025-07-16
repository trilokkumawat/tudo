import 'package:flutter/src/widgets/framework.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/time/interval/interval.dart';

class TimerController extends FlutterFlowModel<IntervalScreen> {
  int selectedIndex = 0;
  String collectionpath = "task";
  final FirestoreService firestore = FirestoreService();
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
}
