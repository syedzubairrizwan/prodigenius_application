import 'package:flutter/material.dart';
import 'package:prodigenius_application/models/task_category.dart';
// import 'package:prodigenius_application/widgets/constant.dart'; // No longer needed here directly if colors are sourced via TaskCategory

class Task {
  String? id; // Keep for potential database use
  TaskCategory? category;
  String? taskName; // name of the task entered by user
  DateTime? date;
  String? description;
  bool isCompleted;
  String? priority; // High, Medium, Low
  bool letAIDecide;

  // Properties derived from category, no longer stored directly
  // IconData? icon;
  // Color? bgcolor;
  // Color? iconcolor;
  // Color? btncolor;

  Task({
    this.id,
    this.category,
    this.taskName,
    this.description,
    this.date,
    this.isCompleted = false,
    this.priority,
    this.letAIDecide = false,
  });

  // Getter for icon based on category
  IconData? get icon => category?.icon;

  // Getter for background color based on category
  Color? get backgroundColor => category?.backgroundColor;

  // Getter for icon color based on category
  Color? get iconColor => category?.iconColor;

  // Getter for button color based on category
  Color? get buttonColor => category?.buttonColor;
}
