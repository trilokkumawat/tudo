import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/components/intervel_card.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/timer/timercontroller.dart';
import 'package:todo/services/auth_service.dart';

class IntervalTask {
  final String task;
  final String interval;
  final bool reminder;
  final DateTime date;

  IntervalTask({
    required this.task,
    required this.interval,
    required this.reminder,
    required this.date,
  });

  // For demonstration, you could add a fromJson factory if loading from backend
  factory IntervalTask.fromJson(Map<String, dynamic> json) {
    return IntervalTask(
      task: json['task'],
      interval: json['interval'],
      reminder: json['reminder'],
      date: DateTime.parse(json['date']),
    );
  }
}

class IntervalScreen extends StatefulWidget {
  const IntervalScreen({super.key});

  @override
  State<IntervalScreen> createState() => _IntervalScreenState();
}

class _IntervalScreenState extends State<IntervalScreen> {
  late TimerController _model;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    _model = createModel(context, () => TimerController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.userId;
    return Scaffold(
      // appBar: AppBar(title: const Text("Intervals")),
      body: StreamBuilder<QuerySnapshot>(
        stream: userId != null
            ? _model.firestore.getUsertask(userId)
            : const Stream.empty(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final allTasks = snapshot.data!.docs;
          // List filteredTasks;

          // if (_model.selectedIndex == 1) {
          //   // Complete
          //   filteredTasks = allTasks
          //       .where(
          //         (doc) =>
          //             (doc.data() as Map<String, dynamic>)['status'] ==
          //             'complete',
          //       )
          //       .toList();
          // } else
          //  if (_model.selectedIndex == 2) {
          //   // Active
          //   filteredTasks = allTasks
          //       .where(
          //         (doc) =>
          //             (doc.data() as Map<String, dynamic>)['status'] ==
          //             'active',
          //       )
          //       .toList();
          // } else {
          //   // All
          //   filteredTasks = allTasks;
          // }
          final filteredTasks = allTasks
              .where(
                (doc) =>
                    (doc.data() as Map<String, dynamic>)['status'] == 'active',
              )
              .toList();
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              final data = task.data() as Map<String, dynamic>?;
              final docId = task.id;

              if (data == null) return const SizedBox.shrink();

              return IntervalCard(
                taskData: data,
                docId: docId,
                onStatusToggle: () async {
                  if (data["status"] == "active") {
                    _model.updatetask(docId, "complete");
                  } else {
                    _model.updatetask(docId, "active");
                  }
                },

                onEdit: () {
                  data["docId"] = docId;
                  context.go('/edit-task', extra: data);
                },
                onRepeatChange: (repeatType, repeatUntil) async {
                  await _model.firestore
                      .updateData(_model.collectionpath, docId, {
                        "repeat": repeatType?.name,
                        "repeat_until": repeatUntil?.toUtc().toIso8601String(),
                      });
                },
                // onClose: () {
                //   _model.deleteTask(docId);
                // },
              );
            },
          );
        },
      ),
    );
  }
}
