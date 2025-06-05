
import 'package:todo_list_challenge/features/task/data/datasources/task_local_datasource.dart';
import 'package:todo_list_challenge/features/task/data/models/task_model.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() async {
    final taskModels = await localDataSource.getTasks();
    return taskModels.map((model) => model.toEntity()).toList();
  }

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
  Future<void> addTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.addTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await localDataSource.deleteTask(taskId);
  }
}