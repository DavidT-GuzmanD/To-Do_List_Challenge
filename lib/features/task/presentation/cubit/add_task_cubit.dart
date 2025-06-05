import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task.dart';
import 'package:todo_list_challenge/features/task/domain/entities/task_priority.dart';
import 'package:todo_list_challenge/features/task/presentation/forms/task_form_inputs.dart';
import 'package:uuid/uuid.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit({Task? initialTask})
    : super(
        AddTaskState(
          isEditing: initialTask != null,
          originalTask: initialTask,
          title: TaskTitleInput.dirty(initialTask?.title ?? ''),
          description: initialTask?.description ?? '',
          category: initialTask?.category ?? '',
          selectedDate: TaskDateInput.dirty(
            initialTask?.dueDate ?? DateTime.now(),
          ),
          displayedMonth: initialTask?.dueDate ?? DateTime.now(),
          selectedTime:
              initialTask?.dueTime != null
                  ? TimeOfDay.fromDateTime(initialTask!.dueTime!)
                  : null,
          priority: TaskPriorityInput.dirty(initialTask?.priority),
          selectedIcon: initialTask?.icon ?? '📝',
        ),
      );

  void titleChanged(String value) {
    final title = TaskTitleInput.dirty(value);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate([title, state.priority, state.selectedDate]),
      ),
    );
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void categoryChanged(String value) {
    emit(state.copyWith(category: value));
  }

  void dateSelected(DateTime date) {
    final selectedDate = TaskDateInput.dirty(date);
    emit(
      state.copyWith(
        selectedDate: selectedDate,
        isValid: Formz.validate([state.title, state.priority, selectedDate]),
      ),
    );
  }

  void timeSelected(TimeOfDay? time) {
    emit(state.copyWith(selectedTime: time));
  }

  void prioritySelected(TaskPriority priority) {
    final priorityInput = TaskPriorityInput.dirty(priority);
    emit(
      state.copyWith(
        priority: priorityInput,
        isValid: Formz.validate([
          state.title,
          priorityInput,
          state.selectedDate,
        ]),
      ),
    );
  }

  void iconSelected(String icon) {
    emit(state.copyWith(selectedIcon: icon));
  }

  void monthChanged(DateTime month) {
    emit(state.copyWith(displayedMonth: month));
  }

  void previousMonth() {
    final newMonth = DateTime(
      state.displayedMonth.year,
      state.displayedMonth.month - 1,
    );
    emit(state.copyWith(displayedMonth: newMonth));
  }

  void nextMonth() {
    final newMonth = DateTime(
      state.displayedMonth.year,
      state.displayedMonth.month + 1,
    );
    emit(state.copyWith(displayedMonth: newMonth));
  }

  void clearTime() {
    emit(state.copyWith(selectedTime: null, clearTime: true));
  }

  void clearPriority() {
    final priority = const TaskPriorityInput.dirty(null);
    emit(
      state.copyWith(
        priority: priority,
        isValid: Formz.validate([state.title, priority, state.selectedDate]),
      ),
    );
  }

  Task buildTask() {
    DateTime? dueDateTime;
    if (state.selectedTime != null && state.selectedDate.value != null) {
      dueDateTime = DateTime(
        state.selectedDate.value!.year,
        state.selectedDate.value!.month,
        state.selectedDate.value!.day,
        state.selectedTime!.hour,
        state.selectedTime!.minute,
      );
    }

    return Task(
      id: state.isEditing ? state.originalTask!.id : const Uuid().v4(),
      title: state.title.value.trim(),
      description:
          state.description.trim().isEmpty ? null : state.description.trim(),
      dueDate: state.selectedDate.value ?? DateTime.now(),
      dueTime: dueDateTime,
      priority: state.priority.value ?? TaskPriority.low,
      category: state.category.trim().isEmpty ? null : state.category.trim(),
      icon: state.selectedIcon,
      isCompleted: state.isEditing ? state.originalTask!.isCompleted : false,
      createdAt:
          state.isEditing ? state.originalTask!.createdAt : DateTime.now(),
    );
  }
}
