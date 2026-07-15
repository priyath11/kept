import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final todayTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(taskServiceProvider);
  return service.getTodayTasks();
});

final progressProvider = Provider<double>((ref) {
  final tasksAsync = ref.watch(todayTasksProvider);
  return tasksAsync.when(
    data: (tasks) {
      if (tasks.isEmpty) return 0.0;
      final completed = tasks.where((t) => t.status == 'completed').length;
      return completed / tasks.length;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

final taskCountsProvider = Provider<Map<String, int>>((ref) {
  final tasksAsync = ref.watch(todayTasksProvider);
  return tasksAsync.when(
    data: (tasks) {
      return {
        'total': tasks.length,
        'completed': tasks.where((t) => t.status == 'completed').length,
        'pending': tasks.where((t) => t.status == 'pending').length,
        'didnt_finish': tasks.where((t) => t.status == 'didnt_finish').length,
      };
    },
    loading: () =>
        {'total': 0, 'completed': 0, 'pending': 0, 'didnt_finish': 0},
    error: (_, __) =>
        {'total': 0, 'completed': 0, 'pending': 0, 'didnt_finish': 0},
  );
});

class TaskViewModel extends Notifier<AsyncValue<void>> {
  late TaskService _service;

  @override
  AsyncValue<void> build() {
    _service = ref.watch(taskServiceProvider);
    return const AsyncValue.data(null);
  }

  Future<void> addTask(String taskText) async {
    if (taskText.trim().isEmpty) return;
    await _service.addTask(taskText.trim());
  }

  Future<void> markCompleted(String taskId) async {
    await _service.markCompleted(taskId);
  }

  Future<void> markDidntFinish(String taskId) async {
    await _service.markDidntFinish(taskId);
  }

  Future<void> checkAndResetDay() async {
    await _service.checkAndResetDay();
  }
}

final taskViewModelProvider = NotifierProvider<TaskViewModel, AsyncValue<void>>(
  TaskViewModel.new,
);
