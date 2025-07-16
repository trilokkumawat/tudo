import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/utils/notification_helper.dart';

// Move enum to top-level
enum RepeatType { hourly, daily, weekly, monthly, yearly }

typedef RepeatChangeCallback =
    void Function(RepeatType? repeat, DateTime? repeatUntil);

class IntervalCard extends StatefulWidget {
  final Map<String, dynamic> taskData;
  final String docId;
  final VoidCallback onStatusToggle;
  final VoidCallback onEdit;
  final bool showEdit;
  final VoidCallback? onClose;
  final RepeatChangeCallback? onRepeatChange;

  const IntervalCard({
    super.key,
    required this.taskData,
    required this.docId,
    required this.onStatusToggle,
    required this.onEdit,
    this.showEdit = true,
    this.onClose,
    this.onRepeatChange,
  });

  @override
  State<IntervalCard> createState() => _IntervalCardState();
}

class _IntervalCardState extends State<IntervalCard> {
  Color _getTimeColor(String timeStr, dynamic dateVal) {
    DateTime now = DateTime.now();
    TimeOfDay? tod;
    if (timeStr.toLowerCase().contains('am') ||
        timeStr.toLowerCase().contains('pm')) {
      // 12-hour format
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
      // 24-hour format
      final parts = timeStr.split(":");
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        tod = TimeOfDay(hour: hour, minute: minute);
      }
    }
    Color timeColor = Colors.red;
    if (tod != null && dateVal != null) {
      DateTime date;
      if (dateVal is DateTime) {
        date = dateVal;
      } else if (dateVal is String) {
        date = DateTime.tryParse(dateVal) ?? now;
      } else {
        date = now;
      }
      final taskDateTime = DateTime(
        date.year,
        date.month,
        date.day,
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
    final isCompleted = widget.taskData['status'] == 'complete';
    final hasAlarm =
        widget.taskData.containsKey('alarm') &&
        widget.taskData['alarm'] != null &&
        widget.taskData['alarm'].toString().isNotEmpty;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.taskData["task"] ?? "",
                              style: TextStyle(
                                color: const Color(0xFF12272F),
                                // decoration: isCompleted
                                //     ? TextDecoration.lineThrough
                                //     : null,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.taskData.containsKey('notes') &&
                                widget.taskData['notes'] != null &&
                                widget.taskData['notes'].toString().isNotEmpty)
                              Text(
                                widget.taskData["notes"] ?? "",
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
                // Right side: Repeat icon
                IconButton(
                  icon: const Icon(Icons.repeat, color: Color(0xFF12272F)),
                  onPressed: () async {
                    CustomRepeatType? selectedRepeatType =
                        CustomRepeatType.hourly;
                    DateTime selectedDate = DateTime.now();
                    int repeatValue = 1;
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Select Repeat Interval',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButton<CustomRepeatType>(
                                    value: selectedRepeatType,
                                    items: CustomRepeatType.values
                                        .where(
                                          (e) => e != CustomRepeatType.none,
                                        )
                                        .map((type) {
                                          return DropdownMenuItem<
                                            CustomRepeatType
                                          >(
                                            value: type,
                                            child: Text(
                                              type.toString().split('.').last,
                                            ),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (value) {
                                      setModalState(() {
                                        selectedRepeatType = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text('Start Date: '),
                                      TextButton(
                                        onPressed: () async {
                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (picked != null) {
                                            setModalState(() {
                                              selectedDate = picked;
                                            });
                                          }
                                        },
                                        child: Text(
                                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text('Repeat every'),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 50,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                          ),
                                          controller: TextEditingController(
                                            text: repeatValue.toString(),
                                          ),
                                          onChanged: (val) {
                                            final parsed = int.tryParse(val);
                                            if (parsed != null && parsed > 0) {
                                              setModalState(() {
                                                repeatValue = parsed;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        selectedRepeatType
                                            .toString()
                                            .split('.')
                                            .last,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await NotificationHelper.scheduleNotification(
                                        id: 1, // Replace with unique id
                                        title:
                                            widget.taskData['task'] ?? 'Task',
                                        body: widget.taskData['notes'] ?? '',
                                        scheduledDate: selectedDate,
                                        type: 'interval',
                                        repeatType: selectedRepeatType!,
                                        // You may want to add repeatValue to your notification logic if needed
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Set Repeat'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateTimeHelper.formatDate(widget.taskData["created_at"]),
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
