import 'package:flutter/material.dart';
import 'package:todo/screens/monthlycalendar.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/utils/methodhelper.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  String? selectedTime;
  String? selectedAlaram;
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back),
                    ),
                    Icon(Icons.more_horiz),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Task",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF12272F),
                      ),
                    ),
                    Text(DateHelper.getFormattedTodayDate()),
                  ],
                ),
                SizedBox(height: 10),
                // Calendar
                MonthlyCalendar(
                  onDateSelected: (selectedDate) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  },
                ),
                SizedBox(height: 10),
                // Task Form
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Task",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: _taskController,
                          decoration: InputDecoration(
                            hintText: "Task Write...",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF12272F)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF12272F),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Task is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Notes",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            hintText: "Notes Write...",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF12272F)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF12272F),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Notes are required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (picked != null) {
                                      // Format using external class
                                      String formatted = DateHelper.formatTime(
                                        picked.hour,
                                        picked.minute,
                                      );

                                      safeSetState(this, () {
                                        selectedTime = formatted;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Time",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Icon(Icons.watch_later_outlined),
                                    ],
                                  ),
                                ),
                                Text(selectedTime ?? ""),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Alarm",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        TimeOfDay? picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (picked != null) {
                                          // Format using external class
                                          String formatted =
                                              DateHelper.formatTime(
                                                picked.hour,
                                                picked.minute,
                                              );

                                          safeSetState(this, () {
                                            selectedAlaram = formatted;
                                          });
                                        }
                                      },
                                      child: Icon(Icons.watch_later_outlined),
                                    ),
                                  ],
                                ),

                                Text(selectedAlaram ?? ""),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Add Task Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                       
                      } else {
                        // Show error if needed (handled by validators)
                      }
                    },
                    child: Text(
                      "Add Task",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
