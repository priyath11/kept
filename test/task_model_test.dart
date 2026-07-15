import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kept/models/task_model.dart';

void main() {
  group('TaskModel', () {
    final createdAt = DateTime(2026, 1, 15, 9, 30);

    test('fromMap parses a complete map correctly', () {
      final map = {
        'task': 'Write CI tests',
        'status': 'completed',
        'createdAt': Timestamp.fromDate(createdAt),
        'date': '2026-01-15',
      };

      final model = TaskModel.fromMap('task_1', map);

      expect(model.id, 'task_1');
      expect(model.task, 'Write CI tests');
      expect(model.status, 'completed');
      expect(model.date, '2026-01-15');
      expect(model.createdAt, createdAt);
    });

    test('fromMap falls back to defaults when fields are missing', () {
      final map = {
        'createdAt': Timestamp.fromDate(createdAt),
      };

      final model = TaskModel.fromMap('task_2', map);

      expect(model.task, '');
      expect(model.status, 'pending');
      expect(model.date, '');
    });

    test('toMap serializes all fields back out', () {
      final model = TaskModel(
        id: 'task_3',
        task: 'Ship the resume',
        status: 'pending',
        createdAt: createdAt,
        date: '2026-01-15',
      );

      final map = model.toMap();

      expect(map['task'], 'Ship the resume');
      expect(map['status'], 'pending');
      expect(map['date'], '2026-01-15');
      expect(map['createdAt'], createdAt);
      // id is intentionally excluded from toMap since it's the document key
      expect(map.containsKey('id'), isFalse);
    });

    test('copyWith updates only the status field', () {
      final original = TaskModel(
        id: 'task_4',
        task: 'Fix CI pipeline',
        status: 'pending',
        createdAt: createdAt,
        date: '2026-01-15',
      );

      final updated = original.copyWith(status: 'didnt_finish');

      expect(updated.status, 'didnt_finish');
      expect(updated.id, original.id);
      expect(updated.task, original.task);
      expect(updated.date, original.date);
      expect(updated.createdAt, original.createdAt);
    });

    test('copyWith with no arguments preserves the original status', () {
      final original = TaskModel(
        id: 'task_5',
        task: 'Push to GitHub',
        status: 'completed',
        createdAt: createdAt,
        date: '2026-01-15',
      );

      final copy = original.copyWith();

      expect(copy.status, original.status);
    });
  });
}