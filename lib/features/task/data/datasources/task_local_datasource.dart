import 'package:isar/isar.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Isar isar;

  TaskLocalDataSourceImpl(this.isar);

  @override
  Future<List<TaskModel>> getTasks() async {
    return await isar.taskModels.where().findAll();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await isar.writeTxn(() async {
      await isar.taskModels.put(task);
    });
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final existingTask = await isar.taskModels
        .filter()
        .taskIdEqualTo(task.taskId)
        .findFirst();
    
    if (existingTask != null) {
      task.id = existingTask.id;
      await isar.writeTxn(() async {
        await isar.taskModels.put(task);
      });
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await isar.writeTxn(() async {
      await isar.taskModels.filter().taskIdEqualTo(taskId).deleteAll();
    });
  }
}