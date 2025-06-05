import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/usecases/usecases_domain.dart';

part 'task_event.dart';
part 'task_state.dart';


class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTask(event.task);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTask(event.taskId);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletion event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTask(updatedTask);
      add(LoadTasks());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}