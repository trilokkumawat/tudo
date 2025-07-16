import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo/utils/datetime_helper.dart';

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

  void _showRepeatBottomSheet(BuildContext context) async {
    RepeatType? selectedType;
    DateTime? repeatUntil;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Repeat Type',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  DropdownButton<RepeatType>(
                    value: selectedType,
                    hint: const Text('Select repeat type'),
                    isExpanded: true,
                    items: RepeatType.values.map((type) {
                      return DropdownMenuItem<RepeatType>(
                        value: type,
                        child: Text(
                          type.name[0].toUpperCase() + type.name.substring(1),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedType = val),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Repeat Until',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        repeatUntil == null
                            ? 'No date selected'
                            : '${repeatUntil!.toLocal()}'.split(' ')[0],
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: repeatUntil ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setState(() => repeatUntil = picked);
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onRepeatChange != null) {
                          widget.onRepeatChange!(selectedType, repeatUntil);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
            // Row(
            //   spacing: 3, // Remove spacing property (not valid for Row)
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     Icon(Icons.notifications_active_outlined, size: 15),
            //     Text(
            //       "${widget.taskData['reminder']}",
            //       style: TextStyle(fontSize: 12),
            //     ),
            //     if (widget.taskData.containsKey('time') &&
            //         widget.taskData['time'] != null &&
            //         widget.taskData['time'].toString().isNotEmpty)
            //       Builder(
            //         builder: (context) {
            //           String timeStr = widget.taskData['time'];
            //           var dateVal = widget.taskData['date'];
            //           return Row(
            //             spacing: 5,
            //             children: [
            //               Icon(Icons.access_time, size: 15),
            //               Text(
            //                 timeStr,
            //                 style: TextStyle(
            //                   color: _getTimeColor(timeStr, dateVal),
            //                   fontSize: 12,
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     Spacer(), // Pushes the close icon to the right
            //     Align(
            //       alignment: Alignment.topRight,
            //       child: GestureDetector(
            //         onTap: widget.onClose,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: Color(0xFF12272F),
            //             borderRadius: BorderRadius.circular(50),
            //           ),
            //           child: Icon(Icons.repeat, color: Colors.white, size: 15),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Icon and task info
                Expanded(
                  child: Row(
                    children: [
                      // GestureDetector(
                      //   onTap: widget.onStatusToggle,
                      //   child: Icon(
                      //     isCompleted
                      //         ? Icons.radio_button_checked_outlined
                      //         : Icons.radio_button_unchecked,
                      //     color: const Color(0xFF12272F),
                      //   ),
                      // ),
                      // const SizedBox(width: 20),
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
                  onPressed: () => _showRepeatBottomSheet(context),
                ),
                // Right side: Edit and alarm
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     if (widget.showEdit && !isCompleted)
                //       GestureDetector(
                //         onTap: widget.onEdit,
                //         child: const Text(
                //           "Edit",
                //           style: TextStyle(
                //             color: Color(0xFF12272F),
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     if (hasAlarm)
                //       const Icon(
                //         Icons.alarm_add_outlined,
                //         color: Color(0xFF12272F),
                //       ),
                //     if (hasAlarm)
                //       Text(
                //         widget.taskData['alarm'],
                //         style: const TextStyle(
                //           fontSize: 10,
                //           fontWeight: FontWeight.w300,
                //           color: Colors.grey,
                //         ),
                //       ),
                //   ],
                // ),
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
