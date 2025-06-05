import 'package:equatable/equatable.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task_priority.dart';


class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final DateTime? dueTime;
  final TaskPriority priority;
  final String? category;
  final String? icon;
  final bool isCompleted;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.dueTime,
    required this.priority,
    this.category,
    this.icon,
    this.isCompleted = false,
    required this.createdAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? dueTime,
    TaskPriority? priority,
    String? category,
    String? icon,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        dueTime,
        priority,
        category,
        icon,
        isCompleted,
        createdAt,
      ];
}