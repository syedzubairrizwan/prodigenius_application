// lib/models/task_priority.dart

// Enum for user-defined priority
enum UserPriority {
  low,
  medium,
  high,
}

// Extension to get numerical score for UserPriority
extension UserPriorityScore on UserPriority {
  int get score {
    switch (this) {
      case UserPriority.high:
        return 3;
      case UserPriority.medium:
        return 2;
      case UserPriority.low:
        return 1;
      default:
        return 0; // Should not happen
    }
  }
}

// Helper function to parse UserPriority from String
UserPriority? userPriorityFromString(String? priorityString) {
  if (priorityString == null) return null;
  switch (priorityString.toLowerCase()) {
    case 'high':
      return UserPriority.high;
    case 'medium':
      return UserPriority.medium;
    case 'low':
      return UserPriority.low;
    default:
      return null; // Or a default value like UserPriority.medium
  }
}


// Enum for urgency based on due date
enum Urgency {
  low,
  medium,
  high,
  veryHigh,
}

// Extension to get numerical score for Urgency
extension UrgencyScore on Urgency {
  int get score {
    switch (this) {
      case Urgency.veryHigh:
        return 4;
      case Urgency.high:
        return 3;
      case Urgency.medium:
        return 2;
      case Urgency.low:
        return 1;
      default:
        return 0; // Should not happen
    }
  }
}

// Class to hold the different scores for a task
class TaskCalculatedPriority {
  final UserPriority? userPriority;
  final Urgency urgency;
  final int finalScore;
  final String taskId; // To link back to the original task

  TaskCalculatedPriority({
    required this.taskId,
    this.userPriority,
    required this.urgency,
    required this.finalScore,
  });
}
