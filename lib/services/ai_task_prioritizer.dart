// lib/services/ai_task_prioritizer.dart

// For date comparison
import 'package:prodigenius_application/models/Task_modal.dart'; // Assuming Task model path
import 'package:prodigenius_application/models/task_priority.dart';

class AITaskPrioritizer {
  // Weights for combining scores
  final int _urgencyWeight = 2;
  final int _userPriorityWeight = 1;

  Urgency calculateUrgency(DateTime? dueDate) {
    if (dueDate == null) {
      return Urgency.low; // Default urgency if no due date
    }

    final now = DateTime.now();
    // Normalize dates to midnight to compare day differences accurately
    final normalizedDueDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final normalizedNow = DateTime(now.year, now.month, now.day);
    
    final difference = normalizedDueDate.difference(normalizedNow).inDays;

    if (difference < 0) { // Overdue
      return Urgency.veryHigh;
    } else if (difference < 1) { // Due today
      return Urgency.veryHigh;
    } else if (difference < 3) { // Due in 1-2 days
      return Urgency.high;
    } else if (difference < 7) { // Due in 3-6 days
      return Urgency.medium;
    } else { // Due in 7+ days
      return Urgency.low;
    }
  }

  UserPriority? _parseUserPriority(String? priorityString) {
    return userPriorityFromString(priorityString);
  }

  List<Task> prioritizeTasks(List<Task> tasks) {
    if (tasks.isEmpty) {
      return [];
    }

    List<Task> aiPrioritizedTasks = [];
    List<Task> manualTasks = [];
    List<Map<String, dynamic>> scoredAiTasks = [];

    for (var task in tasks) {
      if (task.isCompleted) {
        // Skip completed tasks for prioritization, but keep them if needed elsewhere
        // For now, we'll exclude them from the sorted list.
        // If they need to be at the very end, this logic would change.
        continue; 
      }

      if (task.letAIDecide == true && task.id != null) {
        final urgency = calculateUrgency(task.date);
        final userPriority = _parseUserPriority(task.priority);
        
        int finalScore = (urgency.score * _urgencyWeight);
        if (userPriority != null) {
          finalScore += (userPriority.score * _userPriorityWeight);
        }
        
        scoredAiTasks.add({
          'task': task,
          'score': finalScore,
          'urgency': urgency, // For potential secondary sort or display
          'dueDate': task.date ?? DateTime.now().add(Duration(days: 365)) // for sorting if date is null
        });
      } else {
        manualTasks.add(task);
      }
    }

    // Sort AI-prioritized tasks: by score (desc), then by urgency (desc), then by due date (asc)
    scoredAiTasks.sort((a, b) {
      int scoreComparison = b['score'].compareTo(a['score']);
      if (scoreComparison != 0) {
        return scoreComparison;
      }
      // If scores are equal, compare by urgency (higher urgency first)
      int urgencyComparison = (b['urgency'] as Urgency).score.compareTo((a['urgency'] as Urgency).score);
      if (urgencyComparison != 0) {
        return urgencyComparison;
      }
      // If urgency is also equal, sort by due date (earlier due date first)
      return (a['dueDate'] as DateTime).compareTo(b['dueDate'] as DateTime);
    });

    aiPrioritizedTasks = scoredAiTasks.map((e) => e['task'] as Task).toList();

    // Sort manual tasks by due date (earlier first)
    manualTasks.sort((a, b) {
      final dateA = a.date ?? DateTime.now().add(Duration(days: 365));
      final dateB = b.date ?? DateTime.now().add(Duration(days: 365));
      return dateA.compareTo(dateB);
    });

    // Combine lists: AI prioritized tasks first, then manual tasks
    return [...aiPrioritizedTasks, ...manualTasks];
  }
}
