part of 'add_task_cubit.dart';


class AddTaskState extends Equatable {
  AddTaskState({
    required this.isEditing,
    this.originalTask,
    this.title = const TaskTitleInput.pure(),
    this.description = '',
    this.category = '',
    this.selectedDate = const TaskDateInput.pure(),
    DateTime? displayedMonth,
    this.selectedTime,
    this.priority = const TaskPriorityInput.pure(),
    this.selectedIcon = '📝',
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  }) : displayedMonth = displayedMonth ?? DateTime.now();

  final bool isEditing;
  final Task? originalTask;
  final TaskTitleInput title;
  final String description;
  final String category;
  final TaskDateInput selectedDate;
  final DateTime displayedMonth;
  final TimeOfDay? selectedTime;
  final TaskPriorityInput priority;
  final String selectedIcon;
  final bool isValid;
  final FormzSubmissionStatus status;

  AddTaskState copyWith({
    bool? isEditing,
    Task? originalTask,
    TaskTitleInput? title,
    String? description,
    String? category,
    TaskDateInput? selectedDate,
    DateTime? displayedMonth,
    TimeOfDay? selectedTime,
    TaskPriorityInput? priority,
    String? selectedIcon,
    bool? isValid,
    FormzSubmissionStatus? status,
    bool clearTime = false,
  }) {
    return AddTaskState(
      isEditing: isEditing ?? this.isEditing,
      originalTask: originalTask ?? this.originalTask,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      selectedDate: selectedDate ?? this.selectedDate,
      displayedMonth: displayedMonth ?? this.displayedMonth,
      selectedTime: clearTime ? null : (selectedTime ?? this.selectedTime),
      priority: priority ?? this.priority,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        isEditing,
        originalTask,
        title,
        description,
        category,
        selectedDate,
        displayedMonth,
        selectedTime,
        priority,
        selectedIcon,
        isValid,
        status,
      ];
}