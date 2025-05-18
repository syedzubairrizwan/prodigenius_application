// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:prodigenius_application/models/task_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
//import 'package:prodigenius_application/cubit/task_state.dart';
import 'package:prodigenius_application/cubit/task_cubit.dart';

class AddTaskDialog extends StatefulWidget {
  final DateTime selectedDate;

  const AddTaskDialog({super.key, required this.selectedDate});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  String _selectedCategory = 'Personal';

  final List<String> _categoryOptions = ['Personal', 'Work', 'Study'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text('Add New Task', style: textTheme.titleLarge),
      content: _TaskFormContent(
        formKey: _formKey,
        titleController: _titleController,
        descriptionController: _descriptionController,
        selectedDate: _selectedDate,
        selectedCategory: _selectedCategory,
        categoryOptions: _categoryOptions,
        onDateChanged: (date) => setState(() => _selectedDate = date),
        onCategoryChanged:
            (category) => setState(() => _selectedCategory = category),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: colorScheme.secondary)),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<TaskCubit>().addTask(
                Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  taskName: _titleController.text,
                  description: _descriptionController.text,
                  date: _selectedDate,
                  category: TaskCategory.fromJson(
                    _selectedCategory.toLowerCase(),
                  ),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Add', style: TextStyle(color: colorScheme.primary)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class _TaskFormContent extends StatelessWidget {
  const _TaskFormContent({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDate,
    required this.selectedCategory,
    required this.categoryOptions,
    required this.onDateChanged,
    required this.onCategoryChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime selectedDate;
  final String selectedCategory;
  final List<String> categoryOptions;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Date: ', style: textTheme.titleMedium),
                TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      onDateChanged(picked);
                    }
                  },
                  child: Text(
                    '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Category:', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            _CategoryPicker(
              selectedCategory: selectedCategory,
              categoryOptions: categoryOptions,
              onCategoryChanged: onCategoryChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.selectedCategory,
    required this.categoryOptions,
    required this.onCategoryChanged,
  });

  final String selectedCategory;
  final List<String> categoryOptions;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children:
          categoryOptions.map((category) {
            final bool isSelected = selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategoryChanged(category);
                }
              },
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color:
                    isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                ),
              ),
            );
          }).toList(),
    );
  }
}
