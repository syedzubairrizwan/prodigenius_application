// test/services/ai_task_prioritizer_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
import 'package:prodigenius_application/models/task_priority.dart';
import 'package:prodigenius_application/services/ai_task_prioritizer.dart';

void main() {
  group('AITaskPrioritizer Tests', () {
    late AITaskPrioritizer prioritizer;
    final now = DateTime.now();

    setUp(() {
      prioritizer = AITaskPrioritizer();
    });

    // Helper to create tasks
    Task createTask({
      required String id,
      DateTime? dueDate,
      String? userPriority,
      bool isCompleted = false,
      bool letAIDecide = true,
      String taskName = 'Test Task',
    }) {
      return Task(
        id: id,
        taskName: taskName,
        date: dueDate,
        priority: userPriority,
        isCompleted: isCompleted,
        letAIDecide: letAIDecide,
      );
    }

    group('calculateUrgency', () {
      test('should return veryHigh for overdue tasks', () {
        final dueDate = now.subtract(const Duration(days: 1));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.veryHigh);
      });

      test('should return veryHigh for tasks due today', () {
        final dueDate = now; // Or DateTime(now.year, now.month, now.day, 23, 59)
        expect(prioritizer.calculateUrgency(dueDate), Urgency.veryHigh);
      });

      test('should return high for tasks due in 1-2 days (e.g., tomorrow)', () {
        final dueDate = now.add(const Duration(days: 1));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.high);
      });

      test('should return high for tasks due in < 3 days (e.g., 2 days)', () {
        final dueDate = now.add(const Duration(days: 2));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.high);
      });
      
      test('should return medium for tasks due in 3-6 days (e.g., 3 days)', () {
        final dueDate = now.add(const Duration(days: 3));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.medium);
      });

      test('should return medium for tasks due in < 7 days (e.g., 6 days)', () {
        final dueDate = now.add(const Duration(days: 6));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.medium);
      });

      test('should return low for tasks due in 7+ days', () {
        final dueDate = now.add(const Duration(days: 7));
        expect(prioritizer.calculateUrgency(dueDate), Urgency.low);
      });

      test('should return low for tasks with no due date', () {
        expect(prioritizer.calculateUrgency(null), Urgency.low);
      });
    });

    group('prioritizeTasks', () {
      test('should return empty list if input is empty', () {
        expect(prioritizer.prioritizeTasks([]), isEmpty);
      });

      test('should filter out completed tasks', () {
        final tasks = [
          createTask(id: '1', isCompleted: true, dueDate: now),
        ];
        expect(prioritizer.prioritizeTasks(tasks), isEmpty);
      });

      test('AI-decided tasks should be prioritized higher than manual tasks', () {
        final tasks = [
          createTask(id: 'manual1', letAIDecide: false, dueDate: now.add(const Duration(days: 1))), // Manual, due tomorrow
          createTask(id: 'ai1', letAIDecide: true, dueDate: now.add(const Duration(days: 7))),     // AI, due next week (low urgency)
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.length, 2);
        expect(prioritized.first.id, 'ai1');
        expect(prioritized.last.id, 'manual1');
      });

      test('should prioritize tasks with higher urgency and priority score', () {
        // Task 1: AI, Due Today (VH Urgency=4), High User Priority (Score=3) -> Total = 4*2 + 3*1 = 11
        // Task 2: AI, Due in 5 days (M Urgency=2), Medium User Priority (Score=2) -> Total = 2*2 + 2*1 = 6
        // Task 3: AI, Due in 10 days (L Urgency=1), High User Priority (Score=3) -> Total = 1*2 + 3*1 = 5
        final tasks = [
          createTask(id: 'task2', dueDate: now.add(const Duration(days: 5)), userPriority: 'Medium'),
          createTask(id: 'task3', dueDate: now.add(const Duration(days: 10)), userPriority: 'High'),
          createTask(id: 'task1', dueDate: now, userPriority: 'High'),
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.map((t) => t.id).toList(), ['task1', 'task2', 'task3']);
      });
      
      test('secondary sort by urgency score if final scores are equal', () {
        // Task 1: AI, Due Today (VH Urgency=4), Low User Priority (Score=1) -> Total = 4*2 + 1*1 = 9
        // Task 2: AI, Due in 2 days (H Urgency=3), High User Priority (Score=3) -> Total = 3*2 + 3*1 = 9
        // Task 1 should come before Task 2 because it has higher urgency.
        final tasks = [
          createTask(id: 'task2', dueDate: now.add(Duration(days: 2)), userPriority: 'High'),
          createTask(id: 'task1', dueDate: now, userPriority: 'Low'),
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.map((t) => t.id).toList(), ['task1', 'task2']);
      });

      test('tertiary sort by due date if final scores and urgency are equal', () {
        // Task 1: AI, Due Today (VH Urgency=4), Low User Priority (Score=1) -> Total = 4*2 + 1*1 = 9
        // Task 2: AI, Due Tomorrow (but normalized to today for this test, effectively same urgency score for VH), Low User Priority (Score=1) -> Total = 4*2 + 1*1 = 9
        // Task 1 (due sooner) should come before Task 2.
        // Note: The current calculateUrgency makes both "VeryHigh".
        // To make them truly same urgency but different dates, we'd need a more granular urgency or adjust test.
        // Let's test with same score, same urgency, different due dates.
        // Task A: Score 9 (Urgency VH=4, Prio Low=1), Due: now
        // Task B: Score 9 (Urgency VH=4, Prio Low=1), Due: now.subtract(Duration(hours:1)) (earlier today)
        // Task B should come first
         final tasks = [
          createTask(id: 'taskA', dueDate: now, userPriority: 'Low'), // Due now
          createTask(id: 'taskB', dueDate: now.subtract(Duration(hours:1)), userPriority: 'Low'), // Due 1h ago
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.map((t) => t.id).toList(), ['taskB', 'taskA']);
      });


      test('manual tasks should be sorted by due date', () {
        final tasks = [
          createTask(id: 'manual2', letAIDecide: false, dueDate: now.add(const Duration(days: 5))),
          createTask(id: 'manual1', letAIDecide: false, dueDate: now.add(const Duration(days: 1))),
          createTask(id: 'ai1', letAIDecide: true, dueDate: now.add(const Duration(days: 10))), // AI task to ensure separation
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        // Expect ai1 first, then manual1, then manual2
        expect(prioritized.map((t) => t.id).toList(), ['ai1', 'manual1', 'manual2']);
      });

      test('tasks with null due dates for AI should use default low urgency', () {
        // AI Task with null date (Urgency Low=1), High Prio (3) -> 1*2 + 3*1 = 5
        // AI Task due today (Urgency VH=4), Low Prio (1) -> 4*2 + 1*1 = 9
        final tasks = [
          createTask(id: 'nullDateTask', dueDate: null, userPriority: 'High'),
          createTask(id: 'urgentTask', dueDate: now, userPriority: 'Low'),
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.map((t) => t.id).toList(), ['urgentTask', 'nullDateTask']);
      });
      
      test('tasks with null user priority for AI should only use urgency score', () {
        // AI Task, Due Today (VH Urgency=4), Null User Priority -> Total = 4*2 + 0 = 8
        // AI Task, Due in 10 days (L Urgency=1), High User Priority (Score=3) -> Total = 1*2 + 3*1 = 5
        final tasks = [
          createTask(id: 'lowUrgencyHighPrio', dueDate: now.add(const Duration(days: 10)), userPriority: 'High'),
          createTask(id: 'highUrgencyNullPrio', dueDate: now, userPriority: null),
        ];
        final prioritized = prioritizer.prioritizeTasks(tasks);
        expect(prioritized.map((t) => t.id).toList(), ['highUrgencyNullPrio', 'lowUrgencyHighPrio']);
      });
    });
  });
}
