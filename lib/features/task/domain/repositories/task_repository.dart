
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<List<Task>> getTasksForMonth(DateTime month);
  Future<List<Task>> getTasksForDate(DateTime date);
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}
