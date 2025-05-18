import 'package:flutter/foundation.dart';
import 'package:prodigenius_application/models/task_modal.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = <Task>[];

  List<Task> get tasks => _tasks;

  void addTask(Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
