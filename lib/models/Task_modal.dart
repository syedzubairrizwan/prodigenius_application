import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:prodigenius_application/models/task_category.dart';
// import 'package:prodigenius_application/widgets/constant.dart'; // No longer needed here directly if colors are sourced via TaskCategory

part 'Task_modal.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String? id; // Keep for potential database use

  @HiveField(1)
  String? taskName; // name of the task entered by user

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? date;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  String? priority; // High, Medium, Low

  @HiveField(6)
  bool letAIDecide;

  @HiveField(7)
  bool getAlerts;

  @HiveField(8)
  String? categoryName;

  // Properties derived from category, no longer stored directly
  // IconData? icon;
  // Color? bgcolor;
  // Color? iconcolor;
  // Color? btncolor;

  Task({
    this.id,
    this.categoryName,
    this.taskName,
    this.description,
    this.date,
    this.isCompleted = false,
    this.priority,
    this.letAIDecide = false,
    this.getAlerts = false,
  });

  // Getter for category
  TaskCategory? get category {
    if (categoryName == null) {
      return null;
    }
    return TaskCategory.fromJson(categoryName!);
  }

  // Getter for icon based on category
  IconData? get icon => category?.icon;

  // Getter for background color based on category
  Color? get backgroundColor => category?.backgroundColor;

  // Getter for icon color based on category
  Color? get iconColor => category?.iconColor;

  // Getter for button color based on category
  Color? get buttonColor => category?.buttonColor;
}
