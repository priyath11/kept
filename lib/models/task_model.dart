import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String task;
  final String status;
  final DateTime createdAt;
  final String date;

  TaskModel({
    required this.id,
    required this.task,
    required this.status,
    required this.createdAt,
    required this.date,
  });

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      task: map['task'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task': task,
      'status': status,
      'createdAt': createdAt,
      'date': date,
    };
  }

  TaskModel copyWith({String? status}) {
    return TaskModel(
      id: id,
      task: task,
      status: status ?? this.status,
      createdAt: createdAt,
      date: date,
    );
  }
}
