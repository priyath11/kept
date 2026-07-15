import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onCompleted;
  final VoidCallback onDidntFinish;

  const TaskTile({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onDidntFinish,
  });

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Did you finish this?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        content: Text(
          task.task,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mediumGray,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Not yet',
              style: TextStyle(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onCompleted();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.black,
              foregroundColor: AppTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Yes, done!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = task.status == 'pending';
    final isCompleted = task.status == 'completed';
    final isDidntFinish = task.status == 'didnt_finish';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.black.withOpacity(0.05)
            : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? AppTheme.black.withOpacity(0.2)
              : isDidntFinish
                  ? AppTheme.lightGray.withOpacity(0.4)
                  : AppTheme.lightGray.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? AppTheme.black
                  : isDidntFinish
                      ? AppTheme.lightGray
                      : Colors.transparent,
              border: Border.all(
                color: isCompleted
                    ? AppTheme.black
                    : isDidntFinish
                        ? AppTheme.lightGray
                        : AppTheme.mediumGray,
                width: 1.5,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Task text
          Expanded(
            child: Text(
              task.task,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDidntFinish ? AppTheme.lightGray : AppTheme.black,
                decoration: isDidntFinish
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // PENDING — checkmark + postpone buttons
          if (isPending) ...[
            GestureDetector(
              onTap: () => _showCompletionDialog(context),
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppTheme.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.white,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDidntFinish,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightGray,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.pause,
                  color: AppTheme.mediumGray,
                  size: 16,
                ),
              ),
            ),
          ],

          // ACHIEVED — same style as postponed but black
          if (isCompleted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.black,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppTheme.black,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Achieved',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),

          // POSTPONED — gray circle + label
          if (isDidntFinish)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightGray,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: AppTheme.lightGray,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Postponed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightGray,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
