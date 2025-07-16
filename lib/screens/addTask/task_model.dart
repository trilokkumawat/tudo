import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? _id;
  String? _alarm;
  String? _createdAt;
  DateTime? _date;
  String? _notes;
  String? _reminder;
  String? _status;
  String? _task;
  String? _time;

  TaskModel({
    String? id,
    String? alarm,
    String? createdAt,
    DateTime? date,
    String? notes,
    String? reminder,
    String? status,
    String? task,
    String? time,
  }) : _id = id,
       _alarm = alarm,
       _createdAt = createdAt,
       _date = date,
       _notes = notes,
       _reminder = reminder,
       _status = status,
       _task = task,
       _time = time;

  String? get id => _id;
  String? get alarm => _alarm;
  String? get createdAt => _createdAt;
  DateTime? get date => _date;
  String? get notes => _notes;
  String? get reminder => _reminder;
  String? get status => _status;
  String? get task => _task;
  String? get time => _time;

  set alarm(String? value) => _alarm = value;
  set createdAt(String? value) => _createdAt = value;
  set date(DateTime? value) => _date = value;
  set notes(String? value) => _notes = value;
  set reminder(String? value) => _reminder = value;
  set status(String? value) => _status = value;
  set task(String? value) => _task = value;
  set time(String? value) => _time = value;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'alarm': _alarm,
      'created_at': _createdAt,
      'date': _date != null ? Timestamp.fromDate(_date!) : null,
      'notes': _notes,
      'reminder': _reminder,
      'status': _status,
      'task': _task,
      'time': _time,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['date'] is Timestamp) {
      parsedDate = (json['date'] as Timestamp).toDate();
    } else if (json['date'] is String) {
      parsedDate = DateTime.tryParse(json['date']);
    }
    return TaskModel(
      id: json['id'] as String?,
      alarm: json['alarm'] as String?,
      createdAt: json['created_at'] as String?,
      date: parsedDate,
      notes: json['notes'] as String?,
      reminder: json['reminder'] as String?,
      status: json['status'] as String?,
      task: json['task'] as String?,
      time: json['time'] as String?,
    );
  }

  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel.fromJson({...data, 'id': doc.id});
  }

  TaskModel copyWith({
    String? id,
    String? alarm,
    String? createdAt,
    DateTime? date,
    String? notes,
    String? reminder,
    String? status,
    String? task,
    String? time,
  }) {
    return TaskModel(
      id: id ?? _id,
      alarm: alarm ?? _alarm,
      createdAt: createdAt ?? _createdAt,
      date: date ?? _date,
      notes: notes ?? _notes,
      reminder: reminder ?? _reminder,
      status: status ?? _status,
      task: task ?? _task,
      time: time ?? _time,
    );
  }
}
