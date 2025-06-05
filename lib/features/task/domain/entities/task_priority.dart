import 'package:flutter/material.dart';

enum TaskPriority {
  high(1),
  medium(2),
  low(3);

  final int value;

  const TaskPriority(this.value);

  String get displayName {
    switch (this) {
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.low:
        return 'Baja';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  static TaskPriority fromValue(int value) {
    switch (value) {
      case 1:
        return TaskPriority.high;
      case 2:
        return TaskPriority.medium;
      case 3:
        return TaskPriority.low;
      default:
        throw ArgumentError('Invalid priority value: $value');
    }
  }
}