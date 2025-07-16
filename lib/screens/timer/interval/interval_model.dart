import 'package:cloud_firestore/cloud_firestore.dart';

class IntervalModel {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final String repeat;
  final bool remind;
  final String? remindTime;
  final String userId;
  final DateTime createdAt;

  IntervalModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.repeat,
    required this.remind,
    this.remindTime,
    required this.userId,
    required this.createdAt,
  });

  factory IntervalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IntervalModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['start_date'] as Timestamp).toDate(),
      repeat: data['repeat'] ?? '',
      remind: data['remind'] ?? false,
      remindTime: data['remind_time'],
      userId: data['user_id'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'start_date': Timestamp.fromDate(startDate),
      'repeat': repeat,
      'remind': remind,
      'remind_time': remindTime,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
