import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
import 'package:prodigenius_application/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState.initial());

  void addTask(Task task) {
    emit(state.copyWith(tasks: List.of(state.tasks)..add(task)));
  }

  void toggleTaskCompletion(String id) {
    emit(
      state.copyWith(
        tasks:
            state.tasks.map((task) {
              if (task.id == id) {
                return Task(
                  id: task.id,
                  category: task.category,
                  taskName: task.taskName,
                  description: task.description,
                  date: task.date,
                  isCompleted: !task.isCompleted,
                  priority: task.priority,
                  letAIDecide: task.letAIDecide,
                  getAlerts: task.getAlerts,
                );
              }
              return task;
            }).toList(),
      ),
    );
  }

  void clearTasks() {
    emit(state.copyWith(tasks: []));
  }
}
