import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/repositories/calendar_repository.dart';

class GetTasksForMonthUseCase {
  final CalendarRepository repository;

  GetTasksForMonthUseCase(this.repository);

  Future<List<Task>> call(DateTime month) async {
    return await repository.getTasksForMonth(month);
  }
}