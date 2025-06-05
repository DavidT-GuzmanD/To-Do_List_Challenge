import 'package:flutter/material.dart';

enum TaskPriority {
  high,
  medium,
  low;

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
}