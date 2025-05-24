import 'package:flutter/material.dart';
import 'package:prodigenius_application/models/task_category.dart';
import 'package:prodigenius_application/widgets/constant.dart';
import 'package:prodigenius_application/screens/category_tasks_screen.dart';
import 'package:prodigenius_application/services/hive_service.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Tasks extends StatelessWidget {
  final void Function(TaskCategory category)? onCategoryTap;

  const Tasks({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Task>>(
      valueListenable: HiveService.getTasksListenable(),
      builder: (context, taskBox, _) {
        final allTasks = taskBox.values.toList();

        // The loading and error states previously handled by BlocState
        // are not directly available here in the same way.
        // UI should gracefully handle an empty list if tasks are loading or none exist.

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: TaskCategory.values.length,
            itemBuilder: (context, index) {
              final category = TaskCategory.values[index];
              final tasksForCategory =
                  allTasks.where((t) => t.category == category).toList();
              final left = tasksForCategory.where((t) => !t.isCompleted).length;
              final done = tasksForCategory.where((t) => t.isCompleted).length;

              return _CategoryCard(
                category: category,
                left: left,
                done: done,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // CategoryTasksScreen will also need to be updated
                      // to accept allTasks or use HiveService directly.
                      // For now, this navigation part remains, but we'll address
                      // CategoryTasksScreen in the next step.
                      builder: (_) => CategoryTasksScreen(category: category),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final TaskCategory category;
  final int left;
  final int done;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    required this.left,
    required this.done,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: category.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(category.icon, color: category.iconColor, size: 30),
            const SizedBox(height: 30),
            Text(
              category.displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _TaskStatusBadge(
                  backgroundColor: category.buttonColor,
                  textColor: category.iconColor,
                  text: '$left left',
                ),
                const SizedBox(width: 5),
                _TaskStatusBadge(
                  backgroundColor: kWhite,
                  textColor: category.iconColor,
                  text: '$done done',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;

  const _TaskStatusBadge({
    required this.backgroundColor,
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
