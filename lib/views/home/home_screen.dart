import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_theme.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../../viewmodels/quote_viewmodel.dart';
import '../widgets/progress_ring.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getDayName() {
    final days = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[DateTime.now().weekday - 1];
  }

  String _getDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final counts = ref.watch(taskCountsProvider);
    final quoteState = ref.watch(quoteViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDayName(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        _getDate(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Progress ring
              Center(
                child: ProgressRing(progress: progress, size: 220),
              ),

              const SizedBox(height: 28),

              // Stat chips — only when tasks exist
              if (counts['total']! > 0)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(
                        label: '${counts['completed']}',
                        sublabel: 'done',
                        filled: true,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: '${counts['pending']}',
                        sublabel: 'left',
                        filled: false,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        label: '${counts['total']}',
                        sublabel: 'total',
                        filled: false,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              // Quote box with source attribution
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightGray.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    key: ValueKey(quoteState.quote),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quoteState.quote,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.darkGray,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '— ${quoteState.source}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.lightGray,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool filled;

  const _StatChip({
    required this.label,
    required this.sublabel,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppTheme.black : AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled
              ? AppTheme.black
              : AppTheme.lightGray.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: filled ? AppTheme.white : AppTheme.black,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            sublabel,
            style: TextStyle(
              fontSize: 11,
              color: filled
                  ? AppTheme.white.withOpacity(0.7)
                  : AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}