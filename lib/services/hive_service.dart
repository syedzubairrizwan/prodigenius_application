import 'package:flutter/foundation.dart'; // Required for ValueListenable
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prodigenius_application/models/Task_modal.dart'; // Adjust path if necessary

class HiveService {
  static const String _taskBoxName = 'tasks';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>(_taskBoxName);
  }

  static Box<Task> getTaskBox() {
    return Hive.box<Task>(_taskBoxName);
  }

  static ValueListenable<Box<Task>> getTasksListenable() {
    return getTaskBox().listenable();
  }

  static List<Task> getTasks() {
    return getTaskBox().values.toList();
  }

  static Future<void> addTask(Task task) async {
    final box = getTaskBox();
    // Ensure task.id is set, as it's used as the Hive key.
    // The Task model currently allows id to be null.
    // If task.id is not set by the caller, consider generating one here,
    // or ensure the caller always provides a unique ID.
    // For this implementation, we'll assume task.id is provided and unique.
    if (task.id == null || task.id!.isEmpty) {
      // Or throw an error, depending on desired behavior
      task.id = DateTime.now().millisecondsSinceEpoch.toString();
    }
    await box.put(task.id!, task);
  }

  static Future<void> updateTask(String id, Task task) async {
    final box = getTaskBox();
    // Ensure the task object being saved also has its id field matching the key.
    task.id = id;
    await box.put(id, task);
  }

  static Future<void> deleteTask(String id) async {
    final box = getTaskBox();
    await box.delete(id);
  }

  static Future<void> clearAllTasks() async {
    final box = getTaskBox();
    await box.clear();
  }
}
