
import 'package:todo_list_challenge/features/todo/data/datasources/task_local_datasource.dart';
import 'package:todo_list_challenge/features/todo/data/models/task_model.dart';
import 'package:todo_list_challenge/features/todo/domain/entities/task.dart';
import 'package:todo_list_challenge/features/todo/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasks() async {
    final taskModels = await localDataSource.getTasks();
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