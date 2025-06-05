
import 'package:todo_list_challenge/features/task/data/datasources/task_local_datasource.dart';
import 'package:todo_list_challenge/features/task/data/models/task_model.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final TaskLocalDataSource localDataSource;

  CalendarRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasksForMonth(DateTime month) async {
    final taskModels = await localDataSource.getTasksForMonth(month);
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final taskModels = await localDataSource.getTasksForDate(date);
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.addTask(taskModel);
    return task;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
    return task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }
}