import 'package:todo_list_challenge/features/task/domain/entities/task.dart';

abstract class CalendarRepository {
  Future<List<Task>> getTasksForMonth(DateTime month);
  Future<List<Task>> getTasksForDate(DateTime date);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String taskId);
}