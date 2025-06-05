
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
