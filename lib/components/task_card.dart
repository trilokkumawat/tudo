import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/screens/addTask/task_model.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final String docId;
  final VoidCallback onStatusToggle;
  final VoidCallback onEdit;
  final bool showEdit;
  final VoidCallback? onClose;

  const TaskCard({
    super.key,
    required this.task,
    required this.docId,
    required this.onStatusToggle,
    required this.onEdit,
    this.showEdit = true,
    this.onClose,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Color _getTimeColor(String? timeStr, DateTime? dateVal) {
    DateTime now = DateTime.now();
    if (timeStr == null) return Colors.red;
    TimeOfDay? tod;
    if (timeStr.toLowerCase().contains('am') ||
        timeStr.toLowerCase().contains('pm')) {
      final format = RegExp(
        r'^(\d{1,2}):(\d{2}) ?([ap]m)$',
        caseSensitive: false,
      );
      final match = format.firstMatch(timeStr.trim());
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        String period = match.group(3)!.toLowerCase();
        if (period == 'pm' && hour < 12) hour += 12;
        if (period == 'am' && hour == 12) hour = 0;
        tod = TimeOfDay(hour: hour, minute: minute);
      }
    } else {
      final parts = timeStr.split(":");
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        tod = TimeOfDay(hour: hour, minute: minute);
      }
    }
    Color timeColor = Colors.red;
    if (tod != null && dateVal != null) {
      final taskDateTime = DateTime(
        dateVal.year,
        dateVal.month,
        dateVal.day,
        tod.hour,
        tod.minute,
      );
      if (taskDateTime.isAfter(now)) {
        timeColor = Colors.green;
      }
    }
    return timeColor;
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.task.status == 'complete';
    final hasAlarm = widget.task.alarm != null && widget.task.alarm!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
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
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.notifications_active_outlined, size: 15),
                Text(
                  widget.task.reminder ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                // if (widget.task.time != null && widget.task.time!.isNotEmpty)
                //   Builder(
                //     builder: (context) {
                //       String? timeStr = widget.task.time;
                //       DateTime? dateVal = widget.task.date;
                //       return Row(
                //         children: [
                //           Icon(Icons.access_time, size: 15),
                //           Text(
                //             timeStr!,
                //             style: TextStyle(
                //               color: _getTimeColor(timeStr, dateVal),
                //               fontSize: 12,
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF12272F),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 15),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onStatusToggle,
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
                            Text(
                              widget.task.task ?? '',
                              style: TextStyle(
                                color: const Color(0xFF12272F),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.task.notes != null &&
                                widget.task.notes!.isNotEmpty)
                              Text(
                                widget.task.notes ?? '',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (widget.showEdit && !isCompleted)
                      GestureDetector(
                        onTap: widget.onEdit,
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
                      Builder(
                        builder: (context) {
                          final String alarmText = widget.task.alarm ?? '';
                          return Text(
                            alarmText,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateTimeHelper.formatDate(widget.task.createdAt ?? ''),
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
    );
  }
}
