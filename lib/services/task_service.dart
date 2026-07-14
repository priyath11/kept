import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _today {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  CollectionReference get _tasksCollection {
    final userId = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  DocumentReference get _userDoc {
    final userId = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(userId);
  }

  Future<void> addTask(String taskText) async {
    final task = TaskModel(
      id: '',
      task: taskText,
      status: 'pending',
      createdAt: DateTime.now(),
      date: _today,
    );
    await _tasksCollection.add(task.toMap());
  }

  // Removed orderBy to avoid requiring a Firestore composite index
  Stream<List<TaskModel>> getTodayTasks() {
    return _tasksCollection
        .where('date', isEqualTo: _today)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> markCompleted(String taskId) async {
    await _tasksCollection.doc(taskId).update({'status': 'completed'});
  }

  Future<void> markDidntFinish(String taskId) async {
    await _tasksCollection.doc(taskId).update({'status': 'didnt_finish'});
  }

  Future<void> checkAndResetDay() async {
    final userSnap = await _userDoc.get();
    final data = userSnap.data() as Map<String, dynamic>?;
    final lastOpenedDate = data?['lastOpenedDate'] as String?;

    if (lastOpenedDate != null && lastOpenedDate != _today) {
      final pendingTasks = await _tasksCollection
          .where('date', isEqualTo: lastOpenedDate)
          .where('status', isEqualTo: 'pending')
          .get();

      for (final doc in pendingTasks.docs) {
        await doc.reference.update({'status': 'didnt_finish'});
      }
    }

    await _userDoc.set({'lastOpenedDate': _today}, SetOptions(merge: true));
  }
}