import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prodigenius_application/cubit/task_cubit.dart';
import 'package:prodigenius_application/cubit/task_state.dart';
import 'package:prodigenius_application/models/task_category.dart';
import 'package:prodigenius_application/widgets/constant.dart';
import 'package:prodigenius_application/screens/category_tasks_screen.dart';

class Tasks extends StatelessWidget {
  final void Function(TaskCategory category)? onCategoryTap;

  const Tasks({super.key, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.hasError) {
          return Center(
            child: SelectableText.rich(
              TextSpan(
                text: 'Error: ',
                style: const TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                    text: state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        }

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
                  state.tasks.where((t) => t.category == category).toList();
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
