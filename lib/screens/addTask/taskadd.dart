import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/addTask/task_controller.dart';
import 'package:todo/components/monthlycalendar.dart';
import 'package:todo/utils/datetime_helper.dart';
import 'package:todo/utils/methodhelper.dart';
import 'package:todo/utils/notification_helper.dart';

class TaskAddScreen extends StatefulWidget {
  final Map<String, dynamic>? taskedit;
  const TaskAddScreen({super.key, this.taskedit});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late TaskModel _model;

  @override
  void initState() {
    _model = createModel(context, () => TaskModel());

    if (widget.taskedit != null && widget.taskedit!.isNotEmpty) {
      _model.editdatacatch(widget.taskedit);
    } else {
      _model.selectedDate = DateTime.now();
    }

    super.initState();
  }

  @override
  void dispose() {
    _model.taskController.dispose();
    _model.notesController.dispose();
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
                      onTap: () => context.go('/'),
                      child: Icon(Icons.arrow_back),
                    ),
                    Row(children: [Icon(Icons.more_horiz)]),
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
                    Text(DateTimeHelper.getFormattedTodayDate()),
                  ],
                ),

                SizedBox(height: 10),
                // Calendar
                MonthlyCalendar(
                  alreadyselectdate: _model.selectedDate,
                  onDateSelected: (selectedDate) {
                    setState(() {
                      _model.selectedDate = selectedDate;
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
                          // ignore: deprecated_member_use
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
                          controller: _model.taskController,
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
                          controller: _model.notesController,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () async {
                            //         TimeOfDay? picked = await showTimePicker(
                            //           context: context,
                            //           initialTime: _model.selectedTime != null
                            //               ? DateTimeHelper.parseTimeOfDay(
                            //                   _model.selectedTime!,
                            //                 )
                            //               : TimeOfDay.now(),
                            //         );

                            //         if (picked != null) {
                            //           // Format using external class
                            //           String formatted =
                            //               DateTimeHelper.formatTime(
                            //                 picked.hour,
                            //                 picked.minute,
                            //               );

                            //           safeSetState(this, () {
                            //             _model.selectedTime = formatted;
                            //           });
                            //         }
                            //       },
                            //       child: Row(
                            //         children: [
                            //           Text(
                            //             "Time",
                            //             style: TextStyle(
                            //               fontWeight: FontWeight.w600,
                            //               fontSize: 18,
                            //             ),
                            //           ),
                            //           Icon(Icons.timelapse_sharp),
                            //         ],
                            //       ),
                            //     ),
                            //     Text(_model.selectedTime ?? ""),
                            //   ],
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    TimeOfDay? picked = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          _model.selectedreminder != null
                                          ? DateTimeHelper.parseTimeOfDay(
                                              _model.selectedreminder!,
                                            )
                                          : TimeOfDay.now(),
                                    );

                                    if (picked != null) {
                                      // Format using external class
                                      String formatted =
                                          DateTimeHelper.formatTime(
                                            picked.hour,
                                            picked.minute,
                                          );

                                      safeSetState(this, () {
                                        _model.selectedreminder = formatted;
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Reminders",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Icon(Icons.watch_later),
                                    ],
                                  ),
                                ),
                                Text(_model.selectedreminder ?? ""),
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
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (widget.taskedit != null &&
                            widget.taskedit!.containsKey("docId")) {
                          await _model.taskPerform(
                            typeIs: "UPDATE",
                            docid: widget.taskedit!["docId"],
                          );
                          context.go('/');
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Successfully added!")),
                          );
                        } else {
                          try {
                            await _model.taskPerform(typeIs: "ADD");

                            // Set alarm if alarm time and date are selected
                            // if (_model.selectedAlaram != null &&
                            //     _model.selectedDate != null) {
                            //   await _model.setalarm();
                            // }

                            // Set notification if reminder time and date are selected
                            if (_model.selectedreminder != null &&
                                _model.selectedDate != null) {
                              await _model.setReminder(
                                _model.selectedreminder,
                                "reminder",
                              );
                            }

                            context.go('/');
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Successfully added!")),
                            );
                          } catch (e) {
                            print("Failed to add: $e");
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to add: $e")),
                            );
                          }
                        }
                      }
                    },
                    child: Text(
                      widget.taskedit != null &&
                              widget.taskedit!.containsKey("docId")
                          ? "Update Task"
                          : "Add Task",
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
