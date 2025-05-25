// lib/widgets/ai.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:prodigenius_application/models/Task_modal.dart';
import 'package:prodigenius_application/services/hive_service.dart';
import 'package:prodigenius_application/services/ai_task_prioritizer.dart';
import 'package:prodigenius_application/models/task_priority.dart'; // For Urgency enum access if needed for display

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final AITaskPrioritizer _prioritizer = AITaskPrioritizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Added Scaffold for better structure
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: HiveService.getTasksListenable(),
        builder: (context, taskBox, _) {
          final allTasks = taskBox.values.toList();
          final prioritizedTasks = _prioritizer.prioritizeTasks(allTasks);

          if (prioritizedTasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks to prioritize or all tasks are completed.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: prioritizedTasks.length,
            itemBuilder: (context, index) {
              final task = prioritizedTasks[index];
              return _TaskListItem(task: task, prioritizer: _prioritizer);
            },
          );
        },
      ),
    );
  }
}

// Simple List Item Widget to display task details
class _TaskListItem extends StatelessWidget {
  final Task task;
  final AITaskPrioritizer prioritizer; // To access calculateUrgency for display

  const _TaskListItem({required this.task, required this.prioritizer});

  String _formatDueDate(DateTime? date) {
    if (date == null) {
      return 'No due date';
    }
    return DateFormat.yMMMd().add_jm().format(date); // Example: Sep 20, 2023, 5:30 PM
  }

  String _getUrgencyText(DateTime? date) {
    final urgency = prioritizer.calculateUrgency(date);
    switch (urgency) {
      case Urgency.veryHigh:
        return 'Very High Urgency';
      case Urgency.high:
        return 'High Urgency';
      case Urgency.medium:
        return 'Medium Urgency';
      case Urgency.low:
        return 'Low Urgency';
      default:
        return 'Standard Urgency';
    }
  }

  Color _getUrgencyColor(DateTime? date) {
    final urgency = prioritizer.calculateUrgency(date);
    switch (urgency) {
      case Urgency.veryHigh:
        return Colors.red.shade700;
      case Urgency.high:
        return Colors.orange.shade700;
      case Urgency.medium:
        return Colors.blue.shade700;
      case Urgency.low:
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }
  
  String _getUserPriorityText(String? priority) {
    if (priority == null || priority.isEmpty) return "N/A";
    return priority;
  }

  @override
  Widget build(BuildContext context) {
    final urgencyText = _getUrgencyText(task.date);
    final urgencyColor = _getUrgencyColor(task.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 3.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          task.taskName ?? 'Untitled Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              task.description ?? 'No description',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Due: ${_formatDueDate(task.date)}',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            Text(
              'User Priority: ${_getUserPriorityText(task.priority)}',
              style: TextStyle(fontSize: 14),
            ),
            if (task.letAIDecide == true) ...[
              const SizedBox(height: 4),
              Text(
                'AI Status: $urgencyText',
                style: TextStyle(fontSize: 14, color: urgencyColor, fontWeight: FontWeight.w500),
              ),
            ] else ...[
              const SizedBox(height: 4),
              Text(
                'AI Status: Prioritization by AI disabled',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        isThreeLine: true, // Adjust based on content
        trailing: task.isCompleted
            ? Icon(Icons.check_circle, color: Colors.green, size: 30)
            : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 30),
        onTap: () {
          // Optional: Implement navigation to a task detail page or edit task
          // For now, tapping does nothing.
        },
      ),
    );
  }
}
