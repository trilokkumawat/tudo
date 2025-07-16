import 'package:alarm/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo/backend/firebaes/firebase_service.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/addTask/taskadd.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/utils/notification_helper.dart';
import 'package:todo/services/auth_service.dart';

class TaskModel extends FlutterFlowModel<TaskAddScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  // String? selectedTime;
  String? selectedreminder;
  // String? selectedAlaram;
  DateTime? selectedDate;
  final AuthService _authService = AuthService();
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void initState(BuildContext context) {
    // TODO: implement initState
  }
  editdatacatch(taskedit) {
    taskController.text = taskedit!["task"];
    notesController.text = taskedit!["notes"];
    // selectedTime = taskedit!["time"];
    // selectedAlaram = taskedit!["alarm"];
    selectedreminder = taskedit!["reminder"];

    final dateValue = taskedit!["date"];

    if (dateValue is Timestamp) {
      selectedDate = dateValue.toDate();
    } else if (dateValue is DateTime) {
      selectedDate = dateValue;
    } else {
      selectedDate = null; // or handle error
    }
  }

  taskPerform({String typeIs = "", String docid = ""}) async {
    final userId = _authService.userId;
    if (userId == null) {
      print('No user logged in');
      return;
    }
    print(' user logged in::$userId');

    if (typeIs == "ADD") {
      try {
        await firestoreService.addUserTask(userId, {
          "task": taskController.text,
          "notes": notesController.text,
          // "alarm": selectedAlaram,
          // "time": selectedTime,
          "created_at": DateTime.now().toUtc().toIso8601String(),
          "reminder": selectedreminder,
          "status": "active",
          "date": selectedDate,
          // 'userId': userId, // No need, service adds it
        });
      } catch (e) {
        print(e);
      }
    } else if (typeIs == "UPDATE") {
      try {
        await firestoreService.updateUserTask(userId, docid, {
          "task": taskController.text,
          "notes": notesController.text,
          // "alarm": selectedAlaram,
          // "time": selectedTime,
          "created_at": DateTime.now().toUtc().toIso8601String(),
          "reminder": selectedreminder,
          "status": "active",
          "date": selectedDate,
          // 'userId': userId, // No need, service adds it
        });
      } catch (e) {
        print(e);
      }
    }
  }

  // setalarm() async {
  //   try {
  //     // Parse selectedAlaram (HH:mm) and combine with _selectedDate
  //     final timeParts = selectedAlaram!.split(":");
  //     if (timeParts.length == 2) {
  //       final hour = int.tryParse(timeParts[0]) ?? 0;
  //       final minute = int.tryParse(timeParts[1]) ?? 0;
  //       final alarmDateTime = DateTime(
  //         selectedDate!.year,
  //         selectedDate!.month,
  //         selectedDate!.day,
  //         hour,
  //         minute,
  //       );
  //       await setAlarm(alarmDateTime);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> setAlarm(DateTime dt) async {
    await Alarm.init();

    final alarmSettings = AlarmSettings(
      id: dt.millisecondsSinceEpoch ~/ 1000, // unique id per alarm
      dateTime: dt,
      assetAudioPath: 'assets/audio/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
      notificationSettings: NotificationSettings(
        title: 'Task Reminder',
        body: 'You have a task scheduled now.',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  setReminder(remindersetIs, isType) async {
    try {
      String original = remindersetIs!.toLowerCase().trim();
      bool isPM = original.contains("pm");
      bool isAM = original.contains("am");

      // Remove am/pm for parsing
      String cleaned = original.replaceAll(" am", "").replaceAll(" pm", "");
      final timeParts = cleaned.split(":");
      if (timeParts.length == 2) {
        int hour = int.tryParse(timeParts[0]) ?? 0;
        int minute = int.tryParse(timeParts[1]) ?? 0;

        // Convert to 24-hour format if needed
        if (isPM && hour < 12) hour += 12;
        if (isAM && hour == 12) hour = 0;

        final reminderDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          hour,
          minute,
        );

        if (reminderDateTime.isAfter(DateTime.now())) {
          final notificationId =
              reminderDateTime.millisecondsSinceEpoch ~/ 1000;
          print(
            "Scheduling notification for" +
                reminderDateTime.toString() +
                " : " +
                selectedreminder! +
                " : " +
                hour.toString() +
                " :: " +
                minute.toString() +
                ", :: " +
                timeParts[1],
          );
          await NotificationHelper.scheduleNotification(
            id: notificationId,
            title:
                "${taskController.text} ${isType == "reminder" ? "reminder" : "your task was due"}",
            body: notesController.text,
            scheduledDate: reminderDateTime,
            type: "exact",
          );
        } else {
          print(
            "Reminder time $reminderDateTime is in the past. No notification scheduled.",
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
