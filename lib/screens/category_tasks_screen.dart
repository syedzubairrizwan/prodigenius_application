import 'package:flutter/material.dart';
import 'package:prodigenius_application/models/task_category.dart';
import 'package:prodigenius_application/services/hive_service.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryTasksScreen extends StatelessWidget {
  final TaskCategory category;

  const CategoryTasksScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: category.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          category.displayName,
          style: textTheme.titleLarge?.copyWith(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: HiveService.getTasksListenable(),
        builder: (context, taskBox, _) {
          final allTasks = taskBox.values.toList();
          final tasks =
              allTasks.where((t) => t.category == category).toList();
          final completed = tasks.where((t) => t.isCompleted).length;
          final pending = tasks.where((t) => !t.isCompleted).length;
          final total = tasks.length;
          final percent = total == 0 ? 0.0 : completed / total;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have $total tasks',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$completed completed, $pending pending',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percent,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(percent * 100).toStringAsFixed(0)}%',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.purpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks for this category.',
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Dismissible(
                            key: Key(task.id!), // Assuming task.id is never null from Hive
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (_) {
                              if (task.id != null) {
                                HiveService.deleteTask(task.id!);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: _PriorityIndicator(
                                  priority: task.priority,
                                  letAIDecide: task.letAIDecide,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task.taskName ?? '',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (task.letAIDecide)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.smart_toy,
                                              size: 14,
                                              color: Colors.deepPurple,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              'AI',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task.description != null &&
                                        task.description!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 2.0,
                                        ),
                                        child: Text(
                                          task.description!,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      task.date != null
                                          ? '${task.date!.day} ${_monthName(task.date!.month)}'
                                          : '',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    if (task.id != null) {
                                      final updatedTask = Task(
                                        id: task.id,
                                        taskName: task.taskName,
                                        description: task.description,
                                        date: task.date,
                                        categoryName: task.categoryName,
                                        priority: task.priority,
                                        letAIDecide: task.letAIDecide,
                                        getAlerts: task.getAlerts,
                                        isCompleted: !task.isCompleted,
                                      );
                                      HiveService.updateTask(task.id!, updatedTask);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: task.isCompleted
                                          ? Colors.purpleAccent
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.purpleAccent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      task.isCompleted
                                          ? Icons.check
                                          : Icons.radio_button_unchecked,
                                      color: task.isCompleted
                                          ? Colors.white
                                          : Colors.purpleAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}

class _PriorityIndicator extends StatelessWidget {
  final String? priority;
  final bool letAIDecide;
  const _PriorityIndicator({required this.priority, required this.letAIDecide});

  Color get _color {
    if (letAIDecide) return Colors.deepPurple;
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 40,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
