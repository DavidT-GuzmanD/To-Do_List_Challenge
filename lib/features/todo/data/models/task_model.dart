import 'package:isar/isar.dart';
import 'package:todo_list_challenge/features/todo/domain/entities/task.dart';

part 'task_model.g.dart';

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String taskId;
  
  late String title;
  String? description;
  late DateTime dueDate;
  DateTime? dueTime;
  
  @enumerated
  late TaskPriority priority;
  
  String? category;
  String? icon;
  late bool isCompleted;
  late DateTime createdAt;

  TaskModel();

  TaskModel.fromEntity(Task task) {
    taskId = task.id;
    title = task.title;
    description = task.description;
    dueDate = task.dueDate;
    dueTime = task.dueTime;
    priority = task.priority;
    category = task.category;
    icon = task.icon;
    isCompleted = task.isCompleted;
    createdAt = task.createdAt;
  }

  Task toEntity() {
    return Task(
      id: taskId,
      title: title,
      description: description,
      dueDate: dueDate,
      dueTime: dueTime,
      priority: priority,
      category: category,
      icon: icon,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}
