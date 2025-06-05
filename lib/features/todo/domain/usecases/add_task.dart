
import 'package:todo_list_challenge/features/todo/domain/entities/task.dart';
import 'package:todo_list_challenge/features/todo/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}