import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/repositories/calendar_repository.dart';

class GetTasksForDateUseCase {
  final CalendarRepository repository;

  GetTasksForDateUseCase(this.repository);

  Future<List<Task>> call(DateTime date) async {
    return await repository.getTasksForDate(date);
  }
}