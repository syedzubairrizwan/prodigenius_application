//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prodigenius_application/widgets/constant.dart';

enum TaskCategory {
  personal,
  work,
  study;

  String toJson() => name;
  static TaskCategory fromJson(String json) => values.byName(json);

  String get displayName {
    switch (this) {
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.study:
        return 'Study';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.personal:
        return Icons.person_rounded;
      case TaskCategory.work:
        return Icons.work_rounded;
      case TaskCategory.study:
        return Icons.book_rounded;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TaskCategory.personal:
        return kBlue;
      case TaskCategory.work:
        return kYellowLight;
      case TaskCategory.study:
        return kRedLight;
    }
  }

  Color get iconColor {
    switch (this) {
      case TaskCategory.personal:
        return kBlueDark;
      case TaskCategory.work:
        return kYellowDark;
      case TaskCategory.study:
        return kRedDark;
    }
  }

  Color get buttonColor {
    switch (this) {
      case TaskCategory.personal:
        return kBlueLight;
      case TaskCategory.work:
        return kYellow;
      case TaskCategory.study:
        return kRed;
    }
  }
}

// Define your color constants here or import them if they are in another file
// For example, if they are in 'package:prodigenius_application/widgets/constant.dart'
// you would add: import 'package:prodigenius_application/widgets/constant.dart';
// Make sure these constants (kBlue, kYellowLight, kRedLight, kBlueDark, kBlueLight) are accessible.

const Color kBlue = Color(0xFF2196F3); // Example
const Color kBlueDark = Color(0xFF1976D2); // Example
const Color kBlueLight = Color(0xFF64B5F6); // Example
const Color kYellowLight = Color(0xFFFFEB3B); // Example
const Color kRedLight = Color(0xFFE57373); // Example
 
 