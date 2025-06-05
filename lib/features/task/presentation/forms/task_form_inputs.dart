import 'package:formz/formz.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task_priority.dart';

// Task Title Input
enum TaskTitleInputError { empty }

class TaskTitleInput extends FormzInput<String, TaskTitleInputError> {
  const TaskTitleInput.pure() : super.pure('');
  const TaskTitleInput.dirty([super.value = '']) : super.dirty();

  @override
  TaskTitleInputError? validator(String? value) {
    if (value?.trim().isEmpty == true || value == null) {
      return TaskTitleInputError.empty;
    }
    return null;
  }

  String get errorText {
    switch (displayError) {
      case TaskTitleInputError.empty:
        return 'El campo es obligatorio';
      case null:
        return '';
    }
  }
}

// Task Priority Input
enum TaskPriorityInputError { empty }

class TaskPriorityInput extends FormzInput<TaskPriority?, TaskPriorityInputError> {
  const TaskPriorityInput.pure() : super.pure(null);
  const TaskPriorityInput.dirty([super.value]) : super.dirty();

  @override
  TaskPriorityInputError? validator(TaskPriority? value) {
    if (value == null) {
      return TaskPriorityInputError.empty;
    }
    return null;
  }

  String get errorText {
    switch (displayError) {
      case TaskPriorityInputError.empty:
        return 'El campo es obligatorio';
      case null:
        return '';
    }
  }
}

// Task Date Input
enum TaskDateInputError { empty }

class TaskDateInput extends FormzInput<DateTime?, TaskDateInputError> {
  const TaskDateInput.pure() : super.pure(null);
  const TaskDateInput.dirty([super.value]) : super.dirty();

  @override
  TaskDateInputError? validator(DateTime? value) {
    if (value == null) {
      return TaskDateInputError.empty;
    }
    return null;
  }

  String get errorText {
    switch (displayError) {
      case TaskDateInputError.empty:
        return 'La fecha es obligatoria';
      case null:
        return '';
    }
  }
}