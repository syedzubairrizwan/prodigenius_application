// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
//import 'package:prodigenius_application/models/task_category.dart';
import 'package:prodigenius_application/models/Task_modal.dart';
//import 'package:prodigenius_application/cubit/task_state.dart';
import 'package:prodigenius_application/services/hive_service.dart';

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
  String _selectedPriority = 'Medium';
  bool _letAIDecide = false;
  bool _getAlerts = false;

  final List<String> _categoryOptions = ['Personal', 'Work', 'Study'];
  final List<String> _priorityOptions = ['High', 'Medium', 'Low'];

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
        selectedPriority: _selectedPriority,
        priorityOptions: _priorityOptions,
        onDateChanged: (date) => setState(() => _selectedDate = date),
        onCategoryChanged:
            (category) => setState(() => _selectedCategory = category),
        onPriorityChanged:
            (priority) => setState(() => _selectedPriority = priority),
        letAIDecide: _letAIDecide,
        onAIDecideChanged: (value) => setState(() => _letAIDecide = value),
        getAlerts: _getAlerts,
        onGetAlertsChanged: (value) => setState(() => _getAlerts = value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: colorScheme.secondary)),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                taskName: _titleController.text,
                description: _descriptionController.text,
                date: _selectedDate,
                categoryName: _selectedCategory.toLowerCase(),
                priority: _letAIDecide ? null : _selectedPriority,
                letAIDecide: _letAIDecide,
                getAlerts: _getAlerts,
                isCompleted: false, // New tasks are not completed by default
              );
              HiveService.addTask(newTask);
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
    required this.selectedPriority,
    required this.priorityOptions,
    required this.onDateChanged,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
    required this.letAIDecide,
    required this.onAIDecideChanged,
    required this.getAlerts,
    required this.onGetAlertsChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime selectedDate;
  final String selectedCategory;
  final List<String> categoryOptions;
  final String selectedPriority;
  final List<String> priorityOptions;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onPriorityChanged;
  final bool letAIDecide;
  final ValueChanged<bool> onAIDecideChanged;
  final bool getAlerts;
  final ValueChanged<bool> onGetAlertsChanged;

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
            const SizedBox(height: 16),
            Text('Priority:', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            _PriorityPicker(
              selectedPriority: selectedPriority,
              priorityOptions: priorityOptions,
              onPriorityChanged: onPriorityChanged,
              letAIDecide: letAIDecide,
              onAIDecideChanged: onAIDecideChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(value: getAlerts, onChanged: onGetAlertsChanged),
                const SizedBox(width: 8),
                Text('Get Alerts', style: textTheme.bodyMedium),
              ],
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

class _PriorityPicker extends StatelessWidget {
  const _PriorityPicker({
    required this.selectedPriority,
    required this.priorityOptions,
    required this.onPriorityChanged,
    required this.letAIDecide,
    required this.onAIDecideChanged,
  });

  final String selectedPriority;
  final List<String> priorityOptions;
  final ValueChanged<String> onPriorityChanged;
  final bool letAIDecide;
  final ValueChanged<bool> onAIDecideChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children:
              priorityOptions.map((priority) {
                final bool isSelected = selectedPriority == priority;
                return ChoiceChip(
                  label: Text(priority),
                  selected: isSelected && !letAIDecide,
                  onSelected: (selected) {
                    if (selected) {
                      onPriorityChanged(priority);
                    }
                  },
                  selectedColor: colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color:
                        isSelected && !letAIDecide
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color:
                          isSelected && !letAIDecide
                              ? colorScheme.primary
                              : colorScheme.outline,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Switch(value: letAIDecide, onChanged: onAIDecideChanged),
            const SizedBox(width: 8),
            Text('Let AI decide priority', style: textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
