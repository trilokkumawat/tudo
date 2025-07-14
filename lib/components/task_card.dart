import 'package:flutter/material.dart';
import 'package:todo/utils/datetime_helper.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> taskData;
  final String docId;
  final VoidCallback onStatusToggle;
  final VoidCallback onEdit;
  final bool showEdit;
  final VoidCallback? onClose; // <-- Add this

  const TaskCard({
    super.key,
    required this.taskData,
    required this.docId,
    required this.onStatusToggle,
    required this.onEdit,
    this.showEdit = true,
    this.onClose, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = taskData['status'] == 'complete';
    final hasAlarm =
        taskData.containsKey('alarm') &&
        taskData['alarm'] != null &&
        taskData['alarm'].toString().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Icon and task info
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onStatusToggle,
                            child: Icon(
                              isCompleted
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_unchecked,
                              color: const Color(0xFF12272F),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (taskData.containsKey('time') &&
                                    taskData['time'] != null &&
                                    taskData['time'].toString().isNotEmpty)
                                  Text(
                                    taskData['time'],
                                    style: const TextStyle(
                                      color: Color(0xFF12272F),
                                      fontSize: 12,
                                    ),
                                  ),
                                Text(
                                  taskData["task"] ?? "",
                                  style: TextStyle(
                                    color: const Color(0xFF12272F),
                                    // decoration: isCompleted
                                    //     ? TextDecoration.lineThrough
                                    //     : null,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (taskData.containsKey('notes') &&
                                    taskData['notes'] != null &&
                                    taskData['notes'].toString().isNotEmpty)
                                  Text(
                                    taskData["notes"] ?? "",
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF12272F,
                                      ).withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side: Edit and alarm
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (showEdit && !isCompleted)
                          GestureDetector(
                            onTap: onEdit,
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                color: Color(0xFF12272F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (hasAlarm)
                          const Icon(
                            Icons.alarm_add_outlined,
                            color: Color(0xFF12272F),
                          ),
                        if (hasAlarm)
                          Text(
                            taskData['alarm'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    DateTimeHelper.formatDate(taskData["created_at"]),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF12272F),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
