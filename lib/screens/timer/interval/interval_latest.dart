import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/components/custom_text_field.dart';
import 'package:todo/components/custometext.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:todo/screens/timer/interval/interalcontroller.dart';
// Add the model import
import 'package:todo/screens/timer/interval/interval_model.dart';

class IntervalScreenLatest extends StatefulWidget {
  const IntervalScreenLatest({super.key});

  @override
  State<IntervalScreenLatest> createState() => _IntervalScreenLatestState();
}

class _IntervalScreenLatestState extends State<IntervalScreenLatest> {
  late IntervalController _controller;

  @override
  void initState() {
    _controller = createModel(context, () => IntervalController());
    super.initState();
  }

  TimeOfDay? parseTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})\s*([APMapm]{2})$',
    ).firstMatch(timeString.trim());
    if (match == null) return null;
    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    String period = match.group(3)!.toUpperCase();
    if (period == 'PM' && hour < 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _showAddIntervalTaskSheet({IntervalModel? task}) {
    if (task != null) {
      _controller.name = task.name;
      _controller.description = task.description;
      _controller.startDate = task.startDate;
      _controller.repeat = task.repeat;
      _controller.remind = task.remind;
      _controller.remindTime = parseTimeOfDay(task.remindTime);
      _controller.editingDocId = task.id;
    } else {
      _controller.name = '';
      _controller.description = '';
      _controller.startDate = DateTime.now();
      _controller.repeat = 'Every Day';
      _controller.remind = false;
      _controller.remindTime = null;
      _controller.editingDocId = null;
    }
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomeText(
                          text: 'Add Task Interval',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: TextEditingController(
                          text: _controller.name,
                        ),
                        labelText: 'Name *',
                        onChanged: (val) => _controller.name = val,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: TextEditingController(
                          text: _controller.description,
                        ),
                        labelText: 'Description',
                        maxLines: 2,
                        maxLength: 100,
                        onChanged: (val) => _controller.description = val,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Description is required'
                            : null,
                      ),
                      // TextFormField(
                      //   decoration: const InputDecoration(
                      //     labelText: 'Description',
                      //   ),
                      // ),
                      // const SizedBox(height: 12),
                      Row(
                        children: [
                          const CustomeText(
                            text: 'Start Date *: ',
                            uppercase: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _controller.startDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setModalState(
                                    () => _controller.startDate = picked,
                                  );
                                }
                              },
                              child: CustomeText(
                                text: _controller.startDate == null
                                    ? 'Select Date'
                                    : '${_controller.startDate!.year}-${_controller.startDate!.month.toString().padLeft(2, '0')}-${_controller.startDate!.day.toString().padLeft(2, '0')}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _controller.repeat,
                        items: _controller.repeatOptions
                            .map(
                              (opt) => DropdownMenuItem(
                                value: opt,
                                child: CustomeText(text: opt),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null)
                            setModalState(() => _controller.repeat = val);
                        },
                        decoration: InputDecoration(
                          hint: Text('Repeat *'),
                          filled: true,
                          fillColor:
                              Colors.white, // or any light color you want
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ), // Focus color
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Repeat is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _controller.remind,
                            onChanged: (val) {
                              setModalState(
                                () => _controller.remind = val ?? false,
                              );
                            },
                          ),
                          const CustomeText(text: 'Remind'),
                        ],
                      ),
                      if (_controller.remind)
                        Row(
                          children: [
                            const CustomeText(text: 'Remind Time: '),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        _controller.remindTime ??
                                        TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    setModalState(
                                      () => _controller.remindTime = picked,
                                    );
                                  }
                                },
                                child: CustomeText(
                                  text: _controller.remindTime == null
                                      ? 'Select Time'
                                      : _controller.remindTime!.format(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() != true)
                              return;
                            if (_controller.startDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: CustomeText(
                                    text: 'Please select a start date.',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (_controller.remind &&
                                _controller.remindTime == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: CustomeText(
                                    text: 'Please select a remind time.',
                                  ),
                                ),
                              );
                              return;
                            }
                            // Get current user
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: CustomeText(
                                    text:
                                        'You must be logged in to add a task.',
                                  ),
                                ),
                              );
                              return;
                            }
                            // Add to Firestore
                            if (_controller.editingDocId != null) {
                              // Update existing
                              await FirebaseFirestore.instance
                                  .collection('intervaltask')
                                  .doc(_controller.editingDocId)
                                  .update({
                                    'name': _controller.name.trim(),
                                    'description': _controller.description
                                        .trim(),
                                    'start_date': _controller.startDate,
                                    'repeat': _controller.repeat,
                                    'remind': _controller.remind,
                                    'remind_time': _controller.remindTime
                                        ?.format(context),
                                  });
                            } else {
                              // Add new
                              await FirebaseFirestore.instance
                                  .collection('intervaltask')
                                  .add({
                                    'userId': user.uid,
                                    'name': _controller.name.trim(),
                                    'description': _controller.description
                                        .trim(),
                                    'start_date': _controller.startDate,
                                    'repeat': _controller.repeat,
                                    'remind': _controller.remind,
                                    'remind_time': _controller.remindTime
                                        ?.format(context),
                                    'created_at': DateTime.now(),
                                  });
                            }
                            _controller.name = '';
                            _controller.description = '';
                            _controller.startDate = DateTime.now();
                            _controller.repeat = 'Every Day';
                            _controller.remind = false;
                            _controller.remindTime = null;
                            Navigator.of(context).pop();
                          },
                          child: CustomeText(
                            text: _controller.editingDocId != null
                                ? 'Update'
                                : 'Add',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _controller.authService.userId;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.currentUserTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: CustomeText(text: 'No interval tasks found.'),
            );
          }
          final docs = snapshot.data!.docs;
          final tasks = docs
              .map(
                (doc) => IntervalModel.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>,
                ),
              )
              .toList();

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              print(tasks.length);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomeText(
                            text: task.name,
                            uppercase: true,
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () => _showAddIntervalTaskSheet(task: task),
                            child: Icon(Icons.edit),
                          ),
                        ],
                      ),
                      CustomeText(text: task.description),
                      CustomeText(
                        text:
                            'Start: ${task.startDate.toString().split(' ')[0]}',
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomeText(
                              text: "${task.repeat}",
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            if (task.remind)
                              Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.alarm, size: 15),
                                  CustomeText(
                                    text: '${task.remindTime ?? ''}',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // Card(
              //   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //   child: ListTile(
              //     title: CustomeText(text: task.name),
              //     leading: CustomeText(text: task.name),
              //     subtitle: Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         if (task.description.isNotEmpty) CustomeText(text: task.description),
              //         CustomeText(text: 'Start: ${task.startDate.toString().split(' ')[0]}'),
              //         CustomeText(text: 'Repeat: ${task.repeat}'),
              //         if (task.remind)
              //           CustomeText(text: 'Remind at: ${task.remindTime ?? ''}'),
              //       ],
              //     ),
              //   ),
              // );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIntervalTaskSheet,
        child: Icon(Icons.add),
      ),
    );
  }
}
