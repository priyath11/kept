import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_theme.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _taskController = TextEditingController();
  bool _showAddField = false;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() async {
    if (_taskController.text.trim().isEmpty) return;
    await ref
        .read(taskViewModelProvider.notifier)
        .addTask(_taskController.text);
    _taskController.clear();
    setState(() => _showAddField = false);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(todayTasksProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _showAddField = !_showAddField);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppTheme.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _showAddField ? Icons.close : Icons.add,
                        color: AppTheme.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Commit. Execute. Repeat.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.lightGray,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 20),
              if (_showAddField) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'What will you get done today?',
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _addTask,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: tasksAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.black,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (e, _) => const SizedBox.shrink(),
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.cardBackground,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.lightGray.withOpacity(0.3),
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppTheme.lightGray,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No tasks yet.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkGray,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tap + to add something\nyou will actually do.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.lightGray,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          task: task,
                          onCompleted: () => ref
                              .read(taskViewModelProvider.notifier)
                              .markCompleted(task.id),
                          onDidntFinish: () => ref
                              .read(taskViewModelProvider.notifier)
                              .markDidntFinish(task.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
