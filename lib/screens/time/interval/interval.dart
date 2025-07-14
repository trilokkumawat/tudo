import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  // Example dynamic data (could be loaded from backend)
  final List<IntervalTask> _intervalTasks = [
    IntervalTask(
      task: "Drink water",
      interval: "every 2 hours",
      reminder: true,
      date: DateTime.parse("2025-07-12T09:00:00Z"),
    ),
    IntervalTask(
      task: "Stretch",
      interval: "every 30 minutes",
      reminder: false,
      date: DateTime.parse("2025-07-12T09:30:00Z"),
    ),
    // Add more tasks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intervals")),
      body: ListView.builder(
        itemCount: _intervalTasks.length,
        itemBuilder: (context, index) {
          final task = _intervalTasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                task.reminder
                    ? Icons.notifications_active
                    : Icons.notifications_off,
                color: task.reminder ? Colors.green : Colors.grey,
              ),
              title: Text(
                task.task,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${task.interval}\n${DateFormat.yMMMd().add_jm().format(task.date)}",
                style: const TextStyle(fontSize: 13),
              ),
              isThreeLine: true,
              trailing: task.reminder
                  ? const Icon(Icons.alarm, color: Colors.blue)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
